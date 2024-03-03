//
//  GroupedByCategoryMovieEnum.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 23.02.2024.
//

import Foundation

//
//  MovieEndpoints.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 16.11.2023.
//

import Foundation

enum GroupedByCategoryMovieEnum: CaseIterable, Identifiable {
    
    var id: Self {self}
    
    case trending, topRated, genre, upcoming, popular

    func paginatedPath(page: UrlPage) -> String {
        switch self {
        case .trending:
            return "\(StaticEndpoints.baseMovieUrl)/3/trending/movie/day?\(page.getUrlPage)?language=en&"
        case .popular:
            return "\(StaticEndpoints.baseMovieUrl)/3/movie/popular?\(page.getUrlPage)?language=en&"
        case .topRated:
            return "\(StaticEndpoints.baseMovieUrl)/3/movie/top_rated?\(page.getUrlPage)?language=en&"
        case .genre:
            return "\(StaticEndpoints.baseMovieUrl)/3/genre/movie/list?\(page.getUrlPage)?language=en&"
        case .upcoming:
            return "\(StaticEndpoints.baseMovieUrl)/3/movie/upcoming?\(page.getUrlPage)?language=en&"
        }
    }
    
    
    public var movieSection: String {
        switch self {
        case .trending:
            return "Trending"
        case .topRated:
            return "Top rated"
        case .genre:
            return "Genres"
        case .upcoming:
            return "Upcoming"
        case .popular:
            return "Popular"
        }
    }

}
