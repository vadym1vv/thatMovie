//
//  ContentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import SwiftUI
import SwiftData
import YouTubePlayerKit
import StoreKit


struct ContentView: View {
    
    @AppStorage("isMovieOptionsOn") private var isMovieOptionsOn: Bool = false
    @AppStorage("contentViewCurrentDisplayMode") private var savedCurrentDisplayMode: String = "triple"
    @AppStorage("contentViewDisplayTimes") private var contentViewDisplayTimes: Int = 20
    @StateObject private var restApiMovieVm: RestApiMovieVM = RestApiMovieVM()
    @EnvironmentObject private var router: Router
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    @Environment(\.requestReview) private var requestReveiew
    
    @Environment(\.modelContext) var modelContext
    
    @Query private var dbMovies: [MovieItem]
    
    @State private var radialMenuIsHidden: Bool = true
    @State private var showSearchField: Bool = false
    @State private var isDarkModeOn: Bool = false
    @State private var showWatchNotificationProperties: Bool = false
    @State private var autoClose: Bool = false
    @State private var page: Int = 1
    @State private var displayAllGenres: Bool = false
    @State private var showAboutAppPopUp: Bool = false
    @State private var showErrorAlert: Bool = false
    @State private var longPressSelectedCard: Int? = nil
    @State private var transitionFinished: Bool = false
    @State private var scrollToTop: Bool = false
    @State private var showScrollToTopOption: Bool = false
    
    private let notificationVM: NotificationVM = NotificationVM()
    private var additionalOptionsPresent: Bool = false
    
    var movieDataVM: MovieDataVM = MovieDataVM()
    
    var currentDisplayMode: DisplayModeEnum {
        return DisplayModeEnum.currentDisplayModByString(str: savedCurrentDisplayMode)
    }
    
    var currentMovieFromDb: MovieItem? {
        dbMovies.first(where: {$0.id == restApiMovieVm.details?.id})
    }
    
