//
//  HttpClient.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import Foundation

struct HttpClient {
    
    var headers: [String: String] {
        var defaultHeaders = ["Content-Type":"application/json"]
        
        guard let token = UserDefaults.standard.value(forKey: Constants.token) as? String else {
            return defaultHeaders
        }
        defaultHeaders["Authorization"] = "Bearer \(token)"
        return defaultHeaders
    }
    
    func loadRequest<T: Codable>(resource: Resource<T>) async throws -> T {
        var request = URLRequest(url: resource.url)
        
        switch resource.method {
        case .get(let queryItems):
            var components = URLComponents(url: resource.url, resolvingAgainstBaseURL: false)
            components?.queryItems = queryItems
            
            guard let url = components?.url else {
                throw NetworkError.badRequest
            }
            request = URLRequest(url: url)
            request.httpMethod = resource.method.name
            
        case .post(let data):
            request.httpMethod = resource.method.name
            request.httpBody = data
            
        case .delete:
            request.httpMethod = resource.method.name
        }
        print("\n-----")
        print("URL = \(String(describing: request.url))")
        print("METHOD = \(request.httpMethod ?? "")")
        print("HEADERS = \(headers)")
        print("BODY = \(String(data: request.httpBody ?? Data(), encoding: .utf8) ?? "")")
        print("-----\n")
        
        let configuration = URLSessionConfiguration.default
        configuration.httpAdditionalHeaders = headers
        let session = URLSession(configuration: configuration)
        
        let (data, response) = try await session.data(for: request)
        print(response)
        print("-----\n")
        guard let _ = response as? HTTPURLResponse else {
            throw NetworkError.invalidResponse
        }
        
        guard let result = try? JSONDecoder().decode(resource.model, from: data) else {
            throw NetworkError.decodingError
        }
        
        return result
    }
}
