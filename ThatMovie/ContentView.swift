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
    @Query private var movies: [MovieItem]

    var body: some View {
        NavigationStack {
            ScrollView {
                List {
                    ForEach(movies) { item in
    //                    Text(item.movieName)
                        
    //                    NavigationLink {
    //                        Text("Item at \(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))")
    //                    } label: {
    //                        Text(item.timestamp, format: Date.FormatStyle(date: .numeric, time: .standard))
    //                    }
                        NavigationLink {
                            UpdateMovieItemView(movieItem: item)
                        } label: {
                            Text(item.movieName)
                        }
                        

                    }
                    .onDelete(perform: deleteItems)
                }
                
                .toolbar {
                    ToolbarItemGroup(placement: .bottomBar) {
                        Spacer()
                        NavigationLink {
                            AddMovieItemView()
                        } label: {
                            Label("add item", systemImage: "film")
                        }
    //                    Button {
    ////                        addItem()
    //                        AddEditMovieItem(movieItemToUpdate: Binding.constant(nil))
    //                    } label: {
    //                        Label("add item", systemImage: "film")
    //                    }

                    }
            }
            }
            
            
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

    private func deleteItems(offsets: IndexSet) {
        withAnimation {
            for index in offsets {
                modelContext.delete(movies[index])
            }
        }
    }
}

#Preview {
    ContentView()
        .modelContainer(for: MovieItem.self, inMemory: true)
}
