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
    static private let headers = [
        "accept": "application/json",
        "Authorization": "Bearer eyJhbGciOiJIUzI1NiJ9.eyJhdWQiOiI4YzBlZTUwODNiYmQwNTY0NmNlNzk5NjYyNmNmOWYxOCIsInN1YiI6IjY1ZGMzZTBlYTM1YzhlMDE4NjE0OTRjZCIsInNjb3BlcyI6WyJhcGlfcmVhZCJdLCJ2ZXJzaW9uIjoxfQ.NMJc-bSpqvH4CnTfQ8T7JAPDYcqRDE3tsvCEYp0UJ68"
    ]
}
