//
//  ContentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import SwiftUI
import SwiftData
import YouTubePlayerKit



struct ContentView: View {
    
    @State private var radialMenuIsHidden: Bool = true
    @State private var showSearchField: Bool = false
    @State private var isSelectLanguageOn: Bool = false
    @State private var isDarkModeOn: Bool = false
    @State private var autoClose: Bool = false
    @State private var page: Int = 1
    @State private var displayAllGenres: Bool = false
    @State private var showAboutAppPopUp: Bool = false
    
    @AppStorage("isMovieOptionsOn") private var isMovieOptionsOn: Bool = false
    @AppStorage("selectedLanguage") private var selectedLanguage: Language = .en
    @AppStorage("contentViewCurrentDisplayMode") private var savedCurrentDisplayMode: String = "triple"
    @StateObject private var restApiMovieVm: RestApiMovieVM = RestApiMovieVM()
    @EnvironmentObject private var router: Router
    @Environment(\.colorScheme) var colorScheme: ColorScheme
    
    private let notificationVM: NotificationVM = NotificationVM()
    
    private var additionalOptionsPresent: Bool = false
    //    private let pageLimit = 20
    
    //    var currentDisplayMode: DisplayMode {
    //        return DisplayMode.currentDisplayModyByString(str: savedCurrentDisplayMode)
    //    }
    
    var currentDisplayMode: DisplayMode {
        return DisplayMode.currentDisplayModyByString(str: savedCurrentDisplayMode)
    }
    //
    
    var body: some View {
        NavigationStack(path: $router.path) {
            ZStack {
                ScrollView {
                    if showSearchField {
                        SearchFieldView(restApiMovieVm: restApiMovieVm, showSearchField: $showSearchField, selectedLanguage: selectedLanguage)
                            .padding()
                    } else {
                        MovieSection(restApiMovieVm: restApiMovieVm, displayAllGenres: $displayAllGenres, page: $page, selectedLanguage: $selectedLanguage)
                            .padding()
                    }
                    if(self.displayAllGenres && restApiMovieVm.filteredMovieRest == nil) {
                        ForEach(restApiMovieVm.movieByGenreRest.sorted(by: {$0.key.name > $1.key.name}), id: \.key) { movieGenre, movies in
                            VStack(alignment: .leading, spacing: 0) {
                                Text(movieGenre.name)
                                    .font(.title2)
                                    .padding([.top, .leading], 3)
                                    .padding(.trailing , 13)
                                    .background(
                                        UnevenRoundedRectangle(cornerRadii: .init(topLeading: 10, bottomLeading: 0, bottomTrailing: 0, topTrailing: 25), style: .continuous)
                                        //                                                            .frame(width: 40, height: 40)
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
                                                    } else {
                                                        let _ = print("LOAding====>>>><<<<<<<+=============")
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
                    } else {
                        LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center) {
                            
                            if(restApiMovieVm.filteredMovieRest != nil) {
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
                                                let _ = print("THIS IS THE LAST MOVIE)))00000----->>>")
                                                Task {
                                                    await restApiMovieVm.loadNextMoviesBySearchCriteria()
                                                }
                                            } else {
                                                let _ = print("LOAding search results====>>>><<<<<<<+=============")
                                            }
                                        }
                                    }
                                }
                            } else {
                                if let movieRest = restApiMovieVm.movieRest {
                                    ForEach(movieRest.results) { movie in
                                        //                                    let _ = print(restApiMovieVm.currentMovieCategoryEndpoint)
                                        //                        HStack {
                                        //                            Text(movie.title)
                                        //                        }.frame(width: 250, height: 200)
                                        //                            .border(.red)
                                        //                Text(movie.title)
                                        NavigationLink(value: movie) {
                                            AsyncImageView(posterPath: movie.posterPath)
                                                .onAppear {
                                                    if (movie.id == restApiMovieVm.movieRest!.results.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
                                                        //                                            let _ = print("THIS IS THE LAST MOVIE)))00000----->>>")
                                                        if (restApiMovieVm.currentMovieGenreEndpoint != nil) {
                                                            Task {
                                                                await restApiMovieVm.loadNextMovieBySingleGenre()
                                                            }
                                                        } else {
                                                            Task {
                                                                await restApiMovieVm.loadNextMovieByCurrentMovieCategoryEndpoint()
                                                            }
                                                        }
                                                        
                                                    } else {
                                                        //                                            let _ = print("LOAding search results====>>>><<<<<<<+=============")
                                                    }
                                                }
                                        }
                                        
                                    }
                                }
                            }
                        }
                    }
                    
                }
                .padding([.leading, .trailing], 3)
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
                            self.savedCurrentDisplayMode = DisplayMode.double.rawValue
                        } else if(self.currentDisplayMode == .double) {
                            self.savedCurrentDisplayMode = DisplayMode.triple.rawValue
                        } else {
                            self.savedCurrentDisplayMode = DisplayMode.single.rawValue
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
            
            
            
            //MARK: - Navigation
            
            .navigationDestination(for: Result.self) { result in
                MoviePageView(restApiMovieVm: restApiMovieVm, movieId: result.id)
            }
            .navigationDestination(for: String.self) {route in
                switch route {
                case "userPage":
                    UserPageView(restApiMovieVm: restApiMovieVm, showSearchField: $showSearchField,  selectedLanguage: selectedLanguage)
                default:
                    Text("")
                }
                
            }
            .navigationDestination(for: Int.self) { result in
                MoviePageView(restApiMovieVm: restApiMovieVm, movieId: result)
            }
            //            .navigationDestination(for: MovieItem.self) { result in
            //                MoviePageView(restApiMovieVm: restApiMovieVm, movieId: result.id!)
            //            }
        }
        .sheet(isPresented: $showAboutAppPopUp, content: {
            DeveloperAppInfoPopup()
        })
        //        .accentColor
        .task {
            //            if (selectedMovieGenreVm.selectedMovieGenre == nil) {
            //                let _ = print("0000>>>>>>>>>!!!!!")
            //                let _ = print(selectedMovieGenreVm.selectedMovieGenre)
            restApiMovieVm.currentMovieCategoryEndpoint = GroupedByCategoryMovieEnum.trending
            await restApiMovieVm.restBaseMovieApi(url: GroupedByCategoryMovieEnum.trending.paginatedPath(page: UrlPage(page: 1), language: .en))
            //            }
        }
        .onAppear {
            setAppTheme()
        }
        
    }
    
    func handleNotificationTap() {
        print("Notification tapped! Your function is called.")
        // Add your function logic here
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

struct CustomButton: View {
    var body: some View {
        Button(action: {}, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
        .buttonStyle(.borderedProminent)
        .tint(.red)
    }
}


struct CustomButtonB: View {
    var body: some View {
        Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
            /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
        })
        .buttonStyle(.borderedProminent)
        .tint(.blue)
    }
}

struct ButtonMenu: View {
    var body: some View {
        Button(action: {
            
        }, label: {
            VStack(spacing: 10){
                Image(systemName: "star")
                    .font(.title)
                    .foregroundStyle(.blue)
                Text("Favourite")
                    .fontWeight(.bold)
                    .foregroundStyle(.white)
            }
        })
    }
}

struct LanguageButton: View {
    var language: Language
    @Binding var languageToSet: Language
    @Binding var isSelectLanguageOn: Bool
    
    var body: some View {
        Button(language.languageName.name) {
            languageToSet = language
            isSelectLanguageOn = false
        }
        .buttonStyle(.bordered)
    }
}
