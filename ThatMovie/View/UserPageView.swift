//
//  UserPageView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 13.12.2023.
//

import SwiftUI
import SwiftData

struct UserPageView: View {
    
    @Query private var allMovies: [MovieItem]
    @Environment(\.dismiss) var dismiss
    @ObservedObject var restApiMovieVm: RestApiMovieVM
    @StateObject private var userPageViewModel: UserPageViewModel = UserPageViewModel()
    @AppStorage("userPageCurrentDisplayMode") var savedCurrentDisplayMode: String = "singleWithOptionsSquare"
    
    @State private var searchQuery: String = ""
    @State private var selectedSortOption: SortOptionEnum = .title
    @State private var movieCategory: MovieCategory = .plannedToWatch
    @State private var showUpdateDialog: Bool = false
    @State private var dropSearchPageCategory: Bool = false
    @StateObject var movieItemToUpdate: MovieItemToUpdateInfo = MovieItemToUpdateInfo()
    @State private var notificationDescription: String?
    @State private var radialMenuIsHidden: Bool = true
    @Binding var showSearchField: Bool
    
    private let notificationVM: NotificationVM = NotificationVM()
    var filteredByCategoryMovies: [MovieItem] {
        let sortedBy = selectedSortOption.sortBy(movieItems: allMovies)
        return movieCategory.filterByPageCategory(movieItems: sortedBy)
    }
    var currentDisplayMode: DisplayModeEnum {
        return DisplayModeEnum.currentDisplayModByString(str: savedCurrentDisplayMode)
    }
    
    var body: some View {
        ScrollView {
            HStack {
                Text(movieCategory.titleRepresentation)
                    .font(.title)
            }
            .padding()
            if (showSearchField) {
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
                                    userPageViewModel.filterBy(movieItems: dropSearchPageCategory ? allMovies : filteredByCategoryMovies, searchQuery: searchQuery)
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
                                ForEach(SortOptionEnum.allCases,
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
                ForEach(userPageViewModel.filteredResults != nil ? userPageViewModel.filteredResults! : filteredByCategoryMovies) { movie in
                    NavigationLink {
                        MoviePageView(restApiMovieVm: restApiMovieVm, movieId: movie.id ?? -1)
                    } label: {
                        currentDisplayMode.movieCardView(movie: movie, showUpdateDialog: $showUpdateDialog, movieItemToUpdate: movieItemToUpdate, notificationVM: notificationVM, movieCategory: movieCategory)
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
                        self.savedCurrentDisplayMode = DisplayModeEnum.double.rawValue
                    } else if(self.currentDisplayMode == .double) {
                        self.savedCurrentDisplayMode = DisplayModeEnum.triple.rawValue
                    } else if(self.currentDisplayMode == .triple) {
                        self.savedCurrentDisplayMode = DisplayModeEnum.singleWithOptionsSquare.rawValue
                    } else {
                        self.savedCurrentDisplayMode = DisplayModeEnum.single.rawValue
                    }
                }),
                RadialMenuButton(image: "magnifyingglass", size: 40, action: {
                    withAnimation {
                        self.showSearchField.toggle()
                    }
                }),
                RadialMenuButton(image: "star.fill", size: 40, action: {
                    self.movieCategory = .favourites
                }),
                RadialMenuButton(image: "eye", size: 40, action: {
                    self.movieCategory = .watched
                }),
                RadialMenuButton(image: "calendar.badge.clock", size: 40, action: {
                    self.movieCategory = .plannedToWatch
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
        .overlay(alignment: .center) {
            
            
            
            if (!searchQuery.isEmpty && userPageViewModel.filteredResults != nil && userPageViewModel.filteredResults!.isEmpty) {
                
                Text("Nothing was found" )
            } else if(filteredByCategoryMovies.isEmpty) {
                Text("Nothing to display")
            }
            
            
            
            
            //                if (allMovies.isEmpty || (userPageViewModel.filteredResults != nil && userPageViewModel.filteredResults!.isEmpty)) {
            //                VStack {
            //                    Text("Nothing was found")
            //                }
            //            }
            //            if (userPageViewModel.filteredResults != nil && !userPageViewModel.filteredResults!.isEmpty || !filteredByCategoryMovies.isEmpty)  {
            //            }
        }
    }
}

#Preview {
    UserPageView(restApiMovieVm: .init(), showSearchField: .constant(false))
}
