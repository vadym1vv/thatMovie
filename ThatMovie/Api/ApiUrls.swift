//
//  ApiUrls.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 07.11.2023.
//

import Foundation

class ApiUrls {
    
    static let baseUrl = "https://api.themoviedb.org"
    static let baseImageUrl = "https://image.tmdb.org/t/p/original"
    static let baseGenreUrl = "/3/discover/movie?with_genres="
    
    static let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjUzM2Y0YzExOGEzNGZmZjM1ZmVmZmUxOGFkYzU3ZSIsInN1YiI6IjY1M2Y3NzFkYmMyY2IzMDBjOTdmOWMyYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jBaQlUcjSbvEOX8K56gDJHDOWIlpMh0hS2eeZ1_itMs"
    ]
    
    
    
    static func moviesUrl(url: String, page: Int , language: Language) -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "\(baseUrl)\(url)?language=\(language.rawValue)&page=\(page)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
    
    static func moviesUrl(url: String, language: Language) -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "\(baseUrl)\(url)?language=\(language.rawValue)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
    
    static func moviesUrl(url: String) -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "\(baseUrl)\(url)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
    
    static func moviesByGenreId(genreId: Int) -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "\(baseUrl)\(baseGenreUrl)\(genreId)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }

//https://api.themoviedb.org/3/discover/movie?include_adult=true&include_video=false&language=en-US&page=1&sort_by=revenue.asc&with_genres=28&year=2020
    static func moviesBySearchCriteria(searchCriterias: SearchCriteriaDto, page: UrlPage, language: Language) -> URLRequest {
        
        var searchMoviesByCriteriasUrl = "/3/discover/movie?"
//        var sortByOption: String = ""
//        var releaseYear = ""
        
        if let includeAdult = searchCriterias.includeAdult {
            searchMoviesByCriteriasUrl += SearchCriteriaEnum.includeAdult(isAdult: includeAdult).urlRepresentation
        }
        
        if let sortBy = searchCriterias.sortBy {
            searchMoviesByCriteriasUrl += SearchCriteriaEnum.sortBy(sortBy: sortBy).urlRepresentation
        }
        
        if(searchCriterias.selectedGenres.count > 0) {
            searchMoviesByCriteriasUrl += SearchCriteriaEnum.withGenres(genres: searchCriterias.selectedGenres).urlRepresentation
        }
        
        if let releaseYear = searchCriterias.releaseYear {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy"
            let year = dateFormatter.string(from: releaseYear)
            
            searchMoviesByCriteriasUrl += SearchCriteriaEnum.primaryReleaseYear(releaseYear: year).urlRepresentation
        }
        
        
        let request = NSMutableURLRequest(url: NSURL(string: "\(baseUrl)\(searchMoviesByCriteriasUrl)\(language.urlLanguageRepresentation)\(page.getUrlPage)")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
    
    
    
    
    
    static func moviesByMovieName(searchCriterias: SearchCriteriaDto, page: Int, language: Language) -> URLRequest {
        var searchUrl = ""
            var searchMoviesByNameUrl = "/3/search/movie?"
            if let searchStr = searchCriterias.searchStr {
                searchMoviesByNameUrl += SearchCriteriaEnum.byName(byName: searchStr).urlRepresentation
            }
            searchUrl += searchMoviesByNameUrl
        let request = NSMutableURLRequest(url: NSURL(string: "\(baseUrl)\(searchUrl)&include_adult=false&language=en-US&page=1")! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
}
