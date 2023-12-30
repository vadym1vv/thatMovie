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
//    var includeAdult: Bool?
    var selectedGenres: [MovieGenre] = []
    var sortBy: SortByCriteriaEnum?
    
    init(searchStr: String?, releaseYear: Int?, /*includeAdult: Bool?,*/ sortBy: SortByCriteriaEnum?) {
        self.searchStr = searchStr
        self.releaseYear = releaseYear
//        self.includeAdult = includeAdult
        self.sortBy = sortBy
    }
    
    init() {
    }

}
