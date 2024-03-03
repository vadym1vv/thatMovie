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
