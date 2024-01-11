//
//  LanguageListScreen.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import SwiftUI

struct LanguageListScreen: View {
    enum AlertType {
        case errorAlert
        case logoutAlert
        case none
    }
    @EnvironmentObject var userStateViewModel: UserStateViewModel
    private let movieLibraryModel = MovieLibraryModel()
    @State private var shouldShowAlert = false
    @State private var alertMessage = ""
    @State private var languageList: [LanguageModel] = []
    @State private var alertType: AlertType = .none
    @State private var isAddLanguageSheetOpen = false
    @State private var languageName = ""
    
    
    func fetchLanguageList() async {
        do {
            languageList = try await movieLibraryModel.fetchLanguages()
        } catch {
            alertMessage = error.localizedDescription
            shouldShowAlert = true
        }
    }
    
    func addLanguage() async {
        isAddLanguageSheetOpen = false
        guard !languageName.isEmpty else {
            return
        }
        do {
            let addedLanguage = try await movieLibraryModel.addLanguage(name: languageName)
            languageName = ""
            languageList.append(addedLanguage)
        } catch {
            showAlert(message: error.localizedDescription, shouldShow: true)
        }
    }
    
    var body: some View {
        VStack {
            List {
                ForEach(languageList) { lang in
                    Text(lang.name)
                }
            }
        }
        .navigationTitle("Languages(\(userStateViewModel.getUsername() ?? "N/A"))")
        .toolbar(content: {
            Button(action: {
                isAddLanguageSheetOpen.toggle()
            }, label: {
                Image(systemName: "plus")
            })
            Button(action: {
                showAlert(message: "Do you want to logout?", type: .logoutAlert, shouldShow: true)
            }, label: {
                Image(systemName: "rectangle.portrait.and.arrow.forward")
            })
        })
        .onAppear() {
            Task {
                await fetchLanguageList()
            }
        }
        .alert(isPresented: $shouldShowAlert, content: {
            Alert(title: Text(Constants.appName), 
                  message: Text(alertMessage),
                  primaryButton: .destructive(Text("OK"),
                                              action: {
                okButtonClickedInAlert()
            }),
                  secondaryButton: .cancel())
        })
        .sheet(isPresented: $isAddLanguageSheetOpen, content: {
            VStack {
                Spacer(minLength: 20)
                TextField(text: $languageName) {
                    Text("Enter the language name")
                }
                .textFieldStyle(.roundedBorder)
                Spacer(minLength: 20)
                Button(action: {
                    Task {
                        await addLanguage()
                    }
                }, label: {
                    Text("Add")
                })
                .buttonStyle(.borderedProminent)
                .disabled(languageName.count <= 1)
            }
            .padding()
            .frame(height: 200)
            .presentationDetents([.height(200)])
        })
    }
    
    func okButtonClickedInAlert() {
        switch alertType {
        case .logoutAlert:
            DispatchQueue.main.async {
                self.userStateViewModel.removeUidAndToken()
            }
        default:
            break
        }
    }
    
    private func showAlert(message: String, type: AlertType = .none, shouldShow: Bool = false) {
        alertMessage = message
        alertType = type
        shouldShowAlert = shouldShow
    }
}

#Preview {
    NavigationStack {
        LanguageListScreen()
    }
}
