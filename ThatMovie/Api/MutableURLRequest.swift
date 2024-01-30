//
//  MutableURLRequest.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 30.01.2024.
//

import Foundation

struct MutableURLRequest {
    static func baseMutableGetURLRequest(url: String) -> URLRequest {
        let request = NSMutableURLRequest(url: NSURL(string: url)! as URL,
                                          cachePolicy: .useProtocolCachePolicy,
                                          timeoutInterval: 10.0)
        request.httpMethod = "GET"
        request.allHTTPHeaderFields = headers
        return request as URLRequest
    }
}

extension MutableURLRequest {
    static let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiJiMjUzM2Y0YzExOGEzNGZmZjM1ZmVmZmUxOGFkYzU3ZSIsInN1YiI6IjY1M2Y3NzFkYmMyY2IzMDBjOTdmOWMyYSIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.jBaQlUcjSbvEOX8K56gDJHDOWIlpMh0hS2eeZ1_itMs"
    ]
}
