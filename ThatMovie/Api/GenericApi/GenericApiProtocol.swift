//
//  GenericApiService.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 07.11.2023.
//

import Foundation

protocol GenericApiProtocol {
    var session: URLSession {get}
    func fetch<T: Codable> (type: T.Type, with request: URLRequest) async throws -> T
}

//extension GenericApiProtocol {
//    func fetch<T: Codable> (type: T.Type, with request: NSMutableURLRequest) async throws -> T {
//        let (data, response) = try await session.data(for: request as URLRequest)
//        guard let httpResponse = response as? HTTPURLResponse else {
//            throw MovieApiError.requestFailed(description: "")
//        }
//        
//        guard httpResponse.statusCode == 200 else {
//            throw MovieApiError.invalidStatusCode(statusCode: httpResponse.statusCode)
//        }
//        
//        do {
//            let decoder = JSONDecoder()
//            return try decoder.decode(type, from: data)
//        } catch {
//            throw MovieApiError.jsonParsingFailure(description: "\(error.localizedDescription)")
//        }
//    }
//}
