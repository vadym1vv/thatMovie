//
//  RestApiMovieViewModel.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.11.2023.
//

import Foundation

@MainActor
class RestApiMovieVM: ObservableObject {
    
    @Published var movieApiPopular: MovieApiPopular?
    private let restApiService = RestApiService()
    private let clientGenericApi = GenericApiImpl()
    
    init() {
//        Task {
//            
//            await initApi()
////            print(movieApiPopular?.results)
//        }
    }
    
//    func initApi(page: Int) async { as example of custom url
    func initApi() async {
//        do {
//           movieApiPopular = try await restApiService.fetchMoviesByPopularity()
//            print(movieApiPopular)
//        } catch {
//            print("\(error.localizedDescription)")
//        }
        
//        DispatchQueue.main.async {
//            
//        }
        
        do {
            movieApiPopular = try await clientGenericApi.fetch(type: MovieApiPopular.self, with: ApiUrls.popularMoviesUrl(page: 1))
            
        } catch {
            print("ERROR: \(error.localizedDescription)")
        }
    }
}