    var currentRestMovie: Result? {
        if let longPressSelectedCard, let movies = restApiMovieVm.movieRest {
            return movies.results[longPressSelectedCard]
        }
        return nil
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .top) {
                
                
                //                ScrollView {
                //                    VStack(spacing: 0) {
                if(self.displayAllGenres && restApiMovieVm.filteredMovieRest == nil) {
                    ScrollView {
                        
                        ForEach(restApiMovieVm.movieByGenreRest.sorted(by: {$0.key.name > $1.key.name}), id: \.key) { movieGenre, movies in
                            VStack(alignment: .leading, spacing: 0) {
                                Text(movieGenre.name)
                                    .font(.title2)
                                    .padding([.top, .leading], 3)
                                    .padding(.trailing , 13)
                                    .background(
                                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 25), style: .continuous)
                                            .foregroundStyle(Color("SecondaryBackground"))
                                    )
                                
                                VStack {
                                    ScrollView(.horizontal) {
                                        LazyHStack {
                                            ForEach(movies.results) { movie in
//                                                NavigationLink(value: movie) {
//                                                    AsyncImageView(posterPath: movie.posterPath)
//                                                }
//                                                .onAppear {
//                                                    if (movie.id == movies.results.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
//                                                        Task {
//                                                            await restApiMovieVm.loadNextMovieByGenreInGenreList(currentGenre: movieGenre)
//                                                        }
//                                                    }
//                                                }
                                                
                                                
                                                AsyncImageView(posterPath: movie.posterPath)
                                                    .onTapGesture {
                                                        router.path.append(movie)
                                                    }
                                                    .onLongPressGesture(minimumDuration: 0.2, maximumDistance: 0.4) {
                                                        print("long press")
                                                    }
                                                    
                                                
//                                                Button {
//                                                    router.path.append(movie)
//                                                } label: {
//                                                    AsyncImageView(posterPath: movie.posterPath)
//                                                }
//                                                .onLongPressGesture {
//                                                    print("asfasf asf asfa sf as")
//                                                }

                                            }
                                            .padding([.bottom, .top], 10)
                                        }
                                        .frame(height: 300)
                                    }
                                    .scrollIndicators(.never)
                                }
                                .background(Color("SecondaryBackground"))
                                .padding(.bottom, 5)
                            }
                        }
                    }
                } else {
                    if(restApiMovieVm.filteredMovieRest != nil) {
                        
                        ScrollViewReader { scrollView in
                            ScrollView {
                                if showSearchField {
                                    SearchFieldView(restApiMovieVm: restApiMovieVm, showSearchField: $showSearchField)
                                        .padding()
                                } else {
                                    MovieSection(restApiMovieVm: restApiMovieVm, displayAllGenres: $displayAllGenres, page: $page)
                                        .padding()
                                }
                                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center, spacing: 0) {
                                    if(restApiMovieVm.filteredMovieRest!.results.isEmpty) {
                                        Text("Search list is empty")
                                            .font(.largeTitle)
                                    } else {
                                        ForEach(Array(restApiMovieVm.filteredMovieRest!.results.enumerated()), id: \.element) { index, movie in
    //                                        NavigationLink(value: movie) {
    //                                            AsyncImageView(posterPath: movie.posterPath)
    //                                        }
                                            
                                            AsyncImageView(posterPath: movie.posterPath)
                                                .opacity(longPressSelectedCard == index ? 0.5 : 1)

                                            .onAppear {
                                                if (movie.id == restApiMovieVm.filteredMovieRest?.results.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
                                                    Task {
                                                        await restApiMovieVm.loadNextMoviesBySearchCriteria()
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

                                                    Image(systemName: "star.fill")
                                                        .offset(y: currentDisplayMode.relativeColumnWidth / 3)
                                                        .transition(.move(edge: .top))
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
                                                            showWatchNotificationProperties.toggle()
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
                                            
                                        }
                                    }
                                }
                            }
                            .onChange(of: scrollToTop) {
                                scrollView.scrollTo(0, anchor: .top)
                            }
                        }
                    } else {
                        if(currentDisplayMode == .singleSwappable) {
//                            ScrollView {
//                                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center, spacing: currentDisplayMode.scrollSpacing) {
                            
                            SwappableCardComponentView(restApiMovieVm: restApiMovieVm)
                                .frame(width: UIScreen.main.bounds.width)
                            
//                                }
//                            }
//                            .padding([.leading, .trailing], 3)
//                            .ignoresSafeArea()
//                            .scrollTargetLayout()
//                            .scrollTargetBehavior( .paging)
//                            .scrollBounceBehavior(.basedOnSize)
                        } else if(currentDisplayMode == .singleColumnVideo) {
                            ScrollViewReader { scrollView in
                                ScrollView {
                                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center, spacing: currentDisplayMode.scrollSpacing) {
                                        
                                    }
                                }
                            }
                        } else {
                            ScrollViewReader { scrollView in
                                ScrollView {
                                    if showSearchField {
                                        SearchFieldView(restApiMovieVm: restApiMovieVm, showSearchField: $showSearchField)
                                            .padding()
                                    } else {
                                        MovieSection(restApiMovieVm: restApiMovieVm, displayAllGenres: $displayAllGenres, page: $page)
                                            .padding()
                                    }
                                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center, spacing: currentDisplayMode.scrollSpacing) {
                                        SimpleMovieCardComponentView(restApiMovieVm: restApiMovieVm, shwoWatchNotificationProperties: $showWatchNotificationProperties, showScrollToTopOption: $showScrollToTopOption, currentDisplayMode: currentDisplayMode)
                                    }
                                }
                                .padding([.leading, .trailing], 3)
                                .onChange(of: scrollToTop) {
                                    scrollView.scrollTo(0, anchor: .top)
                                }
                            }
                        }
                    }
                }
            }
            .background(Color("PrimaryBackground").ignoresSafeArea())
            .overlay(alignment: .bottomTrailing) {
                
                VStack {
                    if(showScrollToTopOption) {
                        Button(action: {
                            withAnimation {
                                scrollToTop.toggle()
                                showScrollToTopOption = false
                            }
                        }, label: {
                            ZStack{
                                RadialMenuIcon(radialMenuIsHidden: .constant(true), buttonImage: "arrow.up.circle")
                            }
                            .transition(.slide)
                        })
                        .tint(.red)
                        .frame(width: 60, height: 60)
                    }
                    
                    
                    
                    Button(action: {
                        withAnimation {
                            self.radialMenuIsHidden.toggle()
                        }
                    }, label: {
                        ZStack{
                            RadialMenuIcon(radialMenuIsHidden: $radialMenuIsHidden)
                        }
                    })
                    .tint(.red)
                    .frame(width: 60, height: 60)
                    .radialMenu(isHidden: $radialMenuIsHidden, anchorPosition: .bottomRight, distance: 170, autoClose: true, buttons: [
                        RadialMenuButton(image: "person.crop.square.fill.and.at.rectangle", size: 40, action: {
                            self.showAboutAppPopUp.toggle()
                        }),
                        RadialMenuButton(image: self.isDarkModeOn ? "moon" : "sun.min", size: 40, action: {
                            withAnimation {
                                self.isDarkModeOn.toggle()
                                changeDarkMode(state: isDarkModeOn)
                            }
                        }),
                        
                        RadialMenuButton(image: self.currentDisplayMode.displayModeIcon, size: 40, ignoreAutoclose: true, action: {
                            if(self.currentDisplayMode == .singleColumnVideo) {
                                self.savedCurrentDisplayMode = DisplayModeEnum.singleSwappable.rawValue
                            } else if(self.currentDisplayMode == .singleSwappable) {
                                self.savedCurrentDisplayMode = DisplayModeEnum.triple.rawValue
                            }  else if(self.currentDisplayMode == .triple) {
                                self.savedCurrentDisplayMode = DisplayModeEnum.double.rawValue
                            } else if (self.currentDisplayMode == .double) {
                                self.savedCurrentDisplayMode = DisplayModeEnum.single.rawValue
                            } else {
                                self.savedCurrentDisplayMode = DisplayModeEnum.singleColumnVideo.rawValue
                            }
                        }),
                        RadialMenuButton(image: "magnifyingglass", size: 40, action: {
                            withAnimation {
                                self.showSearchField.toggle()
                            }
                        }),
                        RadialMenuButton(image: "person.circle", size: 40, action: {
                            router.path.append("userPage")
                        })
                    ])
                    .padding(.trailing, 6)
                    .padding(.bottom, currentDisplayMode == .singleSwappable ? 40 : 0)
                    .zIndex(1)
                }
            }
            .onAppear(perform: {
#if DEBUG
                let paths = NSSearchPathForDirectoriesInDomains(FileManager.SearchPathDirectory.documentDirectory, FileManager.SearchPathDomainMask.userDomainMask, true)
                print(paths[0])
#endif
            })
        
            //MARK: - Navigation
            
            .navigationDestination(for: Result.self) { result in
                MoviePageView(restApiMovieVm: restApiMovieVm, movieId: result.id)
            }
            .navigationDestination(for: String.self) {route in
                switch route {
                case "userPage":
                    UserPageView(restApiMovieVm: restApiMovieVm, showSearchField: $showSearchField)
                default:
                    Text("")
                }
            }
            .navigationDestination(for: Int.self) { result in
                MoviePageView(restApiMovieVm: restApiMovieVm, movieId: result)
            }
        }
        .sheet(isPresented: $showAboutAppPopUp, content: {
            DeveloperAppInfoPopup()
        })
        .sheet(isPresented: $showWatchNotificationProperties, content: {
            SetWatchNotificationView(id: restApiMovieVm.details?.id, title: restApiMovieVm.details?.title, posterPath: restApiMovieVm.details?.posterPath, releaseDate: restApiMovieVm.details?.releaseDate?.formatToDate)
                .presentationDetents([.medium])
            
        })
        .task {
            restApiMovieVm.currentMovieCategoryEndpoint = GroupedByCategoryMovieEnum.trending
            await restApiMovieVm.restBaseMovieApi(url: GroupedByCategoryMovieEnum.trending.paginatedPath(page: UrlPage(page: 1)))
        }
        .onAppear {
            setAppTheme()
            contentViewDisplayTimes += 1
            if contentViewDisplayTimes > 20 {
                requestReveiew()
                contentViewDisplayTimes = 0
            }
        }
        .onReceive(restApiMovieVm.$error, perform: { error in
            if error != nil {
                showErrorAlert.toggle()
            }
        })
        .alert(isPresented: $showErrorAlert, content: {
            Alert(title: Text("Error"), message: Text(restApiMovieVm.error?.localizedDescription ?? "") )
        })
    }
    
    func setAppTheme() {
        isDarkModeOn = ThemeVM.shared.getDarkMode()
        changeDarkMode(state: isDarkModeOn)
        
        if(colorScheme == .dark) {
            isDarkModeOn = true
        } else {
            isDarkModeOn = false
        }
        changeDarkMode(state: isDarkModeOn)
    }
    
    func changeDarkMode(state: Bool) {
        (UIApplication.shared.connectedScenes.first as? UIWindowScene)?.windows.first!.overrideUserInterfaceStyle = state ? .dark : .light
        ThemeVM.shared.setDarkMode(enable: state)
    }
    
}

//#Preview {
//    ContentView()
//}



