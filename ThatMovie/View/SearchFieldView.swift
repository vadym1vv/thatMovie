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
    @State var searchCriteriaDto: SearchCriteriaDto = SearchCriteriaDto()
    @Binding var showSearchField: Bool
    
    private let currentYear = Calendar(identifier: .gregorian).dateComponents([.year], from: .now).year!
    
    var body: some View {
        
        VStack {
            if(!showAdditionalSearchCriteria){
                HStack {
                    TextField("Search", text: Binding(get: {
                        searchCriteriaDto.searchStr ?? ""
                    }, set: {
                        searchCriteriaDto.searchStr = $0
                    }))
                    .padding(.leading, 10)
                    .padding(6)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color("SecondaryBackground"))
                    }
                    .overlay(alignment: .trailing) {
                        if (!showAdditionalSearchCriteria){
                            Button(action: {
                                restApiMovieVm.searchCriteriaDto = searchCriteriaDto
                                Task {
                                    await restApiMovieVm.restSearchMovieApi(url:MovieEndpointsEnum.moviesByMovieName(searchCriterias: searchCriteriaDto, page: UrlPage(page: 1)).urlRequest)
                                }
                            }, label: {
                                Image.resizableSystemImage(systemName: "magnifyingglass")
                                    .foregroundStyle(Color(UIColor.label))
                                    .padding(7)
                            })
                            .background(.additionalBackground)
                            .clipShape(Circle())
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
                            .foregroundStyle(Color(UIColor.label))
                    })
                    
                    Button(action: {
                        restApiMovieVm.currentMovieCategoryEndpoint = GroupedByCategoryMovieEnum.trending
                        withAnimation {
                            self.showSearchField.toggle()
                        }
                        if (self.showSearchField == false) {
                            self.restApiMovieVm.filteredMovieRest = nil
                        }
                    }, label: {
                        Image.resizableSystemImage(systemName: "xmark.circle")
                            .foregroundStyle(Color(UIColor.label))
                        
                    })
                }
                .frame(height: 35)
            }
            
            if showAdditionalSearchCriteria {
                VStack {
                    HStack {
                        Text("Release year")
                        Spacer()
                        Picker("", selection: Binding(get: {
                            searchCriteriaDto.releaseYear ?? currentYear
                        }, set: {
                            searchCriteriaDto.releaseYear = $0
                        })) {
                            ForEach(1960...currentYear + 20, id: \.self) { year in
                                Text(String(year))
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .tint(Color(UIColor.label).opacity((searchCriteriaDto.releaseYear != nil) ? 1 : 0.4))
                        if (searchCriteriaDto.releaseYear != nil) {
                            ResetButton(toReset: $searchCriteriaDto.releaseYear)
                        }
                        
                    }
                    
                    HStack {
                        Text("Sort by")
                        Spacer()
                        Picker("", selection: Binding(get: {
                            searchCriteriaDto.sortBy ?? .notSelected
                        }, set: {
                            searchCriteriaDto.sortBy = $0
                        })) {
                            ForEach(SortByCriteriaEnum.allCases) { criteria in
                                Text(criteria.strRepresentation)
                            }
                        }
                        .pickerStyle(.menu)
                        .labelsHidden()
                        .tint(Color(UIColor.label).opacity((searchCriteriaDto.sortBy != nil) ? 1 : 0.4))
                        
                        if(searchCriteriaDto.sortBy != nil) {
                            ResetButton(toReset: $searchCriteriaDto.sortBy)
                        }
                    }
                    
                    VStack {
                        HStack{
                            Text("Genres")
                                .opacity(searchCriteriaDto.selectedGenres.isEmpty ? 0.7 : 1)
                            if(!searchCriteriaDto.selectedGenres.isEmpty) {
                                Button {
                                    searchCriteriaDto.selectedGenres = []
                                } label: {
                                    Image(systemName: "eraser")
                                        .foregroundStyle(Color(UIColor.label))
                                }
                            }
                        }
                        ScrollView(.horizontal) {
                            HStack {
                                ForEach(restApiMovieVm.movieGenre?.genres ?? []) { genre in
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
                                restApiMovieVm.searchCriteriaDto = searchCriteriaDto
                                Task {
                                    restApiMovieVm.filteredMovieRest = nil
                                    await restApiMovieVm.restSearchMovieApi(url: MovieEndpointsEnum.moviesBySearchCriteria(searchCriterias: searchCriteriaDto, page: UrlPage(page: 1)).urlRequest)
                                }
                            } label: {
                                Label("Discover", systemImage: "magnifyingglass")
                                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                                    .foregroundStyle(Color(UIColor.label))
                                
                            }
                            .background(Color("SecondaryBackground").clipShape(RoundedRectangle(cornerRadius: 5)))
                            
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
                                    .foregroundStyle(Color(UIColor.label))
                                
                                
                            })
                            Button(action: {
                                restApiMovieVm.currentMovieCategoryEndpoint = GroupedByCategoryMovieEnum.trending
                                withAnimation {
                                    self.showSearchField.toggle()
                                }
                                if (self.showSearchField == false) {
                                    self.restApiMovieVm.filteredMovieRest = nil
                                }
                            }, label: {
                                Image.resizableSystemImage(systemName: "xmark.circle")
                                    .foregroundStyle(Color(UIColor.label))
                                
                            })
                        }
                        .frame(height: 35)
                        .padding(10)
                    }
                }
                .padding(.top, 5)
                .task {
                    await restApiMovieVm.restMovieGenreListApi(urlRequest: GroupedByCategoryMovieEnum.genre.paginatedPath(page: UrlPage(page: 1)))
                }
            }
        }
    }
}

struct ResetButton <T>: View {
    @Binding var toReset: T?
    var body: some View {
        Button {
            toReset = nil
        } label: {
            Image(systemName: "eraser")
                .foregroundStyle(Color(UIColor.label))
        }
        
    }
}

#Preview {
    SearchFieldView(restApiMovieVm: .init(), showSearchField: .constant(true))
}
