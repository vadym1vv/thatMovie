//
//  UserPageViewModel.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 18.12.2023.
//

import Foundation

class UserPageViewModel: ObservableObject {
    @Published var filteredResults: [MovieItem]?
    
    func filterBy(movieItems: [MovieItem], searchQuery: String?) {
        var results: [MovieItem] = []
        if let strToSearch = searchQuery {
            results = movieItems.filter({$0.title!.contains(strToSearch)})
        }
        filteredResults = results
    }
    
    func sortedMovies(movieItems: [MovieItem], selectedSortOption: SortOptionEnum) -> [MovieItem] {
        return selectedSortOption.sortBy(movieItems: movieItems)
    }
}
