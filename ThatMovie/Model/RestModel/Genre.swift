//
//  Genre.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 24.11.2023.
//

import Foundation

struct Genre: Codable {
    let genres: [MovieGenre]
}

// MARK: - Genre
struct MovieGenre: Codable, Identifiable, Equatable, Hashable {
    let id: Int
    let name: String
}
