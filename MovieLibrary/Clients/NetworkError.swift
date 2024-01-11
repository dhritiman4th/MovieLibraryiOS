//
//  NetworkError.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import Foundation

enum NetworkError: Error {
    case badRequest
    case serverError(String)
    case decodingError
    case invalidResponse
}

extension NetworkError {
    var errorDescription: String {
        switch self {
        case .badRequest:
            return NSLocalizedString("Unable to process the request", comment: "Bad request!!!")
        case .decodingError:
            return NSLocalizedString("Unable to decode successfully", comment: "Decoding error!!!")
        case .invalidResponse:
            return NSLocalizedString("Invalid response", comment: "Invalid response!!!")
        case .serverError(let errorStr):
            return NSLocalizedString(errorStr, comment: "Server error!!!")
        }
    }
}
