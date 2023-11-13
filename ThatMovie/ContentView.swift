//
//  ContentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext
    @StateObject var restApiMovieVM = RestApiMovieVM()
    @StateObject var viewRouter: ViewRouter
    
    @Query private var movies: [MovieItem]
    
    @State var showPopUp = false
    
    @State var selectDeleteM = 0
    @State var expand: Bool = false
    var body: some View {
        
        
//            GeometryReader { geometry in
//                VStack {
//                    Spacer()
//                    switch viewRouter.currentPage {
//                    case .home:
//                        Text("Home")
//                    case .liked:
//                        Text("liked")
//                    case .records:
//                        Text("records")
//                    case .user:
//                        Text("user")
//                    }
//                    Spacer()
//                    ZStack {
//                        HStack {
//                            TabBarIcon(viewRouter: viewRouter, assignedPage: .home, width: geometry.size.width/5, height: geometry.size.height/28, systemIconeName: "homekit", tabName: "Home")
//                            TabBarIcon(viewRouter: viewRouter, assignedPage: .liked, width: geometry.size.width/5, height: geometry.size.height/28, systemIconeName: "heart", tabName: "Liked")
//
//                            TabBarIcon(viewRouter: viewRouter, assignedPage: .records, width: geometry.size.width/5, height: geometry.size.height/28, systemIconeName: "waveform", tabName: "records")
//                            TabBarIcon(viewRouter: viewRouter, assignedPage: .user, width: geometry.size.width/5, height: geometry.size.height/28, systemIconeName: "person.crop.circle", tabName: "Account")
//                        }
//                        .frame(width: geometry.size.width, height: geometry.size.height/8)
//                        .background(.gray)
//                    .shadow(radius: 2)
//                        ZStack {
//                                Circle()
//                                    .foregroundStyle(.white)
//                                    .frame(width: geometry.size.width/7, height: geometry.size.width/7)
//                                    .shadow(radius: 4)
//                                Image(systemName: "plus.circle.fill")
//                                    .resizable()
//                                    .aspectRatio(contentMode: .fit)
//                                    .frame(width: geometry.size.width/7-6, height: geometry.size.width/7-6)
//                                    .foregroundStyle(.purple)
//    //                        Picker("Select personal rating", selection: $selectDeleteM) {
//    //                            ForEach(1...10, id: \.self) {rating in
//    //                                    Text("\(rating)")
//    //
//    //                                            .rotationEffect(Angle(degrees: 90))
//    //                            }
//    //                        }
//    //                        .pickerStyle(.wheel)
//    //                        .rotationEffect(Angle(degrees: -90))
//    //
//    //                        .clipped()
//                            
//                        }
//                        .offset(y: -geometry.size.height/8/2)
//                    }
//                    
//                    
//                    
//                    
//                }
//                .ignoresSafeArea()
//            }
//        NavigationStack {
            ScrollView {
                VStack {
//                    ForEach(movies) { item in
//    //                    Text(item.movieName)
//
//    //                    NavigationLink {2
//    //                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
//    //                    } label: {
//    //                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
//    //                    }
//                        NavigationLink {
//                            UpdateMovieItemView(movieItem: item)
//                        } label: {
//                            Text(item.movieName)
//                        }
//
//
//                    }
//                    .onDelete(perform: deleteItems)
                    
//                    ForEach(restApiMovieVM.movieApiPopular?.results ?? []) { movie in
//                        Text(movie.title)
//                        let _ = print(movie.title)
//                        MovieCardView(posterPath: movie)
//                    }
                    
                }
                .task {
//                    await restApiMovieVM.initApi()
                }
                
                
                
                
                
            }
            .overlay(alignment: .bottom) {
//                NavigationLink {
//                                        AddMovieItemView()
//                                    } label: {
//                                        Label("add item", systemImage: "film")
//                                    }
//                                    .opacity(1)
//                                    Button {
//                //                        addItem()
////                                        AddEditMovieItem(movieItemToUpdate: Binding.constant(nil))
//                                    } label: {
//                                        Label("add item", systemImage: "film")
//                                    }
//                                    .foregroundStyle(.black)
//                ZStack {
//                    Button {
//                            
//                    } label: {
//                        Label("add item", systemImage: "film")
//                    }
//                    .foregroundStyle(.black)
                
                ZStack(alignment: .top) {
                    Circle()
                        .trim(from: 0.5, to: self.expand ? 1 : 0.5)
                        .fill(Color.mint)
                        .frame(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.width)
//
                    
                    ZStack {
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
                        }).offset(x: -100, y: 75)
                        
                        
                        Button(action: {
                            
                            
                        }, label: {
                            VStack(spacing: 10){
                                Image(systemName: "paperplane")
                                    .font(.title)
                                    .foregroundStyle(.blue)
                                Text("Favourite")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        })
                        .offset(y: 30)
                        
                        Button(action: {
                            
                            
                        }, label: {
                            VStack(spacing: 10){
                                Image(systemName: "tray.2")
                                    .font(.title)
                                    .foregroundStyle(.blue)
                                Text("Favourite")
                                    .fontWeight(.bold)
                                    .foregroundStyle(.white)
                            }
                        })
                        .offset(x: 100, y: 75)
                    }
                    .opacity(self.expand ? 1 : 0)
                }
                
//
                
    //                    .rotationEffect(.degrees(280))
                    
//                }
                
            }.offset(y: UIScreen.main.bounds.width / 1.6)
        Button(action: {
            withAnimation {
                self.expand.toggle()
            }
        }, label: {
            Text("Toggle")
                .font(.largeTitle)
        })
        .foregroundStyle(.red)
            
