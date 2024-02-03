//
//  MovieEndpoints.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 16.11.2023.
//

import Foundation

enum GroupedByCategoryMovieEnum: CaseIterable, Identifiable {
    
    var id: Self {self}
    
//    case trending, topRated, genre, movieReviews(_ movieId: Int), upcoming, popular
    case trending, topRated, genre, upcoming, popular
    
//    var path: String {
//        switch self {
//        case .trending:
//            return "/3/trending/movie/day"
//        case .popular:
//            return "/3/movie/popular"
//        case .topRated:
//            return "/3/movie/top_rated"
//        case .genre:
//            return "/3/genre/movie/list"
////        case .movieReviews:
////            return "/3/movie/\(movieId)/reviews?language=en-US&page=1"
//        case .upcoming:
//            return "/3/movie/upcoming"
//        }
//    }
    
    func paginatedPath(page: UrlPage, language: Language) -> String {
        switch self {
        case .trending:
            return "\(StaticEndpoints.baseMovieUrl)/3/trending/movie/day?\(page.getUrlPage)?\(language.urlLanguageRepresentation)"
        case .popular:
            return "\(StaticEndpoints.baseMovieUrl)/3/movie/popular?\(page.getUrlPage)?\(language.urlLanguageRepresentation)"
        case .topRated:
            return "\(StaticEndpoints.baseMovieUrl)/3/movie/top_rated?\(page.getUrlPage)?\(language.urlLanguageRepresentation)"
        case .genre:
            return "\(StaticEndpoints.baseMovieUrl)/3/genre/movie/list?\(page.getUrlPage)?\(language.urlLanguageRepresentation)"
//        case .movieReviews:
//            return "/3/movie/\(movieId)/reviews?language=en-US&page=1"
        case .upcoming:
            return "\(StaticEndpoints.baseMovieUrl)/3/movie/upcoming?\(page.getUrlPage)?\(language.urlLanguageRepresentation)"
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
//        case .movieReviews:
//            return "By Review"
        case .upcoming:
            return "Upcoming"
        case .popular:
            return "Popular"
        }
    }
    
//    var fullPath: String {
//        ApiUrls.baseUrl + path
//    }
}
