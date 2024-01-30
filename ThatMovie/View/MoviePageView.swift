//
//  MovieItem.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import SwiftUI
import SwiftData
import YouTubePlayerKit

struct MoviePageView: View {
    
    @Query private var dbMovies: [MovieItem]
    @ObservedObject var restApiMovieVm: RestApiMovieVM
    @ObservedObject var notificationVM: NotificationVM
    var movieDataVM: MovieDataVM = MovieDataVM()
    @Environment(\.modelContext) var modelContext
    
    @State private var showFullSizeImage: Bool = false
    @State private var showWatchNotificationProperties: Bool = false
    @State private var showAllVideos: Bool = false

    let movieId: Int
    //    let title, posterPath, releaseDate, overview: String?
    //    let voteAverage: Double?
    //    let movieGenres: [Int]?
    var currentMovieFromDb: MovieItem? {
        dbMovies.first(where: {$0.id == restApiMovieVm.details?.id})
    }
    
    @StateObject
    private var youTubePlayerTest = YouTubePlayer(
        source: .url("https://www.youtube.com/watch?v=Vkk_498GcRk")
    )
    
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
    
    
    
    //investigete
    //    var currrentTotificationType: NotificationTypeEnum {
    //        if(currentMovieFromDb!.personalIsPlanedToWatch) {
    //            return .isPlanedToWatch
    //        }
    //        return  .non
    //    }
    
    
    
