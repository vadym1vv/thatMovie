//
//  RestApiService.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.11.2023.
//

import Foundation

class RestApiService {
    
//    let baseUrl = "https://api.themoviedb.org"
    
    
    let headers = [
      "accept": "application/json",
      "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjUzM2Y0YzExOGEzNGZmZjM1ZmVmZmUxOGFkYzU3ZSIsInN1YiI6IjY1M2Y3NzFkYmMyY2IzMDBjOTdmOWMyYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jBaQlUcjSbvEOX8K56gDJHDOWIlpMh0hS2eeZ1_itMs"
    ]
    
    
    func fetchMoviesByPopularity() async throws -> MovieRest? {
        

        let request = NSMutableURLRequest(url: NSURL(string: "\(ApiUrls.baseUrl)/3/movie/popular?language=en-US&page=1")! as URL,
                                                cachePolicy: .useProtocolCachePolicy,
                                            timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        

        let session = URLSession.shared
        
        
            let (data, response) = try await session.data(for: request as URLRequest)
            
            guard (response as? HTTPURLResponse)?.statusCode == 200 else {
               print("status: \(response)")
                return nil
            }
            
            let popularMovies = try JSONDecoder().decode(MovieRest.self, from: data)
            
            return popularMovies
        
    }
}
