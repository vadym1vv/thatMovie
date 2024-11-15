//
//  SimpleMovieCardComponentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 20.08.2024.
//

import SwiftUI
import SwiftData


struct SimpleMovieCardComponentView: View {
    
    @Query private var dbMovies: [MovieItem]
    @EnvironmentObject private var router: Router
    
    @ObservedObject  var restApiMovieVm: RestApiMovieVM
    @Environment(\.modelContext) var modelContext
    var movieDataVM: MovieDataVM = MovieDataVM()
//    @State private var longPressTimer: Timer? = nil
    @Binding var shwoWatchNotificationProperties: Bool
    @Binding var showScrollToTopOption: Bool
    
    @State private var longPressSelectedCard: Int? = nil
    @State private var transitionFinished: Bool = false
    
    var currentDisplayMode: DisplayModeEnum
    private let singleRelativeColumn: CGFloat = UIScreen.main.bounds.width
    private let notificationVM = NotificationVM()
    
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
        
//        var currentMovieFromDb: MovieItem? {
//            if let currentRestMovie {
//                return dbMovies.first(where: {$0.id == currentRestMovie.id})
//            }
//            return nil
//        }
        
        var currentMovieFromDb: MovieItem? {
            dbMovies.first(where: {$0.id == restApiMovieVm.details?.id})
        }
        
        var currentRestMovie: Result? {
            if let longPressSelectedCard, let movies = restApiMovieVm.movieRest {
                return movies.results[longPressSelectedCard]
            }
            return nil
        }
        
        
        
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
//                        if(longPressSelectedCard == nil){
                            longPressSelectedCard = nil
                            router.path.append(movie)
//                        }
                    }
                    .onLongPressGesture(minimumDuration: 1, maximumDistance: 2) {
                        
                        Task {
                            await restApiMovieVm.movieDetails(url: MovieEndpointsEnum.movieDetails(movieId: movie.id).urlRequest)
                        }
                        
                        longPressSelectedCard = index
                        transitionFinished = true
//                        restApiMovieVm.details = movie.de
                    } onPressingChanged: { changed in
                        if(longPressSelectedCard == nil) {
                            if(changed) {
                                withAnimation(.easeOut(duration: 2.0)) {
                                    longPressSelectedCard = index
                                    transitionFinished = true
                                }
                                
                            } else {
    //                            withAnimation(.easeIn) {
                                    
    //                            }
                                
    //                            withAnimation {
                                    longPressSelectedCard = nil
                                    transitionFinished = false
    //                            }
                                
                            }
                        }
                    }
                    .overlay(alignment: .topLeading) {
                        if(longPressSelectedCard == index && transitionFinished) {
                            let _ = print(currentMovieFromDb != nil && currentMovieFromDb!.personalIsFavourite)
                            Image(systemName: (currentMovieFromDb != nil && currentMovieFromDb!.personalIsFavourite) ? "star.fill" : "star")
                                .offset(y: currentDisplayMode.relativeColumnWidth / 3)
                                .transition(.move(edge: .top))
                                .onTapGesture {
                                    
                                    
                                    
                                    if let newMovie = movieDataVM.setFavouriteById(movieDb: currentMovieFromDb, id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                                        {
                                            modelContext.insert(newMovie)
                                        }
                                    print("Tap action")
                                }

//                            Image(systemName: "star.fill")
//                                .offset(y: currentDisplayMode.relativeColumnWidth / 3)
//                                .transition(.move(edge: .top))
                            Image(systemName: currentMovieFromDb?.personalIsPlannedToWatch ?? false && currentMovieFromDb?.personalDateToWatch == nil ? "bell" : "bell.slash")
                                .offset(x: currentDisplayMode.relativeColumnWidth / 4, y: currentDisplayMode.relativeColumnWidth / 4)
//                                .transition(.topLeadingToBottomTrailing)
                                .transition(.move(edge: .top).combined(with: .move(edge: .leading)))
                                .animation(.easeInOut, value: longPressSelectedCard)
                                .onTapGesture {
                                    if(currentMovieFromDb?.personalIsPlannedToWatch ?? false && currentMovieFromDb?.personalDateToWatch == nil) {
                                        currentMovieFromDb?.personalIsPlannedToWatch = false
                                    } else {
                                        if let newMovieItem = movieDataVM.setPlannedToWatch(movieDb: currentMovieFromDb, id: restApiMovieVm.details?.id, genres: restApiMovieVm.details?.genres.map({$0.id}), title: "restApiMovieVm.details?.title", posterPath: "restApiMovieVm.details?.posterPath", releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate) {
                                            self.modelContext.insert(newMovieItem)
                                        }
                                        if let id = currentMovieFromDb?.id {
                                            notificationVM.removePendingNotification(identifier: String(id))
                                        }
                                    }
                                    
                                }
                            Image(systemName: "star.fill")
                                .offset(x: currentDisplayMode.relativeColumnWidth / 3)
                                .transition(.move(edge: .leading))
                                .onTapGesture {
                                    self.shwoWatchNotificationProperties.toggle()
                                }
                        }
                    }
                    .id(index)
                    .onAppear {
                        if(!showScrollToTopOption && index > 30) {
                            withAnimation {
                                showScrollToTopOption = true
                            }
                        }
                    }

//                    .onLongPressGesture(minimumDuration: 0.2, maximumDistance: 0.4) {
//                        print("long press")
//                    }
                
                
            }
        }
        
    }
}

#Preview {
    SimpleMovieCardComponentView(restApiMovieVm: .init(), shwoWatchNotificationProperties: .constant(false), showScrollToTopOption: .constant(false), currentDisplayMode: .double)
}


//extension AnyTransition {
//    static var topLeadingToBottomTrailing: AnyTransition {
//        AnyTransition.asymmetric(
//            insertion:
//            ))
//        )
//    }
//}
