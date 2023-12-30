//
//  MovieCategory.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 19.12.2023.
//

import Foundation

enum MovieCategory: CaseIterable {
    case watched, planedToWatch, favourites, none
}

extension MovieCategory {
    var titleRepresentation: String {
        switch self {
        case .watched:
            "Watched"
        case .planedToWatch:
            "Planed to watch"
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
        case .planedToWatch:
            return movieItems.filter({$0.personalIsPlanedToWatch || $0.personalDateOfViewing != nil})
        case .none:
            return movieItems
        }
    }
}
