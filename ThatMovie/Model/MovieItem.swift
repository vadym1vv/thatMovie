//
//  Item.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import Foundation
import SwiftData

enum Genres: Int, Codable, CaseIterable, Identifiable{
    case ANIMATION
    case ADVENTURE
    case BIOGRAPHY
    case COMEDY
    case CRIME
    case DRAMA
    case DOCUMENTARY
    case FANTASY
    case HISTORICAL
    case HORROR
    case MUSICAL
    case MYSTERY
    case ROMANCE
    case SCIENCEFICTION
    case THRILLER
    case WAR
    case WESTERN
    case UNKNOWN
    var id: Self {self}
}

extension Genres {
    var title: String {
        switch self {
        case .ANIMATION:
            "Animation"
        case .ADVENTURE:
            "Adventure"
        case .BIOGRAPHY:
            "Biography"
        case .COMEDY:
            "Comedy"
        case .CRIME:
            "Crime"
        case .DRAMA:
            "Drama"
        case .DOCUMENTARY:
            "Documentary"
        case .FANTASY:
            "Fantasy"
        case .HISTORICAL:
            "Historical"
        case .HORROR:
            "Horror"
        case .MUSICAL:
            "Musical"
        case .MYSTERY:
            "Mystery"
        case .ROMANCE:
            "Romance"
        case .SCIENCEFICTION:
            "Science Fiction"
        case .THRILLER:
            "Thriller"
        case .WAR:
            "War"
        case .WESTERN:
            "Western"
        case .UNKNOWN:
            "unknown"
        }
    }
}

@Model
final class MovieItem {
    var movieName: String = ""
    
    @Attribute(.externalStorage)
    var banner: Data?
    
    var personalRating: Int = 0
    var dateOfViewing: Date = Date.now
    var dateToWatchAgain: Date?
    var recomendTorewatch: Bool = false
    var source: String?
    var genres: Genres = Genres.UNKNOWN

    init(movieName: String, banner: Data? = nil, personalRating: Int, dateOfViewing: Date, dateToWatchAgain: Date? = nil, recomendTorewatch: Bool, source: String? = nil, genres: Genres) {
        self.movieName = movieName
        self.banner = banner
        self.personalRating = personalRating
        self.dateOfViewing = dateOfViewing
        self.dateToWatchAgain = dateToWatchAgain
        self.recomendTorewatch = recomendTorewatch
        self.source = source
        self.genres = genres
    }

}
