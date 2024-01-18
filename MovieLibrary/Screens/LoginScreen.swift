//
//  LoginView.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import SwiftUI

struct LoginScreen: View {
    @EnvironmentObject var userStateVwModel: UserStateViewModel
    private var movieLibraryModel = MovieLibraryModel()
    @State var username = ""
    @State var password = ""
    @State var showingRegistration = false
    @State var shouldShowAlert = false
    @State var errorMessage = ""
    @State var isAnimating = false
    private var isValidate: Bool {
        !username.isEmpty && !password.isEmpty
    }
    
    func loginUser() async {
        isAnimating = true
        do {
            let loginResponseDTO = try await movieLibraryModel.loginUser(username: username, password: password)
            if !loginResponseDTO.error {
                isAnimating = false
                guard let uid = loginResponseDTO.uid, let token = loginResponseDTO.token else {
                    return
                }
                DispatchQueue.main.async {
                    self.userStateVwModel.saveUid(uid, token: token, name: loginResponseDTO.name)
                }
            } else {
                isAnimating = false
                errorMessage = loginResponseDTO.reason ?? ""
                shouldShowAlert = true
                print("Error = \(String(describing: loginResponseDTO.reason))")
            }
        } catch {
            isAnimating = false
            errorMessage = error.localizedDescription
            shouldShowAlert = true
            print(("Error = \(error.localizedDescription)"))
        }
    }
    
    var body: some View {
        NavigationStack {
            ZStack {
                Form(content: {
                    TextField(text: $username) {
                        Text("Enter username")
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    
                    SecureField(text: $password) {
                        Text("Enter password")
                    }
                    .autocorrectionDisabled()
                    .textInputAutocapitalization(.never)
                    
                    HStack {
                        Button(action: {
                            Task {
                                await loginUser()
                            }
                        }, label: {
                            Text("Login")
                        })
                        .buttonStyle(.borderedProminent)
                        .disabled(!isValidate)
                        Spacer()
                        Button(action: {
                            showingRegistration.toggle()
                        }, label: {
                            Text("Register")
                        })
                        .buttonStyle(.borderedProminent)
                        
                    }
                    .padding()
                })
                ActivityIndicator(isAnimating: $isAnimating, style: .large)
            }
            .navigationTitle("Login")
            .alert(isPresented: $shouldShowAlert, content: {
                Alert(title: Text(Constants.appName), message: Text(errorMessage))
            })
        }
        .sheet(isPresented: $showingRegistration, content: {
            RegistrationScreen()
        })
    }
}

#Preview {
    LoginScreen()
}
