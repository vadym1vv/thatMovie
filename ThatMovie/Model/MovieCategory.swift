//
//  MovieCategory.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 19.12.2023.
//

import Foundation

enum MovieCategory: CaseIterable {
    case watched, plannedToWatch, favourites, none
}

extension MovieCategory {
    var titleRepresentation: String {
        switch self {
        case .watched:
            "Watched"
        case .plannedToWatch:
            "Scheduled"
        case .favourites:
            "Favourites"
        case .none:
            ""
        }
    }
    
    func filterByPageCategory(movieItems: [MovieItem]) -> [MovieItem] {
        switch self {
        case .watched:
            return movieItems.filter({$0.personalDateOfViewing != nil})
        case .favourites:
            return movieItems.filter({$0.personalIsFavourite})
        case .plannedToWatch:
            return movieItems.filter({$0.personalIsPlannedToWatch || $0.personalDateToWatch != nil})
        case .none:
            return movieItems
        }
    }
    
    func deleteMovieByCurrentCategory(movieItem: MovieItem) {
        switch self {
        case .watched:
            movieItem.personalDateOfViewing = nil
        case .plannedToWatch:
            if(movieItem.personalDateToWatch != nil && movieItem.id != nil) {
                NotificationVM().removePendingNotification(identifier: String(movieItem.id!))
            }
            movieItem.personalDateToWatch = nil
            movieItem.personalIsPlannedToWatch = false
        case .favourites:
            movieItem.personalIsFavourite = false
        case .none: break
        }
    }
}
