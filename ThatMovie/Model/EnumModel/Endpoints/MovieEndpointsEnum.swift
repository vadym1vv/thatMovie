//
//  MovieEndpoints.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 30.01.2024.
//

import Foundation

enum MovieEndpointsEnum {
    case discoverByGenre(genreId: Int, page: UrlPage), movieDetails(movieId: Int), moviesBySearchCriteria(searchCriterias: SearchCriteriaDto, page: UrlPage),
         moviesByMovieName(searchCriterias: SearchCriteriaDto, page: UrlPage)
    
    public var urlRequest: String {
        switch self {
        case .discoverByGenre(let genreId, let page):
            return "\(StaticEndpoints.baseMovieUrl)/3/discover/movie?with_genres=\(genreId)&language=en\(page.getUrlPage)"
        case .movieDetails(let movieId):
            return "\(StaticEndpoints.baseMovieUrl)/3/movie/\(movieId)?language=en&append_to_response=videos"
        case .moviesBySearchCriteria(let searchCriterias, let page):
            var searchMoviesByCriteriasUrl = "/3/discover/movie?"
            if let sortBy = searchCriterias.sortBy {
                searchMoviesByCriteriasUrl += SearchCriteriaEnum.sortBy(sortBy: sortBy).urlRepresentation
            }
            
            if(searchCriterias.selectedGenres.count > 0) {
                searchMoviesByCriteriasUrl += SearchCriteriaEnum.withGenres(genres: searchCriterias.selectedGenres).urlRepresentation
            }
            if let releaseYear = searchCriterias.releaseYear {
                searchMoviesByCriteriasUrl += SearchCriteriaEnum.primaryReleaseYear(releaseYear: String(releaseYear)).urlRepresentation
            }
            return "\(StaticEndpoints.baseMovieUrl)\(searchMoviesByCriteriasUrl)language=en&\(page.getUrlPage)"
        case .moviesByMovieName(let searchCriterias, let page):
            var searchUrl = ""
            var searchMoviesByNameUrl = "/3/search/movie?"
            if let searchStr = searchCriterias.searchStr {
                searchMoviesByNameUrl += SearchCriteriaEnum.byName(byName: searchStr).urlRepresentation
            }
            if let releaseYear = searchCriterias.releaseYear {
                searchMoviesByNameUrl += SearchCriteriaEnum.primaryReleaseYear(releaseYear: "\(releaseYear)").urlRepresentation
            }
            searchUrl += searchMoviesByNameUrl
            return "\(StaticEndpoints.baseMovieUrl)\(searchUrl)language=en&\(page.getUrlPage)"
        }
        
    }
    
}
