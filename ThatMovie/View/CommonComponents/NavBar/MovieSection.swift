//
//  MovieSection.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 16.11.2023.
//

import SwiftUI

struct MovieSection: View {
    
    @ObservedObject var restApiMovieVm: RestApiMovieVM
    
    @State private var selectedMovieSection: GroupedByCategoryMovieEnum  = .trending
    @State private var selectedMovieGenre: MovieGenre?
    @Binding var displayAllGenres: Bool
    @Binding var page: Int
    
    var body: some View {
        VStack {
            ScrollView(.horizontal) {
                HStack {
                    ForEach(GroupedByCategoryMovieEnum.allCases) { item in
                        Button(action: {
                            if (displayAllGenres) {
                                self.displayAllGenres = false
                            }
                            
                            selectedMovieSection = item
                            
                            if (item == .genre) {
                                Task {
                                    await restApiMovieVm.restMovieGenreListApi(urlRequest: item.paginatedPath(page: UrlPage(page: 1)))
                                }
                            } else {
                                restApiMovieVm.currentMovieGenreEndpoint = nil
                                restApiMovieVm.currentMovieCategoryEndpoint = item
                                Task {
                                    await restApiMovieVm.restBaseMovieApi(url: item.paginatedPath(page: UrlPage(page: 1)))
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
                HStack{
                    ScrollView(.horizontal) {
                        HStack {
                            ForEach(restApiMovieVm.movieGenre?.genres ?? []) { movieGenre in
                                Button(action: {
                                    restApiMovieVm.currentMovieCategoryEndpoint = nil
                                    restApiMovieVm.currentMovieGenreEndpoint = movieGenre
                                    withAnimation {
                                        self.selectedMovieGenre = movieGenre
                                    }
                                    if (displayAllGenres) {
                                        self.displayAllGenres = false
                                    }
                                    Task {
                                        await restApiMovieVm.genreRestBaseMovieApi(url: MovieEndpointsEnum.discoverByGenre(genreId: movieGenre.id, page: UrlPage(page: 1)).urlRequest)
                                    }
                                }, label: {
                                    MovieSectionItemView(movieItemName: movieGenre.name, isSelected: self.selectedMovieGenre == movieGenre)
                                })
                            }
                        }
                    }
                    .scrollIndicators(.never)
                    Button {
                        self.displayAllGenres.toggle()
                        restApiMovieVm.movieByGenreApi()
                    } label: {
                        Image(systemName: self.displayAllGenres ? "chevron.up" : "chevron.down")
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(Color("SecondaryBackground"))
                }
            }
        }
    }
    
    private func selectedMovie(selectedItem: GroupedByCategoryMovieEnum, item: GroupedByCategoryMovieEnum) -> Bool {
        return selectedItem == item
    }
}

//#Preview {
//    MovieSection(restApiMovieVm: .init(), selectedMovieGenre: .constant(.none), displayAllGenres: .constant(false), page: .constant(1), selectedLanguage: .constant(.de))
//}
