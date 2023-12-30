//
//  ContentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import SwiftUI
import SwiftData

enum DisplayMode {
    
    case single, double, triple, singleWithOptionsSquare
    
    var displayModeIcon: String {
        switch self {
        case .single:
            return "circlebadge.fill"
        case .double:
            return "circle.grid.2x1.fill"
        case .triple:
            return "circle.grid.3x3.fill"
        case .singleWithOptionsSquare:
            return "square.fill.text.grid.1x2"
        }
    }
    
//    func movieCardView(movie: MovieItem) -> some View{
//        switch self {
//        case .single, .double, .triple:
//            return AnyView(MovieCardView(posterPath: movie.posterPath ?? ""))
//        case .doubleWithOptionsSquare:
//            return AnyView(ToWatchOptionsCardView(movieItem: movie))
//        }
//    }
    
    @ViewBuilder
    func movieCardView(movie: MovieItem, showUpdateDialog: Binding<Bool>, movieItemToUpdate: Binding<MovieItem?>, notificationVM: NotificationVM) -> some View{
        switch self {
        case .single, .double, .triple:
             MovieCardView(posterPath: movie.posterPath ?? "")
        case .singleWithOptionsSquare:
            ToWatchOptionsCardView(notificationVM: notificationVM, movieItem: movie, movieItemToUpdate: movieItemToUpdate, showUpdateDialog: showUpdateDialog)
        }
    }
    
}

struct ContentView: View {
    
    @State var expand: Bool = false//menu is up
    @State var showSearchField: Bool = false
    @State var isSelectLanguageOn: Bool = false
    @State var isNightTheme: Bool = false
    @State var currentDisplayMode: DisplayMode = .triple
    @State var page: Int = 1
    @State var cardGridColumns: Int = 3
    @State var displayAllGenres: Bool = false
    
    @AppStorage("isMovieOptionsOn") var isMovieOptionsOn: Bool = false
    @AppStorage("selectedLanguage") var selectedLanguage: Language = .en
    @StateObject var restApiMovieVm: RestApiMovieVM = RestApiMovieVM()
    @EnvironmentObject var router: Router
    @StateObject var notificationVM: NotificationVM = NotificationVM()
    
    private var additionalOptionsPresent: Bool = false
    
    
    
    
    
