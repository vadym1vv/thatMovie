//
//  SearchCriteriaEnum.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 01.12.2023.
//

import Foundation

enum SearchCriteriaEnum {
    
    
   
    
    case byName(byName: String), includeAdult(isAdult: Bool), primaryReleaseYear(releaseYear: String), sortBy(sortBy: SortByCriteriaEnum), withGenres(genres: [MovieGenre])/*, withKeywords(keywords: String)*//*, withPeople(people: String)*/
    
    public var urlRepresentation: String {
        switch self {
        case .byName(let byName):
            return "query=\(byName)&"
        case .includeAdult(let isAdult):
            return "include_adult=\(isAdult)&"
        case .primaryReleaseYear(let releaseYear):
            return "year=\(releaseYear)&"
        case .sortBy(let sortBy):
            return "sort_by=\(sortBy.urlRepresentation)&"
        case .withGenres(let genres):
            return "with_genres=\((genres.enumerated().map {index, element in index == genres.count - 1 ? "\(element.id)" : "\(element.id)," }).joined())&"
//        case .withKeywords(let keywords):
//            return "with_keywords"
//        case .withPeople(let people):
//            return "with_people"
        }
    }

    
//    public var strRepresentation: String {
//        switch self {
//        case .includeAdult:
//            return "Include adult"
//        case .primaryReleaseYear:
//            return "Release year"
//        case .sortBy:
//            return "Sort by"
//        case .withGenres:
//            return "With genres"
////        case .withKeywords:
////            return "With keywords"
////        case .withPeople:
////            return "With people"
//        }
//    }
}
