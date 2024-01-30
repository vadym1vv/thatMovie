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
    @Published var details: Details?
    @Published var filteredMovieRest: MovieRest?
    @Published var movieByGenreRest: [MovieGenre : MovieRest] = [:]
    @Published var movieGenre: Genre?
    
    @Published private(set) var currentNetworkCallState: CurrentLoadingState?
    @Published var currentPage: Int = 1
    @Published var currentURLRequest:  URLRequest?
    
    
    //    @Published var selectedLanguage: Languages = .en
    private let clientGenericApi = GenericApiImpl()
    
    func restBaseMovieApi(url: URLRequest) async {
        defer {currentNetworkCallState = .finished}
        self.currentURLRequest = url
        do {
            self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: url)
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func movieDetails(url: URLRequest) async {
//        defer {currentNetworkCallState = .finished}
//        currentNetworkCallState = .loading
            do {
                self.details = try await clientGenericApi.fetch(type: Details.self, with: url)
            } catch {
                print("ERROR: \(error)")
            }
    }
    
    
    func genreRestBaseMovieApi(url: String) async {
//        defer {currentNetworkCallState = .finished}
//        currentNetworkCallState = .loading
        //        var computedUrl = url/* + selectedLanguage.rawValue*/
        do {
            self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: ApiUrls.moviesUrl(url: url))
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
//        defer {currentNetworkCallState = .finished}
//        currentNetworkCallState = .loading
        do {
            self.movieGenre = try await clientGenericApi.fetch(type: Genre.self, with: ApiUrls.moviesUrl(url: url, language: selectedLanguage))
        } catch {
            print("error: \(error)")
        }
    }
    
    func movieByGenreApi() {
//        defer {currentNetworkCallState = .finished}
//        currentNetworkCallState = .loading
        movieGenre?.genres.forEach { genre in
            Task {
                do {
                    let moviesByGenre: MovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: ApiUrls.moviesByGenreId(genreId: genre.id))
                    self.movieByGenreRest.updateValue(moviesByGenre, forKey: genre)
                } catch {
                    print("error: \(error)")
                }
            }
        }
    }
    
    
    func filterByCriteria(searchCriteriaDto: SearchCriteriaDto) {
        var filteredResults: [Result] = []

        if (movieRest != nil){

                filteredResults = movieRest!.results
                
                if let searchStr = searchCriteriaDto.searchStr {
                        filteredResults = filteredResults.filter{$0.title != nil && $0.title!.contains(searchStr)}
                }
                
                if let releaseYear = searchCriteriaDto.releaseYear {
                    filteredResults.forEach { date in
                        print(date.releaseDate!)
                    }
                    filteredResults = filteredResults.filter{$0.releaseDate != nil && $0.releaseDate!.contains(String(releaseYear))}
                }
            
                if (searchCriteriaDto.selectedGenres.count > 0) {
                    filteredResults = filteredResults.filter{$0.genreIDS != nil && $0.genreIDS!.contains { id in
                        searchCriteriaDto.selectedGenres.map{$0.id}.contains(id)
                    }}
                }
            
            if let sortBy = searchCriteriaDto.sortBy {
                filteredResults = sortBy.sortByCriteria(results: filteredResults)
            }
            
            if (filteredResults.isEmpty) {
                filteredMovieRest = MovieRest(page: 1, results: [], totalPages: 1, totalResults: 1)
            } else {
                filteredMovieRest = MovieRest(page: 1, results: filteredResults, totalPages: 1, totalResults: 1)
            }
        }

    }
}

extension RestApiMovieVM {
    enum CurrentLoadingState {
        case fetching
        case loading
        case finished
    }
}
