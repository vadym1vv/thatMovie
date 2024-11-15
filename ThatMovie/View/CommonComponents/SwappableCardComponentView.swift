//
//  SwappableCardComponentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 20.08.2024.
//

import SwiftUI
import SwiftData
import YouTubePlayerKit

struct SwappableCardComponentView: View {
    
    @ObservedObject  var restApiMovieVm: RestApiMovieVM
    
    @Query private var dbMovies: [MovieItem]
    
    @Environment(\.modelContext) var modelContext
    
    @StateObject var movieItemToUpdate: MovieItemToUpdateInfo = MovieItemToUpdateInfo()
    
    @State var offset: CGSize = .zero
    @State var upDownOffset: CGPoint = .zero
    @State var showAllVideos: Bool = false
    @State private var currentCardIndex: Int = 0
    @State private var transitionDir: Edge = .bottom
    @State private var selectFavoriteProgress: CGFloat = .zero
    @State private var selectedWatchLaterProgress: CGFloat = .zero
    @State private var showUpdateDialog: Bool = false
    
    var movieDataVM: MovieDataVM = MovieDataVM()
    var filteredResults: [VideosResults] {
        if let results = restApiMovieVm.details?.videos?.results {
            let youTubeVideos = results.filter{$0.site == "YouTube"}
            var videosWithTrailerFirst = youTubeVideos.filter{$0.type == "Trailer"}
            let other = youTubeVideos.filter{$0.type != "Trailer"}
            videosWithTrailerFirst.append(contentsOf: other)
            return videosWithTrailerFirst
        }
        return []
    }
    
    var youTubePlayerTest = YouTubePlayer(
        source: .url("https://www.youtube.com/watch?v=Vkk_498GcRk")
    )
    private let notificationVM = NotificationVM()
    
//    var currentMovieRange: [Result] {
//        Array(restApiMovieVm.movieRest?.results[restApiMovieVm.lastMovieCardIndex...restApiMovieVm.currentMovieCardIndex] ?? [])
//    }
    
