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
    
    func addLanguage(name: String) async throws -> LanguageResponseDTO {
        guard let userIdStr = userStateViewModel.getUidAndToken().0,
                let userId = UUID(uuidString: userIdStr) else {
            throw NetworkError.badRequest
        }
        let postData = ["name": name]
        let resource = Resource(url: Constants.URLS.addLanguage(userId: userId),
                                method: .post(try JSONEncoder().encode(postData)),
                                model: LanguageResponseDTO.self)
        
        let addedLanguage = try await httpClient.loadRequest(resource: resource)
        return addedLanguage
    }
    
    func fetchLanguages() async throws -> [LanguageResponseDTO] {
        guard let userIdStr = userStateViewModel.getUidAndToken().0,
                let userId = UUID(uuidString: userIdStr) else {
            throw NetworkError.badRequest
        }
        let resource = Resource(url: Constants.URLS.getLanguages(userId: userId),
                                method: .get([]),
                                model: [LanguageResponseDTO].self)
        let languageList = try await httpClient.loadRequest(resource: resource)
        return languageList
    }
    
    func addMovie(name: String, genre: String, releaseDate: String, 
                  languageId: UUID) async throws -> MovieResponseDTO {
        guard let userIdStr = userStateViewModel.getUidAndToken().0,
                let userId = UUID(uuidString: userIdStr) else {
            throw NetworkError.badRequest
        }
        
        let postData = ["title": name, "genre": genre, "releaseDate": releaseDate]
        let resource = try Resource(url: Constants.URLS.addMovie(userId: userId, 
                                                                 languageId: languageId),
                                    method: .post(JSONEncoder().encode(postData)),
                                    model: MovieResponseDTO.self)
        let addedMovie = try await httpClient.loadRequest(resource: resource)
        return addedMovie
    }
    
    func fetchMovies(languageId: UUID) async throws -> [MovieResponseDTO] {
        guard let userIdStr = userStateViewModel.getUidAndToken().0,
              let userId = UUID(uuidString: userIdStr) else {
            throw NetworkError.badRequest
        }
        let resource = Resource(url: Constants.URLS.getMovies(userId: userId, 
                                                              languageId: languageId),
                                method: .get([]),
                                model: [MovieResponseDTO].self)
        let movieList = try await httpClient.loadRequest(resource: resource)
        return movieList
    }
    
    func updateMovie(name: String, genre: String, releaseDate: String, languageId: UUID, movieId: UUID) async throws -> MovieResponseDTO {
        guard let userIdStr = userStateViewModel.getUidAndToken().0,
                let userId = UUID(uuidString: userIdStr) else {
            throw NetworkError.badRequest
        }
        let postData = ["title": name, "genre": genre, "releaseDate": releaseDate]
        let resource = Resource(url: Constants.URLS.updateMovie(userId: userId,
                                                                languageId: languageId,
                                                                movieId: movieId),
                                method: .post(try JSONEncoder().encode(postData)),
                                model: MovieResponseDTO.self)
        let updatedMovie = try await httpClient.loadRequest(resource: resource)
        return updatedMovie
    }
    
    func deletedMovie(languageId: UUID, movieId: UUID) async throws -> MovieResponseDTO {
        guard let userIdStr = userStateViewModel.getUidAndToken().0,
                let userId = UUID(uuidString: userIdStr) else {
            throw NetworkError.badRequest
        }
        let resource = Resource(url: Constants.URLS.updateMovie(userId: userId,
                                                                languageId: languageId,
                                                                movieId: movieId),
                                method: .delete,
                                model: MovieResponseDTO.self)
        let deletedMovie = try await httpClient.loadRequest(resource: resource)
        return deletedMovie
    }
}
