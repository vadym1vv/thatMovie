//
//  MovieSection.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 16.11.2023.
//

import SwiftUI

struct MovieSection: View {
    
    @ObservedObject var restApiMovieVm: RestApiMovieVM
    
    @State var selectedMovieSection: MovieEndpoints = .trending
    @State var selectedMovieGenre: MovieGenre?
    
    
    //    @Binding var movies: MovieApiPopular?
    @Binding var page: Int
    @Binding var selectedLanguage: Language
    
    
    
    
    
    var body: some View {
        VStack {
        ScrollView(.horizontal) {
            
                HStack {
                    ForEach(MovieEndpoints.allCases) { item in
                        Button(action: {
                            selectedMovieSection = item
                            if (item == .genre) {
                                Task {
                                    await restApiMovieVm.restMovieGenreListApi(url: item.fullPath, selectedLanguage: selectedLanguage)
                                }
                            } else {
                                Task {
                                    await restApiMovieVm.restBaseMovieApi(url: item.fullPath, selectedLanguage: selectedLanguage, page: 1)
                                }
                            }
                            
                            
                        }, label: {
                            MovieSectionItemView(movieItemName: item.movieSection, isSelected: selectedMovieSection == item)
                        })
                    }
                }
        }
        .scrollIndicators(.never)
                    if (selectedMovieSection == .genre) {
                        
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(restApiMovieVm.movieGenre?.genres ?? []) { movieGenre in
                                    Button(action: {
                                        withAnimation {
                                            self.selectedMovieGenre = movieGenre
                                        }
                                        let _ = print("movieGenreId: \(selectedMovieGenre!.id)")
                                        let str = ApiUrls.baseUrl + "/3/discover/movie?with_genres=\(movieGenre.id)"
                                        Task {
                                            await restApiMovieVm.genreRestBaseMovieApi(url: str, selectedLanguage: selectedLanguage, page: 1)
                                        }
                                    }, label: {
                                        MovieSectionItemView(movieItemName: movieGenre.name, isSelected: self.selectedMovieGenre == movieGenre)
                                    })
                                }
                            }
                        }
                        .scrollIndicators(.never)
                    }
        }
        .task {
            await restApiMovieVm.restBaseMovieApi(url: MovieEndpoints.popular.fullPath, selectedLanguage: .de, page: 1)
        }
        
        
    }
    
    private func selectedMovie(selectedItem: MovieEndpoints, item: MovieEndpoints) -> Bool {
        return selectedItem == item
    }
}

#Preview {
    MovieSection(restApiMovieVm: .init(), page: .constant(1), selectedLanguage: .constant(.de))
}
