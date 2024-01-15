//
//  Constants.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import Foundation

enum HostType {
    case localhost
    case remoteHost
}

struct Constants {
    static let appName: String = "Movie Library"
    static let hostType: HostType = .localhost
    
    private static var baseUrlString: String {
        switch hostType {
        case .localhost: 
            return "http://127.0.0.1:8080/api"
        case .remoteHost: 
            return ""
        }
    }
    
    struct URLS {
        static let register = URL(string: "\(baseUrlString)/register")!
        static let login = URL(string: "\(baseUrlString)/login")!
        
        static func addLanguage(userId: UUID) -> URL {
            return URL(string: "\(baseUrlString)/users/\(userId.uuidString)/languages")!
        }
        static func getLanguages(userId: UUID) -> URL {
            return URL(string: "\(baseUrlString)/users/\(userId.uuidString)/languages")!
        }
        static func addMovie(userId: UUID, languageId: UUID) -> URL {
            return URL(string: "\(baseUrlString)/users/\(userId)/languages/\(languageId)/movies")!
        }
        static func getMovies(userId: UUID, languageId: UUID) -> URL {
            return URL(string: "\(baseUrlString)/users/\(userId)/languages/\(languageId)/movies")!
        }
    }
    
    static let token: String = "token"
    static let uid: String = "uid"
    static let name: String = "name"
}
