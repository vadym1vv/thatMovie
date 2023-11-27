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
    
    static let headers = [
      "accept": "application/json",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjUzM2Y0YzExOGEzNGZmZjM1ZmVmZmUxOGFkYzU3ZSIsInN1YiI6IjY1M2Y3NzFkYmMyY2IzMDBjOTdmOWMyYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jBaQlUcjSbvEOX8K56gDJHDOWIlpMh0hS2eeZ1_itMs"
    ]
    
    
    
    static func moviesUrl(url: String, page: Int , language: Language) -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)?language=\(language.rawValue)&page=\(page)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
    
    static func moviesUrl(url: String, language: Language) -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: "\(url)?language=\(language.rawValue)")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
}
