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
    @ObservedObject var notificationVM: NotificationVM
    @StateObject private var userPageViewModel: UserPageViewModel = UserPageViewModel()
    
    
    
    @State private var searchQuery: String = ""
    @State private var selectedSortOption: SortOption = .title
    @State private var movieCategory: MovieCategory = .planedToWatch
    //    @State private var currentPageCategory: CurrentPageCategory = .planedToWatch
    @State private var showUpdateDialog: Bool = false
    @State private var dropSearchPageCategory: Bool = false
    @StateObject var movieItemToUpdate: MovieItemToUpdateInfo = MovieItemToUpdateInfo()
    @State private var showNotificationSheet: Bool = false
    @State private var notificationDescription: String?
    
    @State private var silentNotificationForReWatchNotifications: Bool = false
    @State private var allowAutoRewatchListNotifications: Bool = false
    @State private var silentNotificationForPlanedToWatchNotification: Bool = false
    
    
    //    @AppStorage("cardGridColumns") var savedDardGridColumns: Int = 1
    //    @AppStorage("currentDisplayMode") var savedCurrentDisplayMode: DisplayMode = .singleWithOptionsSquare
    
    //    @State private var cardGridColumns: Int = 1
//    @State private var currentDisplayMode: DisplayMode = .singleWithOptionsSquare
    @AppStorage("userPageCurrentDisplayMode") var savedCurrentDisplayMode: String = "singleWithOptionsSquare"
    
    @Binding var expand: Bool
    @Binding var showSearchField: Bool
    
    
    
    
    
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
            if showSearchField {
                VStack {
                    HStack {
                        TextField("Search", text: $searchQuery)
                            .padding(.leading, 10)
                            .padding(6)
                            .background {
                                RoundedRectangle(cornerRadius: 20)
                                    .fill(Color(UIColor.systemGray6))
                            }
                            .overlay(alignment: .trailing) {
                                Button(action: {
                                    userPageViewModel.filterBy(movieItems: dropSearchPageCategory ? allMovies : filteredItems, searchQuery: searchQuery)
                                }, label: {
                                    
                                    Image.resizableSystemImage(systemName: "magnifyingglass")
                                        .foregroundStyle(.black)
                                        .padding(7)
                                    //                                    .background(Color(UIColor.systemGray6))
                                        .background {
                                            Circle().fill(Color(UIColor.systemGray6))
                                        }
                                    
                                })
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
                                .foregroundStyle(.black)
                            
                        })
                    }
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
                            MoviePageView(restApiMovieVm: restApiMovieVm, notificationVM: notificationVM, movieId: movie.id!)
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
        
        .padding(.top, showSearchField ? 85 : 35)
        .ignoresSafeArea()
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
                                                .frame(width: self.expand ?  UIScreen.main.bounds.width : 0,
                                                       height: self.expand ? UIScreen.main.bounds.width : 0 )
                                        }
                                        
                                        .offset(x: -50, y: -50)
                                        .zIndex(1)
                                        
                                    }
                                    if self.expand {
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
                                            
                                            Button {
                                                
                                                self.movieCategory = .planedToWatch
                                            } label: {
                                                Label("Planed to watch", systemImage: "calendar.badge.clock")
                                            }
                                            .offset(x: -160, y:  -130)
                                            
                                            Button {
                                                //                                                if (!isDoubleWithOptionsSquareWasShown) {
                                                //                                                    self.currentDisplayMode = .singleWithOptionsSquare
                                                //                                                }
                                                self.movieCategory = .watched
                                            } label: {
                                                Label("Watched", systemImage: "calendar.badge.clock")
                                            }
                                            .offset(x: -150, y:  -180)
                                            
                                            Button {
                                                self.movieCategory = .favourites
                                            } label: {
                                                Label("Favourites", systemImage: "calendar.badge.clock")
                                            }
                                            .offset(x: -180, y:  -100)
                                            
                                            Button {
                                                self.showNotificationSheet.toggle()
                                            } label: {
                                                Label("Notifications settings", systemImage: showNotificationSheet ? "bell.circle" : "bell")
                                            }
                                            .offset(x: -150, y:  -70)
                                            
                                            
                                            Button {
                                                if(self.currentDisplayMode == .single) {
                                                    self.savedCurrentDisplayMode = DisplayMode.double.rawValue
                                                } else if(self.currentDisplayMode == .double) {
                                                    self.savedCurrentDisplayMode = DisplayMode.triple.rawValue
                                                } else if(self.currentDisplayMode == .triple) {
                                                    self.savedCurrentDisplayMode = DisplayMode.singleWithOptionsSquare.rawValue
                                                } else {
                                                    self.savedCurrentDisplayMode = DisplayMode.single.rawValue
                                                }
                                            } label: {
                                                Image(systemName: self.currentDisplayMode.displayModeIcon)
                                            }
                                            .offset(x: -160, y:  -30)
                                            
                                        }
                                        .foregroundStyle(.black)
                                    }
                                    
                                }
                                
                            }
                        
                    }
                    .border(.red)
                }
            }
        }
        //        .sheet(isPresented: $showUpdateDialog, content: {
        //            NavigationStack {
        //
        ////                Text(movieItemToUpdate?.title)
        //                List {
        //                    Section("Notification description") {
        //                        TextField(movieItemToUpdate.movieItem?.title ?? "Set description", text: Binding(get: {
        //                            self.notificationDescription ?? movieItemToUpdate.movieItem?.title ?? ""
        //                        }, set: {
        //                            self.notificationDescription = $0
        //                        }))
        //                    }
        //                        Section("Notificaiton properties") {
        //                            Toggle("Silent notificaiton", isOn: $silentNotificationForPlanedToWatchNotification)
        //                            VStack {
        //                                HStack {
        //
        //
        //                                        Button("This evening") {
        //
        //                                        }
        //                                        .buttonStyle(.borderedProminent)
        //
        //                                        Button("Tomorrow") {
        //
        //                                        }
        //                                        .buttonStyle(.borderedProminent)
        //
        //                                        Button("next month") {
        //
        //                                        }
        //                                        .buttonStyle(.borderedProminent)
        //
        //                                    }
        //                                Text("Or")
        //                                DatePicker("", selection: Binding(get: {
        //                                    notificationVM.movieItem?.personalDateToWatch ?? .now
        //                                }, set: {
        //                                    notificationVM.movieItem?.personalDateToWatch = $0
        //                                }), in: Date()...)
        //                                }
        //                            }
        //
        //                    HStack {
        //                        Button {
        //
        //                        } label: {
        //                            Text("Save")
        //                                .frame(maxWidth: .infinity)
        //                        }
        //                        .buttonStyle(.borderedProminent)
        //
        //                        Button {
        //
        //                        } label: {
        //                            Text("Cancel")
        //                                .frame(maxWidth: .infinity)
        //                                .background(Color(UIColor.systemRed))
        //                        }
        //                        .buttonStyle(.borderedProminent)
        //                    }
        //
        //
        //                }
        //            }
        //            .presentationDetents([.medium])
        
        
        //        }
        //        )
        .sheet(isPresented: $showUpdateDialog, onDismiss: {
            self.movieItemToUpdate.movieItem = nil
        }, content: {
            SetWatchNotificationView(notificationVM: notificationVM, id: movieItemToUpdate.movieItem?.id, title: self.movieItemToUpdate.movieItem?.title)
                .presentationDetents([.medium])
        })
        
        
        .sheet(isPresented: $showNotificationSheet, content: {
            NavigationStack {
                List {
                    TipView(rewatchNotificationTip, arrowEdge: .bottom)
                    Button("help"){
                        RewatchNotificationTip.displayTip.toggle()
                        print("action")
                    }
                    .popoverTip(rewatchNotificationTip)
                    
                    
                    //                    if (tipKitVisible) {
                    //                        RewatchNotificationTip()
                    //                    }
                    
                    //                        .popoverTip(RewatchNotificationTip())
                    
                    Section("Notification settings") {
                        Toggle("Allow rewatch notifications", isOn: $allowAutoRewatchListNotifications)
                        Toggle("Allow sound", isOn: $silentNotificationForReWatchNotifications)
                            .disabled(!allowAutoRewatchListNotifications)
                        
                        
                    }
                    Section("Reminde to rewatch after:") {
                        HStack {
                            Spacer()
                            Button("remo") {
                                
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Spacer()
                            
                            Button("remo") {
                                
                            }
                            .buttonStyle(.borderedProminent)
                            
                            Spacer()
                            
                            Button("remo") {
                                
                            }
                            .buttonStyle(.borderedProminent)
                            Spacer()
                        }
                    }
                }
                
            }
            .presentationDetents([.fraction(0.6)])
        })
        .onAppear {
            self.expand = false
        }
        .task {
            try? await Tips.configure()
        }
    }
}

//#Preview {
//    UserPageView(restApiMovieVm: .init(), cardGridColumns: .constant(3), expand: .constant(false), movieItemToUpdate: .init, showSearchField: .constant(false), currentDisplayMode:  .constant(.triple), selectedLanguage: .en)
//}
