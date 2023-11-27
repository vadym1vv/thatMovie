//
//  MovieApiError.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.11.2023.
//

import Foundation

enum MovieApiError: Error {
    case invalidData
    case jsonParsingFailure(description: String)
    case requestFailed(description: String)
    case invalidStatusCode(statusCode: Int)
    case unknownError(error: Error)
    
    var customDescription: String {
        switch self {
        case .invalidData: return "Invalid data"
        case let .jsonParsingFailure(description): return "failed to parse JSON \(description)"
        case let .requestFailed(description): return "Request failed \(description)"
        case let .invalidStatusCode(statusCode): return "Invalid status code: \(statusCode)"
        case let .unknownError(error): return "Unknown error: \(error)"
        }
    }
}
