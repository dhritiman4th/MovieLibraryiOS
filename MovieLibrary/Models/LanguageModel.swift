//
//  LanguageModel.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 09/01/24.
//

import Foundation

struct LanguageModel: Codable, Identifiable {
    let id: UUID
    let name: String
    init(id: UUID, name: String) {
        self.id = id
        self.name = name
    }
}
