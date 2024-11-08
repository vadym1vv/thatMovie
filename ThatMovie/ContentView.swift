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
    
    @State private var radialMenuIsHidden: Bool = true
    @State private var showSearchField: Bool = false
    @State private var isDarkModeOn: Bool = false
    @State private var autoClose: Bool = false
    @State private var page: Int = 1
    @State private var displayAllGenres: Bool = false
    @State private var showAboutAppPopUp: Bool = false
    @State private var showErrorAlert: Bool = false
    
    private let notificationVM: NotificationVM = NotificationVM()
    private var additionalOptionsPresent: Bool = false
    
    var currentDisplayMode: DisplayModeEnum {
        return DisplayModeEnum.currentDisplayModByString(str: savedCurrentDisplayMode)
    }
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack(alignment: .top) {
                if showSearchField {
                    SearchFieldView(restApiMovieVm: restApiMovieVm, showSearchField: $showSearchField)
                        .padding()
                } else {
                    MovieSection(restApiMovieVm: restApiMovieVm, displayAllGenres: $displayAllGenres, page: $page)
                        .padding()
                }
                
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
                                                NavigationLink(value: movie) {
                                                    AsyncImageView(posterPath: movie.posterPath)
                                                }
                                                .onAppear {
                                                    if (movie.id == movies.results.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
                                                        Task {
                                                            await restApiMovieVm.loadNextMovieByGenreInGenreList(currentGenre: movieGenre)
                                                        }
                                                    }
                                                }
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
                        ScrollView {
                            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center, spacing: 0) {
                                if(restApiMovieVm.filteredMovieRest!.results.isEmpty) {
                                    Text("Search list is empty")
                                        .font(.largeTitle)
                                } else {
                                    ForEach(restApiMovieVm.filteredMovieRest!.results) { movie in
                                        NavigationLink(value: movie) {
                                            AsyncImageView(posterPath: movie.posterPath)
                                        }
                                        .onAppear {
                                            if (movie.id == restApiMovieVm.filteredMovieRest?.results.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
                                                Task {
                                                    await restApiMovieVm.loadNextMoviesBySearchCriteria()
                                                }
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    } else {
                        if(currentDisplayMode == .singleSwappable) {
//                            ScrollView {
//                                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center, spacing: currentDisplayMode.scrollSpacing) {
                                    SwappableCardComponentView(restApiMovieVm: restApiMovieVm)
//                                }
//                            }
//                            .padding([.leading, .trailing], 3)
//                            .ignoresSafeArea()
//                            .scrollTargetLayout()
//                            .scrollTargetBehavior( .paging)
//                            .scrollBounceBehavior(.basedOnSize)
                        } else {
                            ScrollView { 
                                LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center, spacing: currentDisplayMode.scrollSpacing) {
                                    SimpleMovieCardComponentView(restApiMovieVm: restApiMovieVm)
                                }
                            }
                            .padding([.leading, .trailing], 3)
                        }
                    }
                }
            }
            .background(Color("PrimaryBackground").ignoresSafeArea())
            .overlay(alignment: .bottomTrailing) {
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
                        if(self.currentDisplayMode == .single) {
                            self.savedCurrentDisplayMode = DisplayModeEnum.singleSwappable.rawValue
                        } else if(self.currentDisplayMode == .singleSwappable) {
                            self.savedCurrentDisplayMode = DisplayModeEnum.triple.rawValue
                        }  else if(self.currentDisplayMode == .triple) {
                            self.savedCurrentDisplayMode = DisplayModeEnum.double.rawValue
                        } else {
                            self.savedCurrentDisplayMode = DisplayModeEnum.single.rawValue
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
                .zIndex(1)
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



