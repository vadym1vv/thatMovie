//
//  UpdateMovieItem.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 16.10.2023.
//

import SwiftUI

struct UpdateMovieItemView: View {
    
    @Bindable var movieItem: MovieItem
    
    
    var body: some View {
        VStack {
            TextField("Movie name", text: $movieItem.movieName)
            Picker("Select personal rating", selection: $movieItem.personalRating) {
                Text("\(movieItem.personalRating)")
            }
            DatePicker("Select watched date", selection: $movieItem.dateOfViewing, displayedComponents: .date)
//            DatePicker("Select date to watch again", selection: $dateToWatchAgain)
            Toggle("Recomed to watch again", isOn: $movieItem.recomendTorewatch)
//            TextField("source", text: $source)
            Picker("Select genre", selection: $movieItem.genres) {
//                Text(movieItem.genres.title)
                ForEach(Genres.allCases) {
                    Text($0.title)
                }
            }
//            Button(action: {
//                
//            }, label: {
//                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
//            })
            
        }
    }
}

//#Preview {
//    UpdateMovieItem()
//}
