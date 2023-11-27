//
//  RestMovieItem.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.11.2023.
//

import Foundation

//struct MovieRest: Codable {
//    let page: Int
//    let results: [Result]
//    let totalPages, totalResults: Int
//
//    enum CodingKeys: String, CodingKey {
//        case page, results
//        case totalPages = "total_pages"
//        case totalResults = "total_results"
//    }
//}
//
//// MARK: - Result
//struct Result: Codable, Identifiable {
//    let adult: Bool
//    let backdropPath: String
//    let genreIDS: [Int]
//    let id: Int
//    let originalLanguage: String
//    let originalTitle, overview: String
//    let popularity: Double
//    let posterPath, releaseDate, title: String
//    let video: Bool
//    let voteAverage: Double
//    let voteCount: Int
//
//    enum CodingKeys: String, CodingKey {
//        case adult
//        case backdropPath = "backdrop_path"
//        case genreIDS = "genre_ids"
//        case id
//        case originalLanguage = "original_language"
//        case originalTitle = "original_title"
//        case overview, popularity
//        case posterPath = "poster_path"
//        case releaseDate = "release_date"
//        case title, video
//        case voteAverage = "vote_average"
//        case voteCount = "vote_count"
//    }
//}








class MovieRest: Codable {
    let page: Int
    let results: [Result]
    let totalPages, totalResults: Int

    enum CodingKeys: String, CodingKey {
        case page, results
        case totalPages = "total_pages"
        case totalResults = "total_results"
    }
}

// MARK: - Result
class Result: Codable, Identifiable {
    let adult: Bool
    let backdropPath: String?
    let genreIDS: [Int]
    let id: Int
//    let originalLanguage: OriginalLanguage
    let originalTitle, overview: String
    let popularity: Double
    let posterPath, releaseDate, title: String
    let video: Bool
    let voteAverage: Double
    let voteCount: Int

    enum CodingKeys: String, CodingKey {
        case adult
        case backdropPath = "backdrop_path"
        case genreIDS = "genre_ids"
        case id
//        case originalLanguage = "original_language"
        case originalTitle = "original_title"
        case overview, popularity
        case posterPath = "poster_path"
        case releaseDate = "release_date"
        case title, video
        case voteAverage = "vote_average"
        case voteCount = "vote_count"
    }
}

//enum OriginalLanguage: String, Codable {
//    case en = "en"
//    case hi = "hi"
//    case ja = "ja"
//}
