//
//  SimpleMovieCardComponentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 20.08.2024.
//

import SwiftUI

struct SimpleMovieCardComponentView: View {
    
    @EnvironmentObject private var router: Router
    
    @ObservedObject  var restApiMovieVm: RestApiMovieVM
    
//    @State private var longPressTimer: Timer? = nil
    @State private var longPressSelectedCard: Int? = nil
    
    var currentDisplayMode: DisplayModeEnum
    private let singleRelativeColumn: CGFloat = UIScreen.main.bounds.width
    
    var body: some View {
        
//        Image("noImage")
//            .resizable()
//            .scaledToFit()
//            .overlay(alignment: .topLeading) {
//                Image(systemName: "star.fill")
//                    .offset(y: currentDisplayMode.relativeColumnWidth / 4)
//                Image(systemName: "star.fill")
//                    .offset(x: currentDisplayMode.relativeColumnWidth / 6, y: currentDisplayMode.relativeColumnWidth / 6)
//                Image(systemName: "star.fill")
//                    .offset(x: currentDisplayMode.relativeColumnWidth / 4)
//            }
        
        
        if let movieRest = restApiMovieVm.movieRest {
            ForEach(Array(movieRest.results.enumerated()), id: \.element) { index, movie in
//                NavigationLink(value: movie) {
//                    AsyncImageView(posterPath: movie.posterPath)
//                        .onAppear {
//                            if (movie.id == movieRest.results.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
//                                if (restApiMovieVm.currentMovieGenreEndpoint != nil) {
//                                    Task {
//                                        await restApiMovieVm.loadNextMovieBySingleGenre()
//                                    }
//                                } else {
//                                    Task {
//                                        await restApiMovieVm.loadNextMovieByCurrentMovieCategoryEndpoint()
//                                    }
//                                }
//                                
//                            }                                                 }
//                }
                
                
                AsyncImageView(posterPath: movie.posterPath)
                    .opacity(longPressSelectedCard == index ? 0.5 : 1)
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
                        }
                    }
                    .onTapGesture {
                        longPressSelectedCard = nil
                        router.path.append(movie)
                    }
                    .onLongPressGesture(minimumDuration: 1, maximumDistance: 2) {
                        longPressSelectedCard = index
                    } onPressingChanged: { changed in
                        if(changed) {
                            withAnimation(.easeOut(duration: 2.0)) {
                                longPressSelectedCard = index
                            }
                        } else {
                            withAnimation(.easeIn) {
                                longPressSelectedCard = nil
                            }
                        }
                    }
                    .overlay(alignment: .topLeading) {
                        Image(systemName: "star.fill")
                            .offset(y: currentDisplayMode.relativeColumnWidth / 3)
                        Image(systemName: "star.fill")
                            .offset(x: currentDisplayMode.relativeColumnWidth / 4, y: currentDisplayMode.relativeColumnWidth / 4)
                        Image(systemName: "star.fill")
                            .offset(x: currentDisplayMode.relativeColumnWidth / 3)
                    }

//                    .onLongPressGesture(minimumDuration: 0.2, maximumDistance: 0.4) {
//                        print("long press")
//                    }
                
                
            }
        }
        
    }
}

#Preview {
    SimpleMovieCardComponentView(restApiMovieVm: .init(), currentDisplayMode: .double)
}
