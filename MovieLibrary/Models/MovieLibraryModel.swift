//
//  MovieLibraryModel.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import Foundation

class MovieLibraryModel: ObservableObject {
    let httpClient = HttpClient()
    let userStateViewModel = UserStateViewModel()
    
    func registerUser(username: String, password: String) async throws -> RegisterResponseDTO {
        let postData = ["username": username, "password": password]
        let resource = Resource(
            url: Constants.URLS.register,
            method: .post(try JSONEncoder().encode(postData)),
            model: RegisterResponseDTO.self)
        let registerResponse = try await httpClient.loadRequest(resource: resource)
        return registerResponse
    }
    
    func loginUser(username: String, password: String) async throws -> LoginResponseDTO {
        let postData = ["username": username, "password": password]
        let resource = Resource(
            url: Constants.URLS.login,
            method: .post(try JSONEncoder().encode(postData)),
            model: LoginResponseDTO.self)
        let loginResponse = try await httpClient.loadRequest(resource: resource)
        return loginResponse
    }
    
    func addLanguage(name: String) async throws -> LanguageModel {
        guard let userIdStr = userStateViewModel.getUidAndToken().0,
                let userId = UUID(uuidString: userIdStr) else {
            throw NetworkError.badRequest
        }
        let postData = ["name": name]
        let resource = Resource(url: Constants.URLS.addLanguage(userId: userId),
                                method: .post(try JSONEncoder().encode(postData)),
                                model: LanguageModel.self)
        
        let addedLanguage = try await httpClient.loadRequest(resource: resource)
        return addedLanguage
    }
    
    func fetchLanguages() async throws -> [LanguageModel] {
        guard let userIdStr = userStateViewModel.getUidAndToken().0, 
                let userId = UUID(uuidString: userIdStr) else {
            throw NetworkError.badRequest
        }
        let resource = Resource(url: Constants.URLS.getLanguages(userId: userId),
                                method: .get([]),
                                model: [LanguageModel].self)
        let languageList = try await httpClient.loadRequest(resource: resource)
        return languageList
    }
}
