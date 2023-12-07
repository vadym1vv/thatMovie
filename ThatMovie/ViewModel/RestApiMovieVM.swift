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
    @Published var movieByGenreRest: [MovieGenre : MovieRest] = [:]
    @Published var movieGenre: Genre?
    
    
    //    @Published var selectedLanguage: Languages = .en
    
    
    private let restApiService = RestApiService()
    private let clientGenericApi = GenericApiImpl()
    
    func restBaseMovieApi(url: URLRequest) async {
        //        var computedUrl = url/* + selectedLanguage.rawValue*/
        do {
            self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: url)
            //            movieRest?.results.forEach{ result in
            //                print(result.title)
            //            }
            //            print("--++++---")
            //            print(url)
        } catch {
            print("ERROR: \(error)")
        }
    }
    
    
    func genreRestBaseMovieApi(url: String) async {
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
        do {
            self.movieGenre = try await clientGenericApi.fetch(type: Genre.self, with: ApiUrls.moviesUrl(url: url, language: selectedLanguage))
        } catch {
            print("error: \(error)")
        }
    }
    
    func movieByGenreApi() {
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
        //        movieRest?.results.filter{ searchCriteriaDto.includeAdult ?? $0.adult == searchCriteriaDto.includeAdult
        //            if let includeAdult = searchCriteriaDto.includeAdult {
        //                $0.includeAdult == includeAdult
        //            }
        
        //        }
        
        if (movieRest != nil){
            for result in movieRest!.results {
                
                if let searchStr = searchCriteriaDto.searchStr {
                    if let title = result.title {
                        if(title.contains(searchStr)) {
                            filteredResults.append(result)
//                            continue
                        }
                    }
                    
                }
                
                if let releaseYear = searchCriteriaDto.releaseYear {
                    if(result.releaseDate != nil && DateFormatter().date(from: result.releaseDate!) == releaseYear) {
                        filteredResults.append(result)
//                        continue
                    }
                    
                }
                
                if let includeAdult = searchCriteriaDto.includeAdult {
                    if(result.adult == includeAdult) {
                        filteredResults.append(result)
//                        continue
                    }
                }

                if (searchCriteriaDto.selectedGenres.count > 0) {
//                    if(searchCriteriaDto.selectedGenres.map{$0.id}.contains(result.genreIDS)) {
//                        filteredResults.append(result)
////                        continue
//                    }
//                       

                    
                    
                    if(searchCriteriaDto.selectedGenres.map{$0.id}.contains { id in
                        result.genreIDS.contains(id)
                    }) {
                        filteredResults.append(result)
//                        continue
                    }
                }
            }
            if (filteredResults.isEmpty) {
                filteredMovieRest = nil
            } else {
                filteredMovieRest = MovieRest(page: 1, results: filteredResults, totalPages: 1, totalResults: 1)
            }
            
//            filteredMovieRest?.results = filteredResults
        }
        
        
        //    func movieWithSearchCriteria(url: URLRequest, selectedLanguage: Language) async {
        //        Task {
        //            do {
        //                self.movieRest = try await clientGenericApi.fetch(type: MovieRest.self, with: url)
        //            } catch {
        //                print("error: \(error)")
        //            }
        //        }
        //    }
        //    func searchMovieByCriteria
    }
}
