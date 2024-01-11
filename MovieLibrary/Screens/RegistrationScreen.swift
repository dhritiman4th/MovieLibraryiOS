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
    private var isValidate: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func registerUser() async {
        do {
            let registerResponseDTO = try await movieLibraryModel.registerUser(username: username, password: password)
            if !registerResponseDTO.error {
                presentation.wrappedValue.dismiss()
            } else {
                print("Error = \(registerResponseDTO.reason)")
            }
        } catch {
            print(("Error = \(error.localizedDescription)"))
        }
    }
    
    var body: some View {
        NavigationStack {
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
            .navigationTitle("Registration")            
        }
    }
}

#Preview {
    RegistrationScreen()
}
