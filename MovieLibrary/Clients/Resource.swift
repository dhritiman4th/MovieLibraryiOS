//
//  Resource.swift
//  MovieLibrary
//
//  Created by Dhritiman Saha on 04/01/24.
//

import Foundation

struct Resource<T: Codable> {
    var url: URL
    var method: HttpMethod
    var model: T.Type
}
