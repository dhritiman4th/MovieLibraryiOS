//
//  RegistrationView.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import SwiftUI

struct RegistrationScreen: View {
    private var movieLibraryModel = MovieLibraryModel()
    @State private var username = ""
    @State private var password = ""
    @Environment(\.presentationMode) var presentation
    @State var isAnimating = false
    @State var shouldDisplayAlert = false
    @State var alertMessage = ""
    private var isValidate: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func registerUser() async {
        isAnimating = true
        do {
            let registerResponseDTO = try await movieLibraryModel.registerUser(username: username, password: password)
            isAnimating = false
            if !registerResponseDTO.error {
                presentation.wrappedValue.dismiss()
            } else {
                alertMessage = registerResponseDTO.reason ?? "N/A"
                shouldDisplayAlert = true
            }
        } catch {
            isAnimating = false
            alertMessage = error.localizedDescription
            shouldDisplayAlert = true
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form {
                    TextField(text: $username) {
                        Text("Enter username")
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    TextField(text: $password) {
                        Text("Enter password")
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    
                    HStack {
                        Spacer()
                        Button("Register") {
                            Task {
                                await registerUser()
                            }
                        }
                        .buttonStyle(.borderedProminent)
                        .disabled(!isValidate)
                        Spacer()
                    }
                    .padding()
                }
                ActivityIndicator(isAnimating: $isAnimating, style: .large)
            }
            .navigationTitle("Registration")
            .alert(isPresented: $shouldDisplayAlert, content: {
                Alert(title: Text(Constants.appName), message: Text(alertMessage))
            })
        }
    }
}

#Preview {
    RegistrationScreen()
}
