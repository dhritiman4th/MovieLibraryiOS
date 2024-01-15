//
//  LoginResponseDTO.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import Foundation

struct LoginResponseDTO: Codable {
    var uid: UUID? = nil
    var token: String? = nil
    let error: Bool
    var reason: String? = nil
    var name: String? = nil
    
    init(uid: UUID, token: String, error: Bool, reason: String, name: String) {
        self.uid = uid
        self.token = token
        self.error = error
        self.reason = reason
        self.name = name
    }
}
