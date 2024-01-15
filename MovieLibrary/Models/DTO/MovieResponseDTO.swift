//
//  MovieResponseDTO.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 14/01/24.
//

import Foundation

struct MovieResponseDTO: Codable, Identifiable {
    let id: UUID
    let title: String
    let genre: String
    let releaseDate: String
    init(id: UUID, title: String, genre: String, releaseDate: String) {
        self.id = id
        self.title = title
        self.genre = genre
        self.releaseDate = releaseDate
    }
}