    var currentMovieFromDb: MovieItem? {
        var dbMovie = dbMovies.first(where: {$0.id == restApiMovieVm.details?.id})
        if var dbMovie {
            print(dbMovie.id)
        }
        
        return dbMovie
    }
    
    
    fileprivate func MovieCardView(_ movie: Result, _ index: Int, movieRest: [Result]/*, transitionDirection: Edge*/) -> some View {
        
         //                        NavigationLink(value: movie) {
        AsyncImageView(posterPath: movie.posterPath)
        //                                            Image(systemName: "star")
            .offset(offset)
            .scaleEffect(getScaleAmount())
            .rotationEffect(Angle(degrees: getRotationAmount()))
            .gesture(
                DragGesture()
                    .onChanged { value in
                        withAnimation(.spring()) {
                            offset = value.translation
                            
                            if(value.translation.width > 0) {
                                selectedWatchLaterProgress = .zero
                            } else {
                                selectFavoriteProgress = .zero
                            }
                            
                            if(value.translation.width - 40 > 0 && selectFavoriteProgress < 100) {
                                selectFavoriteProgress = value.translation.width  - 40
                            } else if (value.translation.width + 40 < 0 && selectedWatchLaterProgress < 100) {
                                selectedWatchLaterProgress = abs(value.translation.width + 40)
                            }
                        }	
                        if(upDownOffset == .zero) {
                            upDownOffset = value.startLocation
                        }
                    }
                    .onEnded { value in
                        print(value.location.y)
                        print(upDownOffset.y)
                        
                        if((upDownOffset.y < value.location.y && upDownOffset.y + 150 < value.location.y)
                           ||
                           (upDownOffset.y > value.location.y && upDownOffset.y > value.location.y + 150)) {
                            print("PERFORM SWIPE")
                            if(value.location.y + 50 > 150) {
                                if(value.startLocation.y > value.location.y) {
                                    print("dragDown")
                                    if(currentCardIndex > 0) {
                                        transitionDir = .bottom
                                        withAnimation(.easeIn(duration: 0.5)) {
                                            currentCardIndex -= 1
                                            
                                        }
                                        
                                        withAnimation(.easeInOut(duration: 2)) {
                                            offset.height = UIScreen.main.bounds.height
                                        }
                                        
                                    }
                                } else {
                                    print("dragUp")
                                    
                                    if(movieRest.count - 1 > index) {
                                        transitionDir = .top
                                        withAnimation(.easeIn(duration: 0.5)) {
                                            
                                            currentCardIndex += 1
                                        }
                                        withAnimation(.easeInOut(duration: 2)) {
                                            offset.height = -UIScreen.main.bounds.height
                                        }
                                    }
                                }
                            }
                        }
                        
                        if(value.translation.width > 0 && value.translation.width - 150 > 0) {
                            print("favourites")
                            if let newMovie = movieDataVM.setFavouriteById(movieDb: currentMovieFromDb, id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                            {
                                modelContext.insert(newMovie)
                            }
                        } else if (value.translation.width < 0 && value.translation.width + 150 < 0) {
                            
                            if (currentMovieFromDb?.personalDateToWatch != nil) {
                                if let currentMovieFromDb = currentMovieFromDb {
                                    currentMovieFromDb.personalDateToWatch = nil
                                    
                                }
                                
                                print("clear action")
                                
                            } 
                            
                            if(!(currentMovieFromDb?.personalIsPlannedToWatch ?? false) && currentMovieFromDb?.personalDateToWatch == nil) {
                                if let newMovieItem = movieDataVM.setPlannedToWatch(movieDb: currentMovieFromDb, id: movie.id, genres: restApiMovieVm.details?.genres.map({$0.id}), title: movie.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate) {
                                    self.modelContext.insert(newMovieItem)
                                }
                                if let id = currentMovieFromDb?.id {
                                    notificationVM.removePendingNotification(identifier: String(id))
                                }
                                print("watch later")
                            } else if (currentMovieFromDb?.personalIsPlannedToWatch ?? false && currentMovieFromDb?.personalDateToWatch == nil) {
                                if let currentMovieFromDb = currentMovieFromDb {
                                    currentMovieFromDb.personalIsPlannedToWatch = false
                                }
                                showUpdateDialog = true
                                print("set planned date by popup")
                                    
                            } 
//                            else if (!(currentMovieFromDb?.personalIsPlannedToWatch ?? false) && currentMovieFromDb?.personalDateToWatch != nil) {
//                                if let currentMovieFromDb = currentMovieFromDb {
//                                    currentMovieFromDb.personalDateToWatch = nil
//                                }
//                            }
                            
//                            else if (currentMovieFromDb?.personalDateToWatch != nil) {
//                                
//                            }
                            
                            
                            
//                            showUpdateDialog = true
                        }
                        withAnimation(.spring()) {
                            offset = .zero
                            upDownOffset = .zero
                            
                        }
                        
                        if ((value.translation.width > 0 && value.translation.width - 150 < 0) || (value.translation.width < 0 && value.translation.width + 150 > 0)) {
                            
                            
                            withAnimation {
                                selectFavoriteProgress = .zero
                                selectedWatchLaterProgress = .zero
                            }
                        } else {
                            selectFavoriteProgress = .zero
                            selectedWatchLaterProgress = .zero
                        }
                        
                    }
            )
            .onAppear {
                if (movie.id == movieRest.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
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
            .task {
                await restApiMovieVm.movieDetails(url: MovieEndpointsEnum.movieDetails(movieId: movie.id).urlRequest)
            }
            .ignoresSafeArea()
            .frame(height: UIScreen.main.bounds.height)
            .transition(.move(edge: transitionDir))
            .overlay(alignment: .top) {
                ZStack(alignment: .top) {
//
                    HStack {
                        ZStack(alignment: .topLeading) {
                            if(selectedWatchLaterProgress > 0) {
                                if (currentMovieFromDb?.personalDateToWatch != nil) {
                                    FadeIconComponent(iconName: "icons8-short-film-100", color: .yellow, isSelected: false)
                                        .offset(y: -selectedWatchLaterProgress)
                                        .padding(.top, getSafeArea().top)
                                }
                                if(currentMovieFromDb?.personalIsPlannedToWatch ?? false && currentMovieFromDb?.personalDateToWatch == nil) {
                                    if (currentMovieFromDb?.personalIsPlannedToWatch ?? false && currentMovieFromDb?.personalDateToWatch == nil) {
                                        FadeIconComponent(iconName: "icons8-to-do-100-2", color: .yellow, opacity: selectedWatchLaterProgress * 100 / 100, isSelected: false)
                                            .offset(y: -selectedWatchLaterProgress)
                                            .padding(.top, getSafeArea().top)
                                    }
                                } else {
                                    FadeIconComponent(iconName: "icons8-to-do-100-2", color: .yellow, opacity: selectedWatchLaterProgress / 100, width: 300 - (selectedWatchLaterProgress * 300 / 100), height: 300 - (selectedWatchLaterProgress * 300 / 100), isSelected: false)
                                        .padding(.top, getSafeArea().top)
                                    
                                }
                            } else if (currentMovieFromDb != nil && currentMovieFromDb!.personalDateToWatch != nil) {
                                FadeIconComponent(iconName: "icons8-short-film-100", color: .yellow, isSelected: false)
                                    .padding(.top, getSafeArea().top)
                            } else if (currentMovieFromDb?.personalIsPlannedToWatch ?? false && currentMovieFromDb?.personalDateToWatch == nil) {
                                FadeIconComponent(iconName: "icons8-to-do-100-2", color: .yellow, isSelected: false)
                                    .padding(.top, getSafeArea().top)
                            }
                        }
                        Spacer()
                    }
                    
                        Spacer()
                    
                    HStack {
                        Spacer()
                        if(selectFavoriteProgress > 0) {
                            if(currentMovieFromDb != nil && currentMovieFromDb!.personalIsFavourite) {

                                if (currentMovieFromDb != nil && currentMovieFromDb!.personalIsFavourite) {
                                    FadeIconComponent(iconName: "icons8-bookmark", color: .yellow, opacity: selectFavoriteProgress * 100 / 100, isSelected: false)
                                        .offset(y: -selectFavoriteProgress)
                                        .padding(.top, getSafeArea().top)
                                }
                            } else {
                                FadeIconComponent(iconName: "icons8-bookmark", color: .yellow, opacity: selectFavoriteProgress / 100, width: 300 - (selectFavoriteProgress * 300 / 100), height: 300 - (selectFavoriteProgress * 300 / 100), isSelected: false)
                                    .padding(.top, getSafeArea().top)
                                
                            }
                        } else if (currentMovieFromDb != nil && currentMovieFromDb!.personalIsFavourite) {
                            FadeIconComponent(iconName: "icons8-bookmark", color: .yellow, isSelected: false)
                                .padding(.top, getSafeArea().top)
                        }
                    }
                }
                .frame(width: UIScreen.main.bounds.width)
//                .frame(height: UIScreen.main.bounds.height)
//                .offset(y: -UIScreen.main.bounds.height / 4)
            }
            .sheet(isPresented: $showUpdateDialog, onDismiss: {
                self.movieItemToUpdate.movieItem = nil
            }, content: {
                SetWatchNotificationView(id: restApiMovieVm.details?.id, title: self.movieItemToUpdate.movieItem?.title)
                    .presentationDetents([.medium])
                
            })
            
    }
    
    var body: some View {
        
        if let movieRest = restApiMovieVm.movieRest {
            //                VStack (spacing: 20){
            //            ZStack {
//            if(!showAllVideos) {
//                ScrollViewReader { proxy in
//                ScrollView {
                    ZStack {
                        ForEach(Array(movieRest.results.enumerated()), id: \.offset) { index, movie in
//                            if(index < currentCardIndex + 2 && index > currentCardIndex - 2) {
//                                MovieCardView(movie, index, movieRest: movieRest.results, transitionDirection: .top)
//                            }
                            if (index == currentCardIndex) {
                                MovieCardView(movie, index, movieRest: movieRest.results)
//                                    .zIndex(.infinity)
                                                                
                                //                                .containerRelativeFrame(.vertical, alignment: .center)
    //                        }
                            }
                            
                                
    //
                        }
                    }
//                }
//            } else {
//                ScrollView {
//                    VStack(alignment: .center) {
//                        if (showAllVideos){
//                            ForEach(filteredResults, id: \.id) { res in
//                                
//                                Button(
//                                    action: {
//                                        self.youTubePlayerTest.source = .url("https://www.youtube.com/watch?v=\(res.key.unwrap)")
//                                    },
//                                    label: {
//                                        YouTubePlayerView(
//                                            .init(
//                                                source: .url("https://www.youtube.com/watch?v=\(res.key.unwrap)")
//                                            )
//                                        )
//                                        .frame(height: UIScreen.main.bounds.height / 3)
//                                        .clipShape(RoundedRectangle(cornerRadius: 5))
//                                    }
//                                )
//                            }
//                        } else {
//                            if let video = filteredResults.first {
//                                YouTubePlayerView(
//                                    .init(
//                                        source: .url("https://www.youtube.com/watch?v=\(video.key.unwrap)")
//                                    )
//                                )
//                                .frame(height: UIScreen.main.bounds.height / 3)
//                                .clipShape(RoundedRectangle(cornerRadius: 5))
//                            }
//                        }
//                    }
//                    .frame(maxWidth: .infinity)
//                }
//                .padding(2)
//            }
        }
    }
    
    func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.5) * 0.5
    }
    
    func getRotationAmount() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = offset.width
        let percentage = currentAmount / max
        let percentageAsDouble = Double(percentage)
        let maxAngle: Double = 10
        return percentageAsDouble * maxAngle
    }
}

#Preview {
    SwappableCardComponentView(restApiMovieVm: .init())
}
