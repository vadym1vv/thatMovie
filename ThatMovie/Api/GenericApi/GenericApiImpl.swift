//
//  ClientGenericApi.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 07.11.2023.
//

import Foundation

final class GenericApiImpl: GenericApiProtocol {
    
    let session: URLSession
    
    init(configuration: URLSessionConfiguration) {
        self.session = URLSession(configuration: configuration)
    }
    
    convenience init() {
        self.init(configuration: .default)
    }
    
    func fetch<T: Codable> (type: T.Type, with request: URLRequest) async throws -> T {
        
        
        
            let (data, response) = try await session.data(for: request)
            
            guard let httpResponse = response as? HTTPURLResponse else {
                throw MovieApiErrorEnum.requestFailed
            }

            guard httpResponse.statusCode == 200 else {
                if (httpResponse.statusCode == 404) {
                    throw MovieApiErrorEnum.invalidStatusCode(statusCode: httpResponse.statusCode)
                } else {
                    throw MovieApiErrorEnum.invalidStatusCode(statusCode: httpResponse.statusCode)
                }
            }
            
            guard let decodedJsonData = try? JSONDecoder().decode(type, from: data) else {
                throw MovieApiErrorEnum.jsonParsingFailure
            }
            return  decodedJsonData
    }
}
