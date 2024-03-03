//
//  SearchCriteriaEnum.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 01.12.2023.
//

import Foundation

enum SearchCriteriaEnum {
    
    case byName(byName: String), primaryReleaseYear(releaseYear: String), sortBy(sortBy: SortByCriteriaEnum), withGenres(genres: [MovieGenre])
    
    public var urlRepresentation: String {
        switch self {
        case .byName(let byName):
            return "query=\(byName)&"
        case .primaryReleaseYear(let releaseYear):
            return "year=\(releaseYear)&"
        case .sortBy(let sortBy):
            return "sort_by=\(sortBy.urlRepresentation)&"
        case .withGenres(let genres):
            return "with_genres=\((genres.enumerated().map {index, element in index == genres.count - 1 ? "\(element.id)" : "\(element.id)," }).joined())&"
        }
    }
}
