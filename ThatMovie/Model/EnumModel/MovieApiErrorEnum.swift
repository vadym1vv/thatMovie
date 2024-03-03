//
//  MovieApiError.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.11.2023.
//

import Foundation

enum MovieApiErrorEnum: Error, LocalizedError {
    case invalidURL(description: String)
    case requestFailed
    case jsonParsingFailure
    case invalidStatusCode(statusCode: Int)
    case notFound
    case unknownError(error: Error)
    
    var errorDescription: String? {
        switch self {
        case .requestFailed: return "Network request failed. Please check your internet connection or try again later"
        case .jsonParsingFailure: return "Failed to parse JSON"
        case  .invalidURL( let description): return "The movie data is invalid. Please try again later \n \(description)"
        case  .invalidStatusCode(let statusCode): return "Invalid status code: \(statusCode)"
        case  .notFound: return "Network request failed with 404 status code. It looks like the requested item was deleted or the sent request was not recognized by the server. Please try again later"
        case  .unknownError(let error): return "Unknown error: \(error)"
        }
    }
}