//            .toolbar {
//                ToolbarItem(placement: .bottomBar) {
//                    Spacer()
//                    NavigationLink {
//                        AddMovieItemView()
//                    } label: {
//                        Label("add item", systemImage: "film")
//                    }
////                    Button {
//////                        addItem()
////                        AddEditMovieItem(movieItemToUpdate: Binding.constant(nil))
////                    } label: {
////                        Label("add item", systemImage: "film")
////                    }
//
//                }
//                
//        }
            
            
            
            
//            .onAppear {
//
//            }
            
            
//            .toolbar {
//                ToolbarItem(placement: .navigationBarTrailing) {
//                    EditButton()
//                }
//                ToolbarItem {
//                    Button(action: addItem) {
//                        Label("Add Item", systemImage: "plus")
//                    }
//                }
//            }
            
        }
        
        
        
        
    }

//    private func addItem() {
//        withAnimation {
//            let newItem = Item(timestamp: Date())
//            modelContext.insert(newItem)
//        }
//    }

//    private func deleteItems(offsets: IndexSet) {
//        withAnimation {
//            for index in offsets {
//                modelContext.delete(movies[index])
//            }
//        }
//    }
//}

//struct TabBarIcon: View {
//    
//    @StateObject var viewRouter: ViewRouter
//    let assignedPage: Page
//    
//    let width, height: CGFloat
//    let systemIconeName, tabName: String
//    var body: some View {
//        VStack {
//            Image(systemName: systemIconeName)
//                .resizable()
//                .aspectRatio(contentMode: .fit)
//                .frame(width: width, height: height)
//                .padding(.top, 10)
//            Text(tabName)
//                .font(.footnote)
//            Spacer()
//            
//        }
//        .padding(.horizontal, -5)
//        .onTapGesture{
//            viewRouter.currentPage = assignedPage
//        }
//        .foregroundStyle(viewRouter.currentPage == assignedPage ? Color(UIColor.systemGray6) : .gray)
//    }
//}

#Preview {
    ContentView(viewRouter: ViewRouter())
        .modelContainer(for: MovieItem.self, inMemory: true)
}