    var body: some View {
        ZStack(alignment: .center) {
            
            GeometryReader { geometry in
                //                AsyncImage(url: URL(string: "\(ApiUrls.baseImageUrl)\(restApiMovieVm.details?.posterPath ?? defaultImage())")) { image in
                //                    image
                //                        .resizable()
                //                        .scaledToFill()
                //                    //                        .aspectRatio(contentMode: .fill)
                //                        .mask(
                //                            LinearGradient(
                //                                gradient: Gradient(stops: [
                //                                    Gradient.Stop(color: .clear, location: 0),
                //                                    Gradient.Stop(color: .black, location: 0.5),
                //                                    Gradient.Stop(color: .clear, location: 1)
                //                                ]),
                //                                startPoint: .top,
                //                                endPoint: .bottom
                //                            )
                //                        )
                //                } placeholder: {
                //                    ProgressView()
                //                }
                //                .zIndex(1)
                
                AsyncImageView(posterPath: restApiMovieVm.details?.posterPath)
                    .mask(
                        LinearGradient(
                            gradient: Gradient(stops: [
                                Gradient.Stop(color: .clear, location: 0),
                                Gradient.Stop(color: .black, location: 0.5),
                                Gradient.Stop(color: .clear, location: 1)
                            ]),
                            startPoint: .top,
                            endPoint: .bottom
                        )
                    )
                    .frame(height: showFullSizeImage ?  geometry.size.height : (geometry.size.height + 200) / 2)
                //                .onTapGesture {
                //                    showFullSizeImage.toggle()
                //                    let _ = print(showFullSizeImage)
                //                }
                //                if (!showFullSizeImage) {
                ScrollView{
                    Spacer(minLength: geometry.size.height / 2)
                    VStack{
                        //                            HStack {
                        //                                Spacer()
                        //                            }
                        VStack {
                            
                            
                            
                            
                            
                            HStack {
                                Text(restApiMovieVm.details?.title ?? "")
                                    .font(.largeTitle)
                            }
                            
                            HStack {
                                
                                ScrollView(.horizontal) {
                                    HStack{
                                        ForEach(restApiMovieVm.details?.genres ?? []) { genre in
                                            //                                            if let genr = restApiMovieVm.movieGenre?.genres.first(where: {$0.id == genre}) {
                                            MovieSectionItemView(movieItemName: genre.name, isSelected: false)
                                            //                                            }
                                        }
                                    }
                                    .padding(.leading, 20)
                                }
                                
                                HStack {
                                    Button {
                                        if let newMovie = movieDataVM.setFavouriteById(movieDb: currentMovieFromDb, id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                                        {
                                            
                                            modelContext.insert(newMovie)
                                            
                                        }
                                    } label: {
                                        Image(systemName: (currentMovieFromDb != nil && currentMovieFromDb!.personalIsFavourite) ? "star.fill" : "star")
                                        
                                        
                                        
                                        
                                        //                                        Image(systemName: restApiMovieVm.details != nil && movieDataVM.isFavourite(moviesDb: dbMovies, id: restApiMovieVm.details!.id) ? "star.fill" : "star")
                                    }
                                    .padding( 10)
                                    Divider()
                                    
                                    //                                    Menu("Add to:", systemImage: notificationType.imageRepresentation) {
                                    //
                                    //
                                    ////                                        Button {
                                    ////
                                    ////                                        } label: {
                                    ////                                            HStack {
                                    ////                                            Text("watch later")
                                    ////
                                    //////                                                    Image(systemName: "bell.slash")
                                    //////                                                Label("Watch later", systemImage: (restApiMovieVm.details != nil && movieDataVM.isPlanedToWatch(moviesDb: dbMovies, id: restApiMovieVm.details!.id)) ? "bell" : "checkmark")
                                    ////
                                    ////                                            }
                                    ////                                        }
                                    //                                        Button {
                                    //
                                    //                                        } label: {
                                    //                                            Label("Watch list", systemImage: "bell.slash")
                                    //
                                    //                                        }
                                    //
                                    //
                                    //                                        Button {
                                    //                                            self.showWatchNotificationProperties.toggle()
                                    //                                        } label: {
                                    //                                            Label("Watch list with notification", systemImage: "bell")
                                    //                                        }
                                    //
                                    ////                                        if(restApiMovieVm.details != nil && (movieDataVM.isPlanedToWatch(moviesDb: dbMovies, id: restApiMovieVm.details?.id!) || movieDataVM.isDateToWatchSet(moviesDb: dbMovies, id: restApiMovieVm.details?.id!))) {
                                    ////                                            Button {
                                    ////
                                    ////                                            } label: {
                                    ////                                                Label("cancel", systemImage: "trash")
                                    ////                                            }
                                    ////                                        }
                                    //
                                    //                                        if let currentMovieFromDb = currentMovieFromDb {
                                    //                                            if( currentMovieFromDb.personalDateToWatch != nil || currentMovieFromDb.personalIsPlanedToWatch) {
                                    //                                                Button {
                                    //                                                    currentMovieFromDb.personalDateToWatch = nil
                                    //                                                    currentMovieFromDb.personalIsPlanedToWatch = false
                                    //                                                } label: {
                                    //                                                    Label("cancel", systemImage: "trash")
                                    //                                                }
                                    //                                            }
                                    //                                        }
                                    //
                                    //                                    }
                                    
                                    WatchMenuView(shwoWatchNotificationProperties: $showWatchNotificationProperties, id: restApiMovieVm.details?.id, genres: restApiMovieVm.details?.genres.map({$0.id}), title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                                    
                                }
                                .frame(height: 35)
                                .foregroundStyle(.black)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color( UIColor.systemGray2))
                                        .opacity(0.2)
                                )
                                .padding(.trailing, 10)
                            }
                            .frame(width: geometry.size.width)
                            
                            Text(restApiMovieVm.details?.overview ?? "")
                                .multilineTextAlignment(.leading)
                                .fixedSize(horizontal: false, vertical: true)

                            if (showAllVideos){
                                ScrollView {
                                    VStack {
                                        ForEach(filteredResults, id: \.id) { res in
                                            
                                                Button(
                                                    action: {
                                                        self.youTubePlayerTest.source = .url("https://www.youtube.com/watch?v=\(res.key.unwrap)")
                                                    },
                                                    label: {
                                                        YouTubePlayerView(
                                                            .init(
                                                                source: .url("https://www.youtube.com/watch?v=\(res.key.unwrap)")
                                                            )
                                                        )
                                                        .frame(width: geometry.size.width, height: geometry.size.height / 3)
                                                        .border(.black, width: 1)
                                                    }
                                                )
                                        }
   
                                    }
                                    .padding()
                                }
                            } else {
                                if let video = filteredResults.first {
                                    YouTubePlayerView(
                                        .init(
                                            source: .url("https://www.youtube.com/watch?v=\(video.key.unwrap)")
                                        )
                                    )
                                    .frame(width: geometry.size.width, height: 200)
                                    .border(.black, width: 1)
                                }
                            }
                            Spacer()
                            if (restApiMovieVm.details?.videos?.results != nil && (restApiMovieVm.details?.videos?.results.count)! > 1) {
                                Button {
                                    showAllVideos.toggle()
                                } label: {
                                    Image(systemName: showAllVideos ? "chevron.up" : "chevron.down")
                                        .frame(width: geometry.size.width, height: 40)
                                        .padding(20)
                                        .background(.black)
                                        
                                        
                                }
                            }
                        }
//                        Spacer()
                    }
                    .frame(minHeight: geometry.size.height / 2)
                    
                    .frame(minWidth: geometry.size.width)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color( UIColor.systemGray5))
                            .opacity(0.3)
                    )
                }
                .scrollIndicators(.never)
            }
        }
        .ignoresSafeArea()
        .task {
            await restApiMovieVm.movieDetails(url: ApiUrls.movieDetails(movieId: movieId, language: .en))
        }
        .onDisappear {
            restApiMovieVm.details = nil
        }
        .sheet(isPresented: $showWatchNotificationProperties, content: {
            //            uncoment
            SetWatchNotificationView(notificationVM: notificationVM,id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                .presentationDetents([.medium])
            
        }
        )
        
        
    }
    
    func defaultImage() -> String {
        if let defaultImagePath = Bundle.main.resourcePath {
            let imageName = "noImage.jpg"
            return defaultImagePath + "/" + imageName
        }
        return ""
    }
}
#Preview {
    MoviePageView(restApiMovieVm: .init(), notificationVM: .init(), movieId: 1)
}
