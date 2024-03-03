//
//  SortOption.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 19.12.2023.
//

import Foundation

enum SortOptionEnum: String, CaseIterable {
    case title
    case releasedDate
    case addedDate
}

extension SortOptionEnum {
    
    
    func sortBy(movieItems: [MovieItem]) -> [MovieItem] {
        switch self {
        case .title:
            return movieItems.sorted{$0.title.unwrap > $1.title.unwrap}
        case .releasedDate:
            return movieItems.sorted{$0.releaseDate ?? .now > $1.releaseDate ?? .now}
        case .addedDate:
            return movieItems.sorted{$0.personalAddedDate ?? .now > $1.personalAddedDate ?? .now}
        }
    }
    
    var description: String {
        switch self {
        case .title:
            "Title"
        case .releasedDate:
            "Release date"
        case .addedDate:
            "Added date"
        }
    }
}
