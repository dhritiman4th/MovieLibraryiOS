//
//  MovieLibraryApp.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import SwiftUI

@main
struct MovieLibraryApp: App {
    @StateObject var userStateVwModel = UserStateViewModel()

    var body: some Scene {
        WindowGroup {
            NavigationStack {
                if userStateVwModel.isLoggedIn {
                    LanguageListScreen()
                } else {
                    LoginScreen()
                }
            }
            .environmentObject(userStateVwModel)
            .onAppear {
                print(userStateVwModel.getUidAndToken().0)
            }
        }
    }
}
