//
//  Item.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import Foundation
import SwiftData

@Model
final class MovieItem {
    var id: Int?
    var genreIDS: [Int]?
    var title: String?
    var posterPath: String?
    var releaseDate: Date?
    var personalRating: Int?
    var personalDateOfViewing: Date?
    var personalDateToWatch: Date?
    var personalLastWatchedDate: Date?
    var personalIsPlannedToWatch: Bool = false
    var personalAddedDate: Date?
    var personalIsFavourite: Bool = false
    
    init(id: Int? = nil, genreIDS: [Int]? = nil, title: String? = nil, posterPath: String? = nil, releaseDate: Date? = nil, personalRating: Int? = nil, personalDateOfViewing: Date? = nil, personalDateToWatch: Date? = nil, personalLastWatchedDate: Date? = nil, personalIsPlannedToWatch: Bool = false, personaladdedDate: Date? = nil, personalIsFavourite: Bool = false) {
        self.id = id
        self.genreIDS = genreIDS
        self.title = title
        self.posterPath = posterPath
        self.releaseDate = releaseDate
        self.personalRating = personalRating
        self.personalDateOfViewing = personalDateOfViewing
        self.personalDateToWatch = personalDateToWatch
        self.personalLastWatchedDate = personalLastWatchedDate
        self.personalIsPlannedToWatch = personalIsPlannedToWatch
        self.personalAddedDate = personaladdedDate
        self.personalIsFavourite = personalIsFavourite
    }
    
    
}
