//
//  SimpleMovieCardComponentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 20.08.2024.
//

import SwiftUI

struct SimpleMovieCardComponentView: View {
    
    @ObservedObject  var restApiMovieVm: RestApiMovieVM
    
    var body: some View {
        if let movieRest = restApiMovieVm.movieRest {
            ForEach(movieRest.results) { movie in
                NavigationLink(value: movie) {
                    AsyncImageView(posterPath: movie.posterPath)
                        .onAppear {
                            if (movie.id == movieRest.results.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
                                if (restApiMovieVm.currentMovieGenreEndpoint != nil) {
                                    Task {
                                        await restApiMovieVm.loadNextMovieBySingleGenre()
                                    }
                                } else {
                                    Task {
                                        await restApiMovieVm.loadNextMovieByCurrentMovieCategoryEndpoint()
                                    }
                                }
                                
                            }                                                 }
                }
                
            }
        }
    }
}

#Preview {
    SimpleMovieCardComponentView(restApiMovieVm: .init())
}
