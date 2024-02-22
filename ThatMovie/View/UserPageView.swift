//
//  UserPageView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 13.12.2023.
//

import SwiftUI
import SwiftData
import TipKit
import YouTubePlayerKit
//enum CurrentPageCategory {
//    case favourites, planedToWatch, none
//
////        var currentPageView: some View {
////            switch self {
////            case .favourites(let movieItem):
////                <#code#>
////            case .planedToWatch(let movieItem):
////                <#code#>
////            }
////        }
//
//
//
//
////    func filterBy(movieItems: [MovieItem]) -> [
//
////    func filterBy(movieItems: [MovieItem]) -> [MovieItem] {
////        switch self {
////        case .title:
////            <#code#>
////        case .releasedDate:
////            <#code#>
////        case .addedDate:
////            <#code#>
////        }
////    }
//
//    func filterByPageCategory(movieItems: [MovieItem]) -> [MovieItem] {
//        switch self {
//        case .favourites:
//            return movieItems.filter({$0.personalIsFavourite})
//        case .planedToWatch:
//            return movieItems.filter({$0.personalIsPlanedToWatch})
//        case .none:
//            return movieItems
//        }
//    }
//}


struct UserPageView: View {
    
    @Query private var allMovies: [MovieItem]
    @Environment(\.dismiss) var dismiss
    
    @ObservedObject var restApiMovieVm: RestApiMovieVM
    @StateObject private var userPageViewModel: UserPageViewModel = UserPageViewModel()
    
    
    
    @State private var searchQuery: String = ""
    @State private var selectedSortOption: SortOption = .title
    @State private var movieCategory: MovieCategory = .planedToWatch
    //    @State private var currentPageCategory: CurrentPageCategory = .planedToWatch
    @State private var showUpdateDialog: Bool = false
    @State private var dropSearchPageCategory: Bool = false
    @StateObject var movieItemToUpdate: MovieItemToUpdateInfo = MovieItemToUpdateInfo()
//    @State private var showNotificationSheet: Bool = false
    @State private var notificationDescription: String?
    
//    @State private var silentNotificationForReWatchNotifications: Bool = false
//    @State private var allowAutoRewatchListNotifications: Bool = false
    @State private var silentNotificationForPlanedToWatchNotification: Bool = false
    
    
    
    //    @AppStorage("cardGridColumns") var savedDardGridColumns: Int = 1
    //    @AppStorage("currentDisplayMode") var savedCurrentDisplayMode: DisplayMode = .singleWithOptionsSquare
    
    //    @State private var cardGridColumns: Int = 1
    //    @State private var currentDisplayMode: DisplayMode = .singleWithOptionsSquare
    
    
    @AppStorage("userPageCurrentDisplayMode") var savedCurrentDisplayMode: String = "singleWithOptionsSquare"
    
    @State private var radialMenuIsHidden: Bool = true
    @Binding var showSearchField: Bool
    
    
    private let notificationVM: NotificationVM = NotificationVM()
    
    
    var rewatchNotificationTip = RewatchNotificationTip()
    //    let notificationVM = NotificationVM()
    
    
    let selectedLanguage: Language
    
    var filteredItems: [MovieItem] {
        let sortedBy = selectedSortOption.sortBy(movieItems: allMovies)
        return movieCategory.filterByPageCategory(movieItems: sortedBy)
    }
    
    var currentDisplayMode: DisplayMode {
        return DisplayMode.currentDisplayModyByString(str: savedCurrentDisplayMode)
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Text(movieCategory.titleRepresentation)
                    .font(.title)
            }
            .padding()
            if true {
                VStack {
                    HStack {
                        TextField("Search", text: $searchQuery)
                            .padding(.leading, 10)
                            .padding(6)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color("SecondaryBackground"))
                            }
                            .overlay(alignment: .trailing) {
                                Button(action: {
                                    userPageViewModel.filterBy(movieItems: dropSearchPageCategory ? allMovies : filteredItems, searchQuery: searchQuery)
                                }, label: {
                                    
                                    Image.resizableSystemImage(systemName: "magnifyingglass")
                                        .padding(7)
                                })
                                .background(.additionalBackground)
                                .clipShape(Circle())
                            }
                        Button(action: {
                            withAnimation {
                                self.showSearchField.toggle()
                            }
                            self.userPageViewModel.filteredResults = nil
                            if (self.showSearchField == false) {
                                self.restApiMovieVm.filteredMovieRest = nil
                            }
                        }, label: {
                            Image.resizableSystemImage(systemName: "xmark.circle")
                        })
                    }
                    .foregroundStyle(Color(UIColor.label))
                    .frame(height: 30)
                    
