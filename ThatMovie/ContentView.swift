//
//  ContentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import SwiftUI
import SwiftData

enum DisplayMode {
    
    case single, double, triple
    
    var displayModeIcon: String {
        switch self {
        case .single:
            return "circlebadge.fill"
        case .double:
            return "circle.grid.2x1.fill"
        case .triple:
            return "circle.grid.3x3.fill"
        }
    }
    
}

struct ContentView: View {
    
    @State var expand: Bool = false//menu is up
    @State var showSearchField: Bool = false
    @State var isSelectLanguageOn: Bool = false
    @State var isNightTheme: Bool = false
    @State var currentDisplayMode: DisplayMode = .triple
    @State var movies: MovieRest?
    @State var page: Int = 1
    
    @AppStorage("isMovieOptionsOn") var isMovieOptionsOn: Bool = false
    @AppStorage("selectedLanguage") var selectedLanguage: Language = .en
    @StateObject var restApiMovieVm: RestApiMovieVM = RestApiMovieVM()
    
    private var additionalOptionsPresent: Bool = false
    
    
    
    
   
    var body: some View {
        
        
//        ZStack {
        ScrollView {
            if showSearchField {
                SearchFieldView(showSearchField: $showSearchField)
                    .padding()
            } else {
                MovieSection(restApiMovieVm: restApiMovieVm, page: $page, selectedLanguage: $selectedLanguage)
                    
                    .padding()
                
                if(additionalOptionsPresent) {
                    VStack {
                        AdditionalOptinsView {
                            
                        }
                    }
                    .frame(width: .infinity, height: 100, alignment: .center)
                    Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
                        Image(systemName: "chevron.compact.down")
                    })
                }
            }
                HStack{}
                    .frame(
                                maxWidth: .infinity,
                                maxHeight: .infinity
                            )
            ForEach(restApiMovieVm.movieRest?.results ?? []) { movie in
                //                        HStack {
                //                            Text(movie.title)
                //                        }.frame(width: 250, height: 200)
                //                            .border(.red)
                Text(movie.title)
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
        //                                                withAnimation {
        //                                                    self.showSearchField.toggle()
        //                                                    self.expand.toggle()
        //                                                }
                                                        self.isSelectLanguageOn.toggle()
                                                    }, label: {
                                                        VStack(alignment: .center) {
                                                            
                                                            Button(action: {
                                                                withAnimation {
                                                                    self.isSelectLanguageOn.toggle()
                                                                }
                                                            }, label: {
                                                                Text("\(self.selectedLanguage.languageName.iso_639_1.capitalized)")
                                                                    .padding(3)
                                                                    .overlay {
                                                                        RoundedRectangle(cornerRadius: 5)
                                                                            .stroke()
                                                                    }
    //                                                                .padding(0)
                                                            })
    //                                                        Text("Selected language")
    //                                                            .padding(0)
                                                        }
                                                        })
                                                        .offset(x: -150, y:  -130)
                                                    
                                                        
                                                        //                                            ButtonMenu()
                                                    
                                                    Button {
                                                        if(self.currentDisplayMode == .single) {
                                                            self.currentDisplayMode = .double
                                                        } else if(self.currentDisplayMode == .double) {
                                                            self.currentDisplayMode = .triple
                                                        } else {
                                                            self.currentDisplayMode = .single
                                                        }
                                                    } label: {
                                                        Image(systemName: self.currentDisplayMode.displayModeIcon)
                                                    }
                                                    .offset(x: -160, y:  -30)

                                                }
                                                .foregroundStyle(.black)
                                                
                                                Group {
                                                    Button {
                                                        
                                                    } label: {
                                                        Image(systemName: "person.circle")
                                                    }
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
    }

}
//#Preview {
//    ContentView( movies: MovieApiPopular.init(page: 1, results: [], totalPages: 1, totalResults: 1))
//        .modelContainer(for: MovieItem.self, inMemory: true)
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
