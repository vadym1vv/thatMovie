//
//  ClientGenericApi.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 07.11.2023.
//

import Foundation

final class GenericApiImpl: GenericApiProtocol {
    
    let session: URLSession
//    let configuration: URLSessionConfiguration
    
    init(configuration: URLSessionConfiguration) {
     self.session = URLSession(configuration: configuration)
    }

    convenience init() {
     self.init(configuration: .default)
    }
    
    func fetch<T: Codable> (type: T.Type, with request: URLRequest) async throws -> T {
        print(request.url)
        let (data, response) = try await session.data(for: request)
        print(data)
        guard let httpResponse = response as? HTTPURLResponse else {
            throw MovieApiError.requestFailed(description: "")
        }
        
        guard httpResponse.statusCode == 200 else {
            throw MovieApiError.invalidStatusCode(statusCode: httpResponse.statusCode)
        }
            let decoder = JSONDecoder()
            return try decoder.decode(type, from: data)
    }
}