    var body: some View {
        
        
        //        ZStack {
        NavigationStack(path: $router.path){
            ScrollView {
                if showSearchField {
                    SearchFieldView(restApiMovieVm: restApiMovieVm, showSearchField: $showSearchField, selectedLanguage: selectedLanguage)
                        .padding()
                } else {
                    MovieSection(restApiMovieVm: restApiMovieVm,  displayAllGenres: $displayAllGenres, page: $page, selectedLanguage: $selectedLanguage)
                        .padding()
                    
                    //                if(additionalOptionsPresent) {
                    //                    VStack {
                    //                        AdditionalOptinsView {
                    //
                    //                        }
                    //                    }
                    //                    .frame(width: .infinity, height: 100, alignment: .center)
                    //                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                    //                        Image(systemName: "chevron.compact.down")
                    //                    })
                    //                }
                }
                if(self.displayAllGenres) {
                    let _ = print(restApiMovieVm.movieByGenreRest)
                    //                VStack {
                    ForEach(restApiMovieVm.movieByGenreRest.sorted(by: {$0.key.name > $1.key.name}), id: \.key) { genreName, movies in
                        VStack(alignment: .leading) {
                            ScrollView(.horizontal) {
                                LazyHStack {
                                    ForEach(movies.results) { movie in
                                        NavigationLink(value: movie) {
                                            MovieCardView(posterPath: movie.posterPath ?? "")
                                        }
//                                        MovieCardView(posterPath: movie.posterPath ?? "")
                                        //                                        RoundedRectangle(cornerRadius: 10)
                                        //                                            .frame(width: 150, height: 150)
                                        
                                    }
                                }
                                .frame(height: 300)
                            }
                            .scrollIndicators(.never)
                        }
                        
                    }
                    //                }
                } else {
                    LazyVGrid(columns: Array(repeating: .init(.flexible()), count: cardGridColumns), alignment: .center) {
                        
                        if(restApiMovieVm.filteredMovieRest != nil) {
                            if(restApiMovieVm.filteredMovieRest!.results.isEmpty) {
                                Text("Search list is empty")
                                    .font(.largeTitle)
                            } else {
                                ForEach(restApiMovieVm.filteredMovieRest!.results) { movie in
                                    NavigationLink(value: movie) {
                                        MovieCardView(posterPath: movie.posterPath ?? "")
                                    }
                                }
                            }
                        } else {
                            if let movieRest = restApiMovieVm.movieRest {
                                ForEach(movieRest.results) { movie in
                                    //                        HStack {
                                    //                            Text(movie.title)
                                    //                        }.frame(width: 250, height: 200)
                                    //                            .border(.red)
                                    //                Text(movie.title)
                                    NavigationLink(value: movie) {
                                        MovieCardView(posterPath: movie.posterPath ?? "")
                                    }
                                }
                            }
                        }
                    }
                }
                
                
            }
            .background(ignoresSafeAreaEdges: .bottom)
            //        }
            //        .frame(
            //                    maxWidth: .infinity,
            //                    maxHeight: .infinity
            //                )
            .overlay(alignment: .bottom) {
                HStack {
                    ZStack(alignment: .bottomTrailing) {
                        HStack {
                            Spacer()
                            
                            VStack{}
                                .overlay {
                                    ZStack {
                                        ZStack {
                                            ZStack{
                                                Button(action: {
                                                    withAnimation {
                                                        self.expand.toggle()
                                                        self.isSelectLanguageOn = false
                                                    }
                                                    
                                                }, label: {
                                                    Image(systemName: "arrow.up.left.circle")
                                                        .resizable()
                                                        .scaledToFit()
                                                        .rotationEffect(.degrees(self.expand ? 180 : 0))
                                                    
                                                })
                                                .padding(10)
                                                .tint(.red)
                                                .zIndex(1)
                                                .frame(width: 60, height: 60)
                                                Circle()
                                                    .fill(Color(UIColor.systemGray6))
                                                    .opacity(0.4)
                                                Circle()
                                                    .fill(Color(UIColor.systemGray6)
                                                        .opacity(0.8))
                                                    .frame(width: self.expand ? isSelectLanguageOn ? UIScreen.main.bounds.width + 150 : UIScreen.main.bounds.width + 140 : 0,
                                                           height: self.expand ? isSelectLanguageOn ? UIScreen.main.bounds.width + 150 : UIScreen.main.bounds.width + 140 : 0)
                                            }
                                            
                                            .offset(x: -50, y: -50)
                                            .zIndex(1)
                                            
                                        }
                                        if self.expand {
                                            Group {
                                                if(self.isSelectLanguageOn) {
                                                    
                                                    Group{
                                                        LanguageButton(language: Language.en, languageToSet: $selectedLanguage, isSelectLanguageOn: $isSelectLanguageOn)
                                                            .offset(x: -70, y: -160)
                                                        
                                                        LanguageButton(language: Language.es, languageToSet: $selectedLanguage, isSelectLanguageOn: $isSelectLanguageOn)
                                                            .offset(x: -140, y:  -100)
                                                        
                                                        LanguageButton(language: Language.hi, languageToSet: $selectedLanguage, isSelectLanguageOn: $isSelectLanguageOn)
                                                            .offset(x: -130, y: -20)
                                                        
                                                        
                                                    }
                                                    Group {
                                                        LanguageButton(language: Language.de, languageToSet: $selectedLanguage, isSelectLanguageOn: $isSelectLanguageOn)
                                                            .offset(x: -90, y: -250)
                                                        
                                                        LanguageButton(language: Language.fr, languageToSet: $selectedLanguage, isSelectLanguageOn: $isSelectLanguageOn)
                                                            .offset(x: -190, y: -190)
                                                        
                                                        LanguageButton(language: Language.pl, languageToSet: $selectedLanguage, isSelectLanguageOn: $isSelectLanguageOn)
                                                            .offset(x: -250, y: -110)
                                                        
                                                        LanguageButton(language: Language.ua, languageToSet: $selectedLanguage, isSelectLanguageOn: $isSelectLanguageOn)
                                                            .offset(x: -240, y: -20)
                                                        
                                                    }
                                                    
                                                } else {
                                                    
                                                    Group {
                                                        if(!self.showSearchField) {
                                                            Button(action: {
                                                                withAnimation {
                                                                    self.showSearchField.toggle()
                                                                    self.expand.toggle()
                                                                }
                                                            }, label: {
                                                                Image(systemName: "magnifyingglass")
                                                                    .foregroundStyle(.black)
                                                            })
                                                            .offset(x: -50, y: -195)
                                                        }
                                                        
                                                        Button(action: {
                                                            self.isSelectLanguageOn.toggle()
                                                        }, label: {
                                                            Text("\(self.selectedLanguage.languageName.iso_639_1.capitalized)")
                                                                .padding(3)
                                                                .overlay {
                                                                    RoundedRectangle(cornerRadius: 5)
                                                                        .stroke()
                                                                }
                                                        })
                                                        .offset(x: -150, y:  -130)

                                                        Button {
                                                            if(self.currentDisplayMode == .single) {
                                                                self.currentDisplayMode = .double
                                                                self.cardGridColumns = 2
                                                            } else if(self.currentDisplayMode == .double) {
                                                                self.currentDisplayMode = .triple
                                                                self.cardGridColumns = 3
                                                            } else {
                                                                self.currentDisplayMode = .single
                                                                self.cardGridColumns = 1
                                                            }
                                                        } label: {
                                                            Image(systemName: self.currentDisplayMode.displayModeIcon)
                                                        }
                                                        .offset(x: -160, y:  -30)
                                                        
                                                    }
                                                    .foregroundStyle(.black)
                                                    
                                                    Group {
//                                                        Button {
//                                                            
//                                                        } label: {
//                                                            Image(systemName: "person.circle")
//                                                        }
//                                                        .offset(x: -90, y: -250)
                                                        
                                                        NavigationLink(destination: {
                                                            UserPageView(restApiMovieVm: restApiMovieVm, notificationVM: notificationVM, cardGridColumns: $cardGridColumns, expand: $expand, showSearchField: $showSearchField, currentDisplayMode: $currentDisplayMode, selectedLanguage: selectedLanguage)
                                                        }, label: {
                                                            Image(systemName: "person.circle")
                                                        })
                                                        .offset(x: -90, y: -250)
                                                        
                                                        Button {
                                                            withAnimation {
                                                                self.isNightTheme.toggle()
                                                            }
                                                        } label: {
                                                            Image(systemName: self.isNightTheme ? "moon" : "sun.min")
                                                        }
                                                        .offset(x: -190, y: -190)
                                                        
                                                        
                                                        Button {
                                                            
                                                        } label: {
                                                            Image(systemName: "questionmark.circle")
                                                        }
                                                        .offset(x: -250, y: -110)
                                                        
                                                        Button {
                                                            
                                                        } label: {
                                                            Image(systemName: "person.crop.square.fill.and.at.rectangle")
                                                                .font(.system(size: 25))
                                                        }
                                                        .offset(x: -255, y: -20)
                                                    }
                                                    .foregroundStyle(.black)
                                                    
                                                }
                                                
                                            }
                                            .foregroundStyle(.black)
                                            
                                        }
                                        //                        ButtonMenu().offset(x: -200, y: -10)
                                    }
                                }
                            //                            .padding(.trailing, 5)
                            
                            
                            
                        }
                        
                    }
                    //                .frame(maxWidth: .infinity)
                    
                }
                .border(.red)
            }
            //MARK: - Navigation
            
            .navigationDestination(for: Result.self) { result in
                MoviePageView(restApiMovieVm: restApiMovieVm, notificationVM: notificationVM, movieId: result.id)
            }
//            .navigationDestination(for: MovieItem.self) { result in
//                MoviePageView(restApiMovieVm: restApiMovieVm, movieId: result.id!)
//            }
        }
    }
    
}
//#Preview {
//    ContentView(expand: false, showSearchField: false, isSelectLanguageOn: false, isNightTheme: false, currentDisplayMode: .triple, movies: <#T##MovieRest?#>, page: <#T##Int#>, cardGridColumns: <#T##Int#>, selectedMovieSection: <#T##MovieEndpoints#>, isMovieOptionsOn: <#T##Bool#>, selectedLanguage: <#T##Language#>, restApiMovieVm: <#T##RestApiMovieVM#>, additionalOptionsPresent: <#T##Bool#>)
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
