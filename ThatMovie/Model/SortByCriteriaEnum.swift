//
//  SortByCriteriaEnum.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 01.12.2023.
//

import Foundation

enum SortByCriteriaEnum: Identifiable, CaseIterable {
    var id: Self {self}
    case notSelected, popularityAsc, popularityDesc, /*revenueAsc, revenueDesc,*/ primaryReleaseDateAsc, primaryReleaseDateDesc, voteAverageAsc, voteAverageDesc /*,voteCountAsc, voteCountDesc*/
    
    var urlRepresentation: String {
        switch self {
        case .notSelected:
            return ""
        case .popularityAsc:
            return "popularity.asc"
        case .popularityDesc:
            return "popularity.desc"
//        case .revenueAsc:
//            return "revenue.asc"
//        case .revenueDesc:
//            return "revenue.desc"
        case .primaryReleaseDateAsc:
            return "primary_release_date.asc"
        case .primaryReleaseDateDesc:
            return "primary_release_date.desc"
        case .voteAverageAsc:
            return "vote_average.asc"
        case .voteAverageDesc:
            return "vote_average.desc"
//        case .voteCountAsc:
//            return "vote_count.asc"
//        case .voteCountDesc:
//            return "vote_count.desc"
        }
    }
    
    var strRepresentation: String {
        switch self {
        case .notSelected:
            return "Not selected"
        case .popularityAsc:
            return "Popularity asc"
        case .popularityDesc:
            return "Popularity desc"
//        case .revenueAsc:
//            return "Revenue asc"
//        case .revenueDesc:
//            return "Revenue desc"
        case .primaryReleaseDateAsc:
            return "Primary release date asc"
        case .primaryReleaseDateDesc:
            return "Primary release date desc"
        case .voteAverageAsc:
            return "Vote average asc"
        case .voteAverageDesc:
            return "Vote average desc"
//        case .voteCountAsc:
//            return "Vote count asc"
//        case .voteCountDesc:
//            return "Vote count desc"
        }
    }
    
    public func sortByCriteria(results: [Result]) -> [Result] {
        let sorterResults: [Result] =  switch self {
        case .notSelected:
             results
        case .popularityAsc:
             results.sorted(by: {$0.popularity! > $1.popularity!})
        case .popularityDesc:
             results.sorted(by: {$0.popularity! < $1.popularity!})
        case .primaryReleaseDateAsc:
             results.sorted(by: {$0.releaseDate! > $1.releaseDate!})
        case .primaryReleaseDateDesc:
             results.sorted(by: {$0.releaseDate! < $1.releaseDate!})
        case .voteAverageAsc:
             results.sorted(by: {$0.voteAverage! > $1.voteAverage!})
        case .voteAverageDesc:
             results.sorted(by: {$0.voteAverage! < $1.voteAverage!})
        }
        return sorterResults
    }
    
}
