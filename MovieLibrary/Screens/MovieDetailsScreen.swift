//
//  MovieDetailsScreen.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 15/01/24.
//

import SwiftUI

struct MovieDetailsScreen: View {
    var selectedMovie: MovieResponseDTO? = nil
    var selectedLanguageId: UUID? = nil
    @State private var movieTitle = ""
    @State private var genre = "Action"
    @State private var isAnimating = false
    @State private var alertMessage = ""
    @State private var shouldShowAlert = false
    private let movieLibraryModel = MovieLibraryModel()
    @Environment(\.presentationMode) private var presentation
    var customGenres = ["Action", "Adventure", "Comedy", "Drama", "Fantasy", "Horror", "Musicals", "Myster", "Romance", "Science fiction", "Sports", "Thriller", "Western"]
    @State var selectedReleaseDate = Date.now
    let dateFormatter = DateFormatter()
    
    func addMovie() async {
        isAnimating = true
        guard let selectedLanguageId = selectedLanguageId else {
            alertMessage = "Selected language is invalid"
            shouldShowAlert = true
            isAnimating = false
            return
        }
        do {
            let addedMovie = try await movieLibraryModel.addMovie(name: movieTitle,
                                                                  genre: genre,
                                                                  releaseDate: dateFormatter.string(from: selectedReleaseDate),
                                                                  languageId: selectedLanguageId)
            isAnimating = false
            DispatchQueue.main.async {
                self.presentation.wrappedValue.dismiss()
            }
        } catch {
            alertMessage = error.localizedDescription
            shouldShowAlert = true
            isAnimating = false
        }
    }
    
    func updateMovie() async {
        DispatchQueue.main.async {
            self.presentation.wrappedValue.dismiss()
        }
    }
    
    var body: some View {
        ZStack {
            Form {
                TextField(text: $movieTitle) {
                    Text("Enter movie title")
                }
                HStack {
                    Text("Movie genre")
                    Spacer()
                    Picker("", selection: $genre) {
                        ForEach(customGenres, id: \.self) { genre in
                            Text(genre)
                        }
                    }
                }
                HStack {
                    Text("Release date")
                    DatePicker(selection: $selectedReleaseDate, displayedComponents: [.date]) {
                        EmptyView()
                    }
                }
                HStack {
                    Spacer()
                    Button(action: {
                        Task {
                            (selectedMovie != nil) ? await updateMovie() : await addMovie()
                        }
                    }, label: {
                        Text((selectedMovie != nil) ? "Update movie" : "Add movie")
                    })
                    .buttonStyle(.borderedProminent)
                    Spacer()
                }
                .padding()
            }
            ActivityIndicator(isAnimating: $isAnimating, style: .large)
        }
        .navigationTitle((selectedMovie != nil) ? "Update movie" : "Add movie")
        .onAppear() {
            dateFormatter.dateFormat = "dd-MMM-YYYY"
            if selectedMovie != nil {
                movieTitle = selectedMovie?.title ?? ""
                genre = selectedMovie?.genre ?? ""
                if let dateStr = selectedMovie?.releaseDate {
                    selectedReleaseDate = Date(timeIntervalSince1970: Double(dateStr) ?? 0.0)
                } else {
                    selectedReleaseDate = Date.now
                }
            }
        }
        .alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text(Constants.appName), message: Text(alertMessage))
        })
    }
    
}

#Preview {
    NavigationStack {
        MovieDetailsScreen()
    }
}
