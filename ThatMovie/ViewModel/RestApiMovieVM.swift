//
//  RestApiMovieViewModel.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.11.2023.
//

import Foundation

@MainActor
class RestApiMovieVM: ObservableObject {
    
    @Published var movieRest: MovieRest?
    @Published var movieGenre: Genre?
    
//    @Published var selectedLanguage: Languages = .en

    
    private let restApiService = RestApiService()
    private let clientGenericApi = GenericApiImpl()

    
    func restBaseMovieApi(url: String, selectedLanguage: Language, page: Int) async {
//        var computedUrl = url/* + selectedLanguage.rawValue*/
        do {
                self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: ApiUrls.moviesUrl(url: url, page: page, language: selectedLanguage))
//            movieRest?.results.forEach{ result in
//                print(result.title)
//            }
//            print("--++++---")
//            print(url)
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    
    func genreRestBaseMovieApi(url: String, selectedLanguage: Language, page: Int) async {
//        var computedUrl = url/* + selectedLanguage.rawValue*/
        do {
            self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: ApiUrls.moviesUrl(url: url, page: page, language: selectedLanguage))
//            movieRest?.results.forEach{  result in
//                print(result.title)
//            }
//            print("--++++---")
//            print(url)
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func restMovieGenreListApi(url: String, selectedLanguage: Language) async {
        do {
            self.movieGenre = try await clientGenericApi.fetch(type: Genre.self, with: ApiUrls.moviesUrl(url: url, language: selectedLanguage))
        } catch {
            print("error: \(error)")
        }
    }
}
