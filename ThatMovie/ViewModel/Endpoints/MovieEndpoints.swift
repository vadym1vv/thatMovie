//
//  MovieEndpoints.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 30.01.2024.
//

import Foundation

enum MovieEndpoints {
    case discoverByGenre(genreId: Int, page: UrlPage, language: Language), movieDetails(movieId: Int, language: Language), moviesBySearchCriteria(searchCriterias: SearchCriteriaDto, page: UrlPage, language: Language),
         moviesByMovieName(searchCriterias: SearchCriteriaDto, page: UrlPage, language: Language)
    
    public var urlRequest: String {
        switch self {
        case .discoverByGenre(let genreId, let page, let language):
            return "\(StaticEndpoints.baseMovieUrl)/3/discover/movie?with_genres=\(genreId)&\(language.urlLanguageRepresentation)\(page.getUrlPage)"
        case .movieDetails(let movieId, let language):
            return "\(StaticEndpoints.baseMovieUrl)/3/movie/\(movieId)?language=\(language.rawValue)&append_to_response=videos"
        case .moviesBySearchCriteria(let searchCriterias, let page, let language):
            var searchMoviesByCriteriasUrl = "/3/discover/movie?"
            
            //        if let includeAdult = searchCriterias.includeAdult {
            //            searchMoviesByCriteriasUrl += SearchCriteriaEnum.includeAdult(isAdult: includeAdult).urlRepresentation
            //        }
            
            if let sortBy = searchCriterias.sortBy {
                searchMoviesByCriteriasUrl += SearchCriteriaEnum.sortBy(sortBy: sortBy).urlRepresentation
            }
            
            if(searchCriterias.selectedGenres.count > 0) {
                searchMoviesByCriteriasUrl += SearchCriteriaEnum.withGenres(genres: searchCriterias.selectedGenres).urlRepresentation
            }
//            if let searchStr = searchCriterias.searchStr {
//                searchMoviesByNameUrl += SearchCriteriaEnum.byName(byName: searchStr).urlRepresentation
//            }
            
            if let releaseYear = searchCriterias.releaseYear {
                searchMoviesByCriteriasUrl += SearchCriteriaEnum.primaryReleaseYear(releaseYear: String(releaseYear)).urlRepresentation
            }
            return "\(StaticEndpoints.baseMovieUrl)\(searchMoviesByCriteriasUrl)\(language.urlLanguageRepresentation)\(page.getUrlPage)"
        case .moviesByMovieName(let searchCriterias, let page, let language):
            var searchUrl = ""
            var searchMoviesByNameUrl = "/3/search/movie?"
            if let searchStr = searchCriterias.searchStr {
                searchMoviesByNameUrl += SearchCriteriaEnum.byName(byName: searchStr).urlRepresentation
            }
            if let releaseYear = searchCriterias.releaseYear {
                searchMoviesByNameUrl += SearchCriteriaEnum.primaryReleaseYear(releaseYear: "\(releaseYear)").urlRepresentation
            }
            searchUrl += searchMoviesByNameUrl
            return "\(StaticEndpoints.baseMovieUrl)\(searchUrl)\(language.urlLanguageRepresentation)\(page.getUrlPage)"
            
        }
        
    }
    
}