                    HStack {
                        HStack {
                            Text("Sort by:")
                            Picker("", selection: $selectedSortOption) {
                                ForEach(SortOption.allCases,
                                        id: \.rawValue) { option in
                                    Text(option.description)
                                        .tag(option)
                                }
                            }
                            .labelsHidden()
                        }
                        Spacer()
                    }
                }
                .padding(10)
            }
            LazyVGrid(columns: Array(repeating: .init(.flexible()), count: currentDisplayMode.cardGridColumns), alignment: .center) {
                
                if (allMovies.isEmpty || (userPageViewModel.filteredResults != nil && userPageViewModel.filteredResults!.isEmpty)) {
                    Text("Nothing to display")
                } else {
                    
                    ForEach(userPageViewModel.filteredResults != nil ? userPageViewModel.filteredResults! : filteredItems) { movie in
                        //                        if let id = movie.id {
                        //                        let _ = print(movie.id)
                        NavigationLink {
                            MoviePageView(restApiMovieVm: restApiMovieVm, movieId: movie.id!)
                        } label: {
                            currentDisplayMode.movieCardView(movie: movie, showUpdateDialog: $showUpdateDialog, movieItemToUpdate: movieItemToUpdate, notificationVM: notificationVM)
                            //                            MovieCardView(posterPath: movie.posterPath ?? "")
                            //                            Text("asf")
                        }
                        //                        }
                    }
                }
            }
        }
        .padding([.leading, .trailing], 5)
        .background(content: {
            Color("PrimaryBackground")
                .ignoresSafeArea()
        })
        
        .padding(.top, showSearchField ? 85 : 35)
        .ignoresSafeArea()
        .overlay(alignment: .bottomTrailing) {
            Button(action: {
                withAnimation {
                    self.radialMenuIsHidden.toggle()
                }
            }, label: {
                ZStack{
                    
                    RadialMenuIcon(radialMenuIsHidden: $radialMenuIsHidden)
                    //                            .background(Color("SecondaryBackground"))
                }
            })
            .tint(Color("DeleteColor"))
            .frame(width: 60, height: 60)
            .radialMenu(isHidden: $radialMenuIsHidden, anchorPosition: .bottomRight, distance: 170, autoClose: true, buttons: [
//                RadialMenuButton(image: showNotificationSheet ? "bell.circle" : "bell", size: 40, action: {
//                    self.showNotificationSheet.toggle()
//                }),
                RadialMenuButton(image: self.currentDisplayMode.displayModeIcon, size: 40, action: {
                    if(self.currentDisplayMode == .single) {
                        self.savedCurrentDisplayMode = DisplayMode.double.rawValue
                    } else if(self.currentDisplayMode == .double) {
                        self.savedCurrentDisplayMode = DisplayMode.triple.rawValue
                    } else if(self.currentDisplayMode == .triple) {
                        self.savedCurrentDisplayMode = DisplayMode.singleWithOptionsSquare.rawValue
                    } else {
                        self.savedCurrentDisplayMode = DisplayMode.single.rawValue
                    }
                }),
                RadialMenuButton(image: "magnifyingglass", size: 40, action: {
                    withAnimation {
                        self.showSearchField.toggle()
                        self.radialMenuIsHidden.toggle()
                    }
                }),
                RadialMenuButton(image: "star.fill", size: 40, action: {
                    self.movieCategory = .favourites
                }),
                RadialMenuButton(image: "eye", size: 40, action: {
                    self.movieCategory = .watched
                }),
                RadialMenuButton(image: "calendar.badge.clock", size: 40, action: {
                    self.movieCategory = .planedToWatch
                })
            ])
            .padding(.trailing, 6)
            .zIndex(1)
        }
        .sheet(isPresented: $showUpdateDialog, onDismiss: {
            self.movieItemToUpdate.movieItem = nil
        }, content: {
            SetWatchNotificationView(id: movieItemToUpdate.movieItem?.id, title: self.movieItemToUpdate.movieItem?.title)
                .presentationDetents([.medium])
            
        })
//        .sheet(isPresented: $showNotificationSheet, content: {
//            RemindeToWatchView()
//        })
    }
}




#Preview {
    UserPageView(restApiMovieVm: .init(), showSearchField: .constant(false), selectedLanguage: .en)
}
