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
    var movieDataVM: MovieDataVM = MovieDataVM()
    @Environment(\.modelContext) var modelContext
    @EnvironmentObject var router: Router
    
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
                
                ScrollView{
                    Spacer(minLength: geometry.size.height / 2)
                    VStack {
                       
                        
                            Text(restApiMovieVm.details?.title ?? "")
                                .font(.largeTitle)
                            
                            HStack {
                                ScrollView(.horizontal) {
                                    HStack{
                                        ForEach(restApiMovieVm.details?.genres ?? []) { genre in
                                            MovieSectionItemView(movieItemName: genre.name, isSelected: true)
                                        }
                                    }
                                    .padding(.leading, 20)
                                }
                                
                                Spacer()
                                
                                HStack {
                                    Button {
                                        if let newMovie = movieDataVM.setFavouriteById(movieDb: currentMovieFromDb, id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                                        {
                                            modelContext.insert(newMovie)
                                        }
                                    } label: {
                                        Image(systemName: (currentMovieFromDb != nil && currentMovieFromDb!.personalIsFavourite) ? "star.fill" : "star")
                                    }
                                    
                                    Divider()
                                    WatchMenuView(shwoWatchNotificationProperties: $showWatchNotificationProperties, id: restApiMovieVm.details?.id, genres: restApiMovieVm.details?.genres.map({$0.id}), title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                                    
                                }
                                .frame(height: 35)
                                .foregroundStyle(Color(UIColor.label))
                                .padding([.leading, .trailing], 10)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("SecondaryBackground"))
                                        .opacity(0.5)
                                )
                                .padding(.trailing, 15)
                            }
                            
                            HStack {
                                VStack(alignment: .leading) {
                                    
                                    HStack {
                                        Text(restApiMovieVm.details?.status ?? "")
                                        Divider()
                                        Text(restApiMovieVm.details?.releaseDate ?? "")
                                    }
                                    .frame(maxHeight: 15)
                                    .padding(5)
                                    .background(
                                        RoundedRectangle(cornerRadius: 7)
                                            .strokeBorder(.black.opacity(0.3))
                                        
                                    )
                                    
                                    if let runtime = restApiMovieVm.details?.runtime {
                                        HStack {
                                            Text("Duration: ")
                                            Text("\(Int(runtime / 60)) h")
                                            Text("\(Int(runtime % 60)) m")
                                        }
                                    }
                                }
                                
                                Spacer()
                                
                                HStack {
                                    if let rating = restApiMovieVm.details?.voteAverage, let voteCount = restApiMovieVm.details?.voteCount {
                                        Text("R: \(rating.formatted(.number.precision(.fractionLength(0...1))))")
                                        Text("/\(voteCount.roundedWithAbbreviations)")
                                    }
                                }
                            }
                            .padding(7)
                            
                            Text(restApiMovieVm.details?.overview ?? "")
                                .padding([.leading, .trailing], 5)
                        
                        
                        ScrollView {
                            VStack(alignment: .center) {
                                if (showAllVideos){
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
                                                .frame(height: geometry.size.height / 3)
                                                .clipShape(RoundedRectangle(cornerRadius: 5))
                                            }
                                        )
                                    }
                                } else {
                                    if let video = filteredResults.first {
                                        YouTubePlayerView(
                                            .init(
                                                source: .url("https://www.youtube.com/watch?v=\(video.key.unwrap)")
                                            )
                                        )
                                        .frame(height: geometry.size.height / 3)
                                        .clipShape(RoundedRectangle(cornerRadius: 5))
                                    }
                                }
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .padding(2)
                        
                        Spacer()
                        if (restApiMovieVm.details?.videos?.results != nil && (restApiMovieVm.details?.videos?.results.count)! > 1) {
                            Button {
                                showAllVideos.toggle()
                            } label: {
                                Image(systemName: showAllVideos ? "chevron.up" : "chevron.down")
                                    .frame(maxWidth: .infinity)
                                    .frame(height: 40)
                                    .padding(20)
                                    .background(.black)
                            }
                        }
                    }
                    .frame(minHeight: geometry.size.height / 2)
                    .background(
                        RoundedRectangle(cornerRadius: 35)
                            .fill(Color("SecondaryBackground"))
                            .opacity(0.4)
                    )
                }
                .scrollIndicators(.never)
            }
        }
        .ignoresSafeArea()
        .background(Color("PrimaryBackground")
            .ignoresSafeArea())
        .toolbarBackground(.hidden, for: .navigationBar)
        .task {
            await restApiMovieVm.movieDetails(url: MovieEndpoints.movieDetails(movieId: movieId, language: .en).urlRequest)
        }
        .onDisappear {
            restApiMovieVm.details = nil
        }
        //        .toolbar {
        //
        //            ToolbarItem(placement: .topBarTrailing) {
        //                    HStack {
        //                        Button {
        //                            if let newMovie = movieDataVM.setFavouriteById(movieDb: currentMovieFromDb, id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
        //                            {
        //
        //                                modelContext.insert(newMovie)
        //
        //                            }
        //                        } label: {
        //                            Image(systemName: (currentMovieFromDb != nil && currentMovieFromDb!.personalIsFavourite) ? "star.fill" : "star")
        //                        }
        //                        .padding( 10)
        //                        Divider()
        //                        WatchMenuView(shwoWatchNotificationProperties: $showWatchNotificationProperties, id: restApiMovieVm.details?.id, genres: restApiMovieVm.details?.genres.map({$0.id}), title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
        //
        //                    }
        //                    .frame(height: 35)
        //                    .foregroundStyle(.black)
        //                    .background(
        //                        RoundedRectangle(cornerRadius: 10)
        //                            .fill(Color( UIColor.systemGray2))
        //                            .opacity(0.2)
        //                    )
        //                    .padding(.trailing, 10)
        //                }
        //        }
        //        .navigationBarHidden(true)
        
        
        .sheet(isPresented: $showWatchNotificationProperties, content: {
            //            uncoment
            SetWatchNotificationView(id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
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

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)k"
        }
        else {
            return "\(self)"
        }
    }
}



#Preview {
    MoviePageView(restApiMovieVm: .init(), movieId: 1)
}
