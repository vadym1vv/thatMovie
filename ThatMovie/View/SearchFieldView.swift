//
//  SearchField.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.11.2023.
//

import SwiftUI

struct SearchFieldView: View {
    
    @ObservedObject var restApiMovieVm: RestApiMovieVM
    
    @State var showAdditionalSearchCriteria: Bool = false
    @Binding var showSearchField: Bool
    
    //    @State var searchStr: String = ""
    //    @State var releaseYear: Date?
    //    @State var includeAdult: Bool?
    //    @State var selectedGenres: [MovieGenre] = []
    
    @State var searchCriteriaDto: SearchCriteriaDto = SearchCriteriaDto()
    
    
    
    
    var selectedLanguage: Language
    private let currentYear = Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year!
    
    var body: some View {
        
        VStack {
            if(!showAdditionalSearchCriteria){
            HStack {
                
                    TextField(showAdditionalSearchCriteria ? "Filter(Optional)" : "Search", text: Binding(get: {
                        searchCriteriaDto.searchStr ?? ""
                    }, set: {
                        searchCriteriaDto.searchStr = $0
                    }))
                    .padding(.leading, 10)
                    .padding(6)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.systemGray6))
                    }
                    .overlay(alignment: .trailing) {
                        if (!showAdditionalSearchCriteria){
                            ZStack {
                                Button(action: {
                                    restApiMovieVm.searchCriteriaDto = searchCriteriaDto
                                    Task {
                                        await restApiMovieVm.restSearchMovieApi(url:MovieEndpoints.moviesByMovieName(searchCriterias: searchCriteriaDto, page: UrlPage(page: 1), language: .en).urlRequest)
                                    }
                                }, label: {
                                    //                            Image(systemName: "magnifyingglass")
                                    //                                .foregroundStyle(.black)
                                    Image.resizableSystemImage(systemName: "magnifyingglass")
                                        .foregroundStyle(.black)
                                        .padding(7)
                                })
                            }
                        }
                    }
                
                Button(action: {
                    withAnimation {
                        self.showAdditionalSearchCriteria.toggle()
                    }
                    
                    if (self.showAdditionalSearchCriteria == false) {
                        self.restApiMovieVm.filteredMovieRest = nil
                    }
                }, label: {
                    Image.resizableSystemImage(systemName: "slider.horizontal.2.square.badge.arrow.down")
                        .rotationEffect(.degrees(self.showAdditionalSearchCriteria ? 180 : 0))
                        .foregroundStyle(.black)
                    
                    
                })
                Button(action: {
                    withAnimation {
                        self.showSearchField.toggle()
                    }
                    if (self.showSearchField == false) {
                        self.restApiMovieVm.filteredMovieRest = nil
                    }
                }, label: {
                    Image.resizableSystemImage(systemName: "xmark.circle")
                        .foregroundStyle(.black)
                    
                })
            }
            .frame(height: 35)
            }
            if showAdditionalSearchCriteria {
                VStack {
//                    HStack{
//                        if(searchCriteriaDto.searchStr != nil && searchCriteriaDto.searchStr!.isEmpty == false) {
//                            Text(searchCriteriaDto.searchStr!)
//                            Spacer()
//                            Button {
//                                //                                requestByCriteriaIfNotNull()
//                                if(searchCriteriaDto.searchStr == nil && (searchCriteriaDto.selectedGenres.count > 0 || /*searchCriteriaDto.includeAdult != nil ||*/ searchCriteriaDto.releaseYear != nil || searchCriteriaDto.sortBy != nil)) {
//                                    Task {
//                                        await restApiMovieVm.restBaseMovieApi(url:
//                                                                                MovieEndpoints.moviesBySearchCriteria(searchCriterias: searchCriteriaDto, page: UrlPage(page: 1), language: .en).urlRequest)
//                                    }
//                                } else {
//                                    
//                                }
//                            } label: {
//                                Image(systemName: "eraser")
//                            }
//                            
//                        }
//                        
//                    }
                    HStack {
                        //                        DatePicker("Release year", selection: Binding (
                        //                            get: {
                        //                                searchCriteriaDto.releaseYear ?? Int()
                        //                            },
                        //                            set: {
                        //                                searchCriteriaDto.releaseYear = $0
                        //                            }
                        //                        ), displayedComponents: .date)
                        //                        .datePickerStyle(.compact)
                        Text("Release year")
                        Spacer()
                        Picker("Release year", selection: Binding(get: {
                            searchCriteriaDto.releaseYear ?? currentYear
                        }, set: {
                            searchCriteriaDto.releaseYear = $0
                        })) {
                            ForEach(1960...currentYear + 20, id: \.self) { year in
                                Text(String(year))
                            }
                        }
                        .pickerStyle(.menu)
                        if (searchCriteriaDto.releaseYear != nil) {
                            ResetButton(toReset: $searchCriteriaDto.releaseYear)
                        }
                        
                    }
                    
                    
                    
                    //                    HStack {
                    //                        Toggle("Include adult", isOn: Binding (get: {
                    //                            searchCriteriaDto.includeAdult ?? false
                    //                        }, set: {
                    //                            searchCriteriaDto.includeAdult = $0
                    //                        }))
                    //                        .toggleStyle(SwitchToggleStyle())
                    //                        if (searchCriteriaDto.includeAdult != nil) {
                    //                            ResetButton(toReset: $searchCriteriaDto.includeAdult)
                    //                        }
                    //                    }
                    
                    HStack {
                        Text("Sort by")
                        Spacer()
                        Picker("Sort by", selection: Binding(get: {
                            searchCriteriaDto.sortBy ?? .notSelected
                        }, set: {
                            searchCriteriaDto.sortBy = $0
                        })) {
                            ForEach(SortByCriteriaEnum.allCases) { criteria in
                                Text(criteria.strRepresentation)
                            }
                        }
                        .pickerStyle(.menu)
                        if(searchCriteriaDto.sortBy != nil) {
                            ResetButton(toReset: $searchCriteriaDto.sortBy)
                        }
                    }
                    
                    
                    
                    //                    .datePickerStyle(Weel)
                    VStack {
                        HStack{
                            Text("Genres")
                            if(!searchCriteriaDto.selectedGenres.isEmpty) {
                                Button {
                                    searchCriteriaDto.selectedGenres = []
                                } label: {
                                    Image(systemName: "eraser")
                                }
                            }
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(restApiMovieVm.movieGenre?.genres ?? []) { genre in
                                    //                                    MovieSectionItemView(movieItemName: genre.name, isSelected: selectedGenres!.contains(where: {$0 == genre}))
                                    
                                    MovieSectionItemView(movieItemName: genre.name, isSelected: searchCriteriaDto.selectedGenres.contains(where: {$0 == genre}))
                                        .onTapGesture {
                                            if (searchCriteriaDto.selectedGenres.contains(where: {$0 == genre})) {
                                                searchCriteriaDto.selectedGenres.removeAll(where: {$0 == genre})
                                            } else {
                                                searchCriteriaDto.selectedGenres.append(genre)
                                            }
                                        }
                                }
                            }
                        }
                        HStack{
                            Button {
                                //                                if(searchCriteriaDto.searchStr != nil) {
                                //                                    Task {
                                //                                        await restApiMovieVm.restBaseMovieApi(url: ApiUrls.moviesByMovieName(searchCriterias: searchCriteriaDto, page: 1, language: .en))
                                //                                    }
                                //                                } else {
                                restApiMovieVm.searchCriteriaDto = searchCriteriaDto
                                Task {
                                    restApiMovieVm.filteredMovieRest = nil
                                    await restApiMovieVm.restSearchMovieApi(url: MovieEndpoints.moviesBySearchCriteria(searchCriterias: searchCriteriaDto, page: UrlPage(page: 1), language: .en).urlRequest)
                                }
                                //                                }
                            } label: {
                                Label("Discover", systemImage: "magnifyingglass")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                            }
                            .buttonStyle(.borderedProminent)
                            .border(.red)
                            Button(action: {
                                withAnimation {
                                    self.showAdditionalSearchCriteria.toggle()
                                }
                                
                                if (self.showAdditionalSearchCriteria == false) {
                                    self.restApiMovieVm.filteredMovieRest = nil
                                }
                            }, label: {
                                Image.resizableSystemImage(systemName: "slider.horizontal.2.square.badge.arrow.down")
                                    .rotationEffect(.degrees(self.showAdditionalSearchCriteria ? 180 : 0))
                                    .foregroundStyle(.black)
                                
                                
                            })
                            Button(action: {
                                withAnimation {
                                    self.showSearchField.toggle()
                                }
                                if (self.showSearchField == false) {
                                    self.restApiMovieVm.filteredMovieRest = nil
                                }
                            }, label: {
                                Image.resizableSystemImage(systemName: "xmark.circle")
                                    .foregroundStyle(.black)
                                
                            })
                            
//                            Button {
//                                restApiMovieVm.filterByCriteria(searchCriteriaDto: searchCriteriaDto)
//                            } label: {
//                                Label("Filter", systemImage: "magnifyingglass")
//                                    .frame(maxWidth: 200)
//                                
//                            }
//                            .padding(0)
                            
                        }
                        .frame(height: 35)
                        .padding(10)
                    }
                    
                }
                .padding(.top, 5)
                .task {
                    await restApiMovieVm.restMovieGenreListApi(urlRequest: GroupedByCategoryMovieEnum.genre.paginatedPath(page: UrlPage(page: 1), language: Language.en))
                }
            }
        }
    }
    
    //    func requestByCriteriaIfNotNull() {
    //        if(searchCriteriaDto.searchStr == nil && (searchCriteriaDto.selectedGenres.count > 0 || searchCriteriaDto.includeAdult != nil || searchCriteriaDto.releaseYear != nil || searchCriteriaDto.sortBy != nil)) {
    //            Task {
    //                await restApiMovieVm.restBaseMovieApi(url: ApiUrls.moviesBySearchCriteria(searchCriterias: searchCriteriaDto, page: UrlPage(page: 1), language: .en))
    //            }
    //        } else {
    //
    //        }
    //    }
}

struct ResetButton <T>: View {
    @Binding var toReset: T?
    var body: some View {
        Button {
            toReset = nil
        } label: {
            Image(systemName: "eraser")
        }
        
    }
}

#Preview {
    SearchFieldView(restApiMovieVm: .init(), showSearchField: .constant(true), selectedLanguage: .en)
}
