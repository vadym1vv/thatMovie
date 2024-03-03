//
//  SearchCriteriaDto.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 02.12.2023.
//

import Foundation

struct SearchCriteriaDto {
    var searchStr: String?
    var releaseYear: Int?
    var selectedGenres: [MovieGenre] = []
    var sortBy: SortByCriteriaEnum?
    
    init(searchStr: String?, releaseYear: Int?, sortBy: SortByCriteriaEnum?) {
        self.searchStr = searchStr
        self.releaseYear = releaseYear
        self.sortBy = sortBy
    }
    
    init() {
    }

}
