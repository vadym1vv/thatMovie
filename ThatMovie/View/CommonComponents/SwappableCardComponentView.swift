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
    
    @State var offset: CGSize = .zero
    @State var upDownOffset: CGPoint = .zero
    @State var showAllVideos: Bool = false
    @State private var currentCardIndex: Int = 0
    @State private var transitionDir: Edge = .bottom
    
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
        dbMovies.first(where: {$0.id == restApiMovieVm.details?.id})
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
                        }
                        if(upDownOffset == .zero) {
                            upDownOffset = value.startLocation
                        }
                        
                    }
                    .onEnded { value in
                        
                        if(value.startLocation.y > value.location.y) {
                            print("dragDown")
                            if(currentCardIndex > 0) {
                                transitionDir = .bottom
                                withAnimation(.easeIn(duration: 0.5)) {
                                    currentCardIndex -= 1
                                    
                                }
                                
                                withAnimation(.easeInOut(duration: 3)) {
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
                                withAnimation(.easeInOut(duration: 3)) {
                                    offset.height = -UIScreen.main.bounds.height
                                }
                            }
                        }
                        
                        if(value.translation.width > 0) {
                            print("favourites")
                            //                                                if let newMovie = movieDataVM.setFavouriteById(movieDb: currentMovieFromDb, id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                            //                                                {
                            //                                                    modelContext.insert(newMovie)
                            //                                                }
                        } else {
                            print("watchLater")
                            //                                                if let newMovieItem = movieDataVM.setPlannedToWatch(movieDb: currentMovieFromDb, id: movie.id, genres: restApiMovieVm.details?.genres.map({$0.id}), title: movie.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate) {
                            //                                                    self.modelContext.insert(newMovieItem)
                            //                                                }
                            //                                                if let id = currentMovieFromDb?.id {
                            //                                                    notificationVM.removePendingNotification(identifier: String(id))
                            //                                                }
                        }
                        withAnimation(.spring()) {
                            offset = .zero
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
            .ignoresSafeArea()
            .frame(height: UIScreen.main.bounds.height)
            .transition(.move(edge: transitionDir))
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
