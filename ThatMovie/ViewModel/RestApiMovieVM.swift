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
    @Published var filteredMovieRest: MovieRest?
    @Published var details: Details?
    @Published var movieGenre: Genre?
    
    //    @Published var filteredMovieRest: MovieRest?
    @Published var movieByGenreRest: [MovieGenre : MovieRest] = [:]
    
    
    @Published private(set) var currentNetworkCallState: CurrentLoadingState?
    @Published var currentPage: Int = 1
    @Published var currentMovieCategoryEndpoint:  GroupedByCategoryMovieEnum?
    @Published var currentMovieGenreEndpoint: MovieGenre?
    
    @Published var searchCriteriaDto: SearchCriteriaDto?
    
    //    @Published var selectedLanguage: Languages = .en
    private let clientGenericApi = GenericApiImpl()
    
    func restSearchMovieApi(url: String) async {
        defer {currentNetworkCallState = .finished}
        
        do {
            self.filteredMovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: url))
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func restBaseMovieApi(url: String) async {
        defer {currentNetworkCallState = .finished}
        
        do {
            self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: url))
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func genreRestBaseMovieApi(url: String) async {
        defer {currentNetworkCallState = .finished}
        
        do {
            self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: url))
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    
    
    func loadNextMoviesBySearchCriteria() async {
        defer {currentNetworkCallState = .finished}
        var searchUrl: String?
        if(searchCriteriaDto != nil && filteredMovieRest != nil) {
            
            if (searchCriteriaDto!.searchStr != nil) {
                searchUrl = MovieEndpoints.moviesByMovieName(searchCriterias: searchCriteriaDto!, page: UrlPage(page: filteredMovieRest!.page + 1), language: .en).urlRequest
            } else {
                searchUrl = MovieEndpoints.moviesBySearchCriteria(searchCriterias: searchCriteriaDto!, page: UrlPage(page: filteredMovieRest!.page + 1), language: .en).urlRequest
            }
        }
        
        if let searchUrl = searchUrl {
            do {
                var nextMovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: searchUrl))
                nextMovieRest.results.insert(contentsOf: filteredMovieRest!.results, at: 0)
                self.filteredMovieRest = nextMovieRest
            } catch {
                print("ERROR: \(error)")
            }
        }
    }
    
    func loadNextMovieByGenreInGenreList(currentGenre: MovieGenre) async {
        do {
            if let currentMovie = self.movieByGenreRest[currentGenre] {
                var moviesByGenre: MovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with:  MutableURLRequest.baseMutableGetURLRequest(url: MovieEndpoints.discoverByGenre(genreId: currentGenre.id, page: UrlPage(page: currentMovie.page + 1), language: .en).urlRequest))
                
                moviesByGenre.results.insert(contentsOf: currentMovie.results, at: 0)
                self.movieByGenreRest.updateValue(moviesByGenre, forKey: currentGenre)
            }
            
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func loadNextMovieBySingleGenre() async {
        do {
            if let currentMovieGenreEndpoint = self.currentMovieGenreEndpoint {
                if let movieRest = movieRest {
                    var nextMovieBySingleGenre = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url:MovieEndpoints.discoverByGenre(genreId: currentMovieGenreEndpoint.id, page: UrlPage(page: movieRest.page + 1), language: .en).urlRequest))
                    nextMovieBySingleGenre.results.insert(contentsOf: movieRest.results, at: 0)
                    self.movieRest = nextMovieBySingleGenre
                }
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func loadNextMovieByCurrentMovieCategoryEndpoint() async {
//        var lastMovieInCurrentMovieCategory: Result?
        defer {
            
            currentNetworkCallState = .finished
//            if let lastMovie = lastMovieInCurrentMovieCategory {
//                print("(((((append last movie \(lastMovie.title))))))))))))))")
//                movieRest?.results.append(lastMovie)
//            }
            
        }
        
        do {
            if let currentMovieCategoryEndpoint = self.currentMovieCategoryEndpoint {
                if let movieRest = movieRest {
                    var currentMovieCategory = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: currentMovieCategoryEndpoint.paginatedPath(page: UrlPage(page: movieRest.page + 1), language: .en)))
//                    lastMovieInCurrentMovieCategory = currentMovieCategory.results.popLast()
                    currentMovieCategory.results.insert(contentsOf: movieRest.results, at: 0)
                    self.movieRest = currentMovieCategory
                }
            }
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    func movieByGenreApi() {
//        defer {currentNetworkCallState = .finished}
//        currentNetworkCallState = .loading
        movieGenre?.genres.forEach { genre in
            Task {
                do {
                    let moviesByGenre: MovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with:  MutableURLRequest.baseMutableGetURLRequest(url:MovieEndpoints.discoverByGenre(genreId: genre.id, page: UrlPage(page: 1), language: .en).urlRequest))
                    self.movieByGenreRest.updateValue(moviesByGenre, forKey: genre)
                } catch {
                    print("error: \(error)")
                }
            }
        }
    }
    
    func movieDetails(url: String) async {
            do {
                self.details = try await clientGenericApi.fetch(type: Details.self, with: MutableURLRequest.baseMutableGetURLRequest(url: url))
            } catch {
                print("ERROR: \(error)")
            }
    }
    
    
    
    func restMovieGenreListApi(urlRequest: String) async {
//        defer {currentNetworkCallState = .finished}
//        currentNetworkCallState = .loading
        do {
            self.movieGenre = try await clientGenericApi.fetch(type: Genre.self, with: MutableURLRequest.baseMutableGetURLRequest(url: urlRequest))
        } catch {
            print("error: \(error)")
        }
    }
    
    
    
    
    
    
    
//    func filterByCriteria(searchCriteriaDto: SearchCriteriaDto) {
//        var filteredResults: [Result] = []
//
//        if (movieRest != nil){
//
//                filteredResults = movieRest!.results
//                
//                if let searchStr = searchCriteriaDto.searchStr {
//                        filteredResults = filteredResults.filter{$0.title != nil && $0.title!.contains(searchStr)}
//                }
//                
//                if let releaseYear = searchCriteriaDto.releaseYear {
//                    filteredResults.forEach { date in
//                        print(date.releaseDate!)
//                    }
//                    filteredResults = filteredResults.filter{$0.releaseDate != nil && $0.releaseDate!.contains(String(releaseYear))}
//                }
//            
//                if (searchCriteriaDto.selectedGenres.count > 0) {
//                    filteredResults = filteredResults.filter{$0.genreIDS != nil && $0.genreIDS!.contains { id in
//                        searchCriteriaDto.selectedGenres.map{$0.id}.contains(id)
//                    }}
//                }
//            
//            if let sortBy = searchCriteriaDto.sortBy {
//                filteredResults = sortBy.sortByCriteria(results: filteredResults)
//            }
//            
//            if (filteredResults.isEmpty) {
//                filteredMovieRest = MovieRest(page: 1, results: [], totalPages: 1, totalResults: 1)
//            } else {
//                filteredMovieRest = MovieRest(page: 1, results: filteredResults, totalPages: 1, totalResults: 1)
//            }
//        }
//
//    }
}

extension RestApiMovieVM {
    enum CurrentLoadingState {
        case fetching
        case loading
        case finished
    }
}
