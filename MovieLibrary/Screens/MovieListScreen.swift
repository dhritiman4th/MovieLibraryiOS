//
//  MovieListScreen.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 14/01/24.
//

import SwiftUI

struct MovieListScreen: View {
    let selectedLanguageId: UUID
    @State var isAnimating = false
    @State var movieList: [MovieResponseDTO] = []
    @State var shouldShowAlert = false
    @State var errorMessage = ""
    private let movieLibraryModel = MovieLibraryModel()
    @State private var showAddMovieAcreen = false
    @State private var path = NavigationPath()
    private let dateFormatter = DateFormatter()
    
    func fetchMovieList() async {
        isAnimating = true
        do {
            movieList = try await movieLibraryModel.fetchMovies(languageId: selectedLanguageId)
            isAnimating = false
        } catch {
            isAnimating = false
            errorMessage = error.localizedDescription
            shouldShowAlert = true
        }
    }
    
    func deleteMovie(deletedMovieIndex: Int) async {
        isAnimating = true
        let movie = movieList[deletedMovieIndex]
        do {
            let deletedMovie = try await movieLibraryModel.deletedMovie(languageId: selectedLanguageId, movieId: movie.id)
            isAnimating = false
            movieList.remove(at: deletedMovieIndex)
            errorMessage = "\(deletedMovie.title) has been deleted."
            shouldShowAlert = true
        } catch {
            errorMessage = error.localizedDescription
            shouldShowAlert = true
            isAnimating = false
        }
    }
    
    var body: some View {
        ZStack {
            VStack {
                List {
                    ForEach(movieList) { movie in
                        NavigationLink {
                            MovieDetailsScreen(selectedMovie: movie, selectedLanguageId: selectedLanguageId)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(movie.title)
                                    .fontWeight(.bold)
                                    .font(.title)
                                Text(movie.genre)
                                HStack {
                                    Text("Released on")
                                    Text(dateFormatter.string(from: Date(timeIntervalSince1970: Double(movie.releaseDate) ?? 0.0)))
                                }
                            }
                            
                        }
                    }
                    .onDelete { indexSet in
                        let deletedMovieIndex = indexSet.first
                        guard let deletedMovieIndex = deletedMovieIndex else {
                            return
                        }
                        Task {
                            await self.deleteMovie(deletedMovieIndex: deletedMovieIndex)
                        }
                    }
                }
            }
            ActivityIndicator(isAnimating: $isAnimating, style: .large)
        }
        .navigationTitle("Movies")
        .onAppear() {
            dateFormatter.dateFormat = "dd-MMM-YYYY"
            Task {
                await fetchMovieList()
            }
        }
        .toolbar(content: {
            NavigationLink {
                MovieDetailsScreen(selectedLanguageId: selectedLanguageId)
            } label: {
                Image(systemName: "plus")
            }
        })
        .alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text(Constants.appName), message: Text(errorMessage))
        })
    }
}

#Preview {
    NavigationStack {
        MovieListScreen(selectedLanguageId: UUID(), movieList: [MovieResponseDTO(id: UUID(uuidString: "63ac1d28-7ea2-4ca7-9a3a-5d86c2368daa")!, title: "Iron Man", genre: "Science fiction", releaseDate: "15-Mar-2011")])
    }
}
