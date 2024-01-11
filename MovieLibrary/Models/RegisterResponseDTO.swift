//
//  RegisterResponseDTO.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import Foundation

struct RegisterResponseDTO: Codable {
    let error: Bool
    var reason: String? = nil
    
    init(error: Bool, reason: String) {
        self.error = error
        self.reason = reason
    }
}
