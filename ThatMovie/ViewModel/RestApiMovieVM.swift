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
    @Published var movieByGenreRest: [MovieGenre : MovieRest] = [:]
    @Published private(set) var currentNetworkCallState: CurrentLoadingState?
    @Published var currentPage: Int = 1
    @Published var currentMovieCategoryEndpoint:  GroupedByCategoryMovieEnum?
    @Published var currentMovieGenreEndpoint: MovieGenre?
    @Published var searchCriteriaDto: SearchCriteriaDto?
    @Published var error: Error?
    
    
    
    private let clientGenericApi = GenericApiImpl()
    
    func restSearchMovieApi(url: String) async {
        defer {currentNetworkCallState = .finished}
        
        do {
            currentNetworkCallState = .loading
            self.filteredMovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: url))
        } catch {
            self.error = error
            print("ERROR___>: \(error)")
        }
    }
    
    func restBaseMovieApi(url: String) async {
        defer {currentNetworkCallState = .finished}
        
        do {
            currentNetworkCallState = .loading
            self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: url))
        } catch {
            self.error = error
            print("ERROR___>: \(error)")
        }
    }
    
    func genreRestBaseMovieApi(url: String) async {
        defer {currentNetworkCallState = .finished}
        
        do {
            currentNetworkCallState = .loading
            self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: url))
        } catch {
            self.error = error
            print("ERROR___>: \(error)")
        }
    }
    
    
    
    func loadNextMoviesBySearchCriteria() async {
        defer {currentNetworkCallState = .finished}
        
        var searchUrl: String?
        if(searchCriteriaDto != nil && filteredMovieRest != nil) {
            
            if (searchCriteriaDto!.searchStr != nil) {
                searchUrl = MovieEndpointsEnum.moviesByMovieName(searchCriterias: searchCriteriaDto!, page: UrlPage(page: filteredMovieRest!.page + 1)).urlRequest
            } else {
                searchUrl = MovieEndpointsEnum.moviesBySearchCriteria(searchCriterias: searchCriteriaDto!, page: UrlPage(page: filteredMovieRest!.page + 1)).urlRequest
            }
        }
        
        if let searchUrl = searchUrl {
            do {
                currentNetworkCallState = .loading
                var nextMovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: searchUrl))
                nextMovieRest.results.insert(contentsOf: filteredMovieRest!.results, at: 0)
                self.filteredMovieRest = nextMovieRest
            } catch {
                self.error = error
                print("ERROR___>: \(error)")
            }
        }
    }
    
    func loadNextMovieByGenreInGenreList(currentGenre: MovieGenre) async {
        defer {currentNetworkCallState = .finished}
        do {
            currentNetworkCallState = .loading
            if let currentMovie = self.movieByGenreRest[currentGenre] {
                var moviesByGenre: MovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with:  MutableURLRequest.baseMutableGetURLRequest(url: MovieEndpointsEnum.discoverByGenre(genreId: currentGenre.id, page: UrlPage(page: currentMovie.page + 1)).urlRequest))
                
                moviesByGenre.results.insert(contentsOf: currentMovie.results, at: 0)
                self.movieByGenreRest.updateValue(moviesByGenre, forKey: currentGenre)
            }
            
        } catch {
            self.error = error
            print("ERROR___>: \(error)")
        }
    }
    
    func loadNextMovieBySingleGenre() async {
        defer {currentNetworkCallState = .finished}
        
        do {
            currentNetworkCallState = .loading
            if let currentMovieGenreEndpoint = self.currentMovieGenreEndpoint {
                if let movieRest = movieRest {
                    var nextMovieBySingleGenre = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url:MovieEndpointsEnum.discoverByGenre(genreId: currentMovieGenreEndpoint.id, page: UrlPage(page: movieRest.page + 1)).urlRequest))
                    nextMovieBySingleGenre.results.insert(contentsOf: movieRest.results, at: 0)
                    self.movieRest = nextMovieBySingleGenre
                }
            }
        } catch {
            self.error = error
            print("ERROR___>: \(error)")
        }
    }
    
    func loadNextMovieByCurrentMovieCategoryEndpoint() async {

        defer {
            currentNetworkCallState = .finished
        }
         
        do {
            currentNetworkCallState = .loading
            if let currentMovieCategoryEndpoint = self.currentMovieCategoryEndpoint {
                if let movieRest = movieRest {
                    var currentMovieCategory = try await clientGenericApi.fetch(type: MovieRest.self, with: MutableURLRequest.baseMutableGetURLRequest(url: currentMovieCategoryEndpoint.paginatedPath(page: UrlPage(page: movieRest.page + 1))))
                    currentMovieCategory.results.insert(contentsOf: movieRest.results, at: 0)
                    self.movieRest = currentMovieCategory
                }
            }
        } catch {
            self.error = error
            print("ERROR___>: \(error)")
        }
    }
    
    func movieByGenreApi() {
        defer {currentNetworkCallState = .finished}
        movieGenre?.genres.forEach { genre in
            Task {
                do {
                    currentNetworkCallState = .loading
                    let moviesByGenre: MovieRest = try await clientGenericApi.fetch(type: MovieRest.self, with:  MutableURLRequest.baseMutableGetURLRequest(url:MovieEndpointsEnum.discoverByGenre(genreId: genre.id, page: UrlPage(page: 1)).urlRequest))
                    self.movieByGenreRest.updateValue(moviesByGenre, forKey: genre)
                } catch {
                    self.error = error
                    print("ERROR___>: \(error)")
                }
            }
        }
    }
    
    func movieDetails(url: String) async {
        defer {currentNetworkCallState = .finished}
        
        do {
            currentNetworkCallState = .loading
            self.details = try await clientGenericApi.fetch(type: Details.self, with: MutableURLRequest.baseMutableGetURLRequest(url: url))
        } catch {
            self.error = error
            print("ERROR___>: \(error)")
        }
    }
    
    func restMovieGenreListApi(urlRequest: String) async {
        defer {currentNetworkCallState = .finished}
        do {
            currentNetworkCallState = .loading
            self.movieGenre = try await clientGenericApi.fetch(type: Genre.self, with: MutableURLRequest.baseMutableGetURLRequest(url: urlRequest))
        } catch {
            self.error = error
            print("ERROR___>: \(error)")
        }
    }
}

extension RestApiMovieVM {
    enum CurrentLoadingState {
        case loading
        case finished
    }
}
