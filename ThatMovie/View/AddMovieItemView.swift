//
//  AddNewMovieView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.10.2023.
//

import SwiftUI
import SwiftData
import PhotosUI

struct AddMovieItemView: View {
    @Environment(\.modelContext) private var modelContext
    
    @State private  var movieName: String = ""
    @State private var banner: Data?
    @State private var personalRating: Int = 1
    @State private var dateOfViewing: Date = .now
    @State private var dateToWatchAgain: Date? = .now
    @State private var recomendTorewatch: Bool = false
    @State private var source: String? = ""
    @State private var genres: Genres = Genres.UNKNOWN
    @State private var selectedPhoto: PhotosPickerItem?
    
    var body: some View {
        VStack {
            
            HStack(alignment: .center) {
                Text("Select personal rating")
                Picker("Select personal rating", selection: $personalRating) {
                    ForEach(1...10, id: \.self) {rating in
                            Text("\(rating)")
                    }
                }
                .pickerStyle(.wheel)
                .frame(maxWidth: 100)
            }
            .frame(maxWidth: 700)
            
            TextField("Movie name", text: $movieName)
            
//            Picker
            DatePicker("Select watched date", selection: $dateOfViewing, displayedComponents: .date)
//            DatePicker("Select date to watch again", selection: $dateToWatchAgain)
            Toggle("Recomed to watch again", isOn: $recomendTorewatch)
//            TextField("source", text: $source)
            Picker("Select genre", selection: $genres) {
                Text(genres.title)
            }
            
            Section {
                            
                            if let selectedPhotoData = banner,
                               let uiImage = UIImage(data: selectedPhotoData) {
                                Image(uiImage: uiImage)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: .infinity, maxHeight: 300)
                            }
                            
                            PhotosPicker(selection: $selectedPhoto,
                                         matching: .images,
                                         photoLibrary: .shared()) {
                                Label("Add Image", systemImage: "photo")
                            }
                            
                if banner?.isEmpty != nil {
                                
                                Button(role: .destructive) {
                                    withAnimation {
                                        selectedPhoto = nil
                                        banner = nil
//                                        item.image = nil
                                    }
                                } label: {
                                    Label("Remove Image", systemImage: "xmark")
                                        .foregroundStyle(.red)
                                }
                            }
             
                        }
            
            Button(action: {
                let movieItem = MovieItem(movieName: movieName, banner: banner, personalRating: personalRating, dateOfViewing: dateOfViewing, dateToWatchAgain: dateToWatchAgain, recomendTorewatch: recomendTorewatch, source: source, genres: genres)
                
                    modelContext.insert(movieItem)
                
                
            }, label: {
                /*@START_MENU_TOKEN@*/Text("Button")/*@END_MENU_TOKEN@*/
            })
            
        }
        .task(id: selectedPhoto) {
            if let data = try? await selectedPhoto?.loadTransferable(type: Data.self) {
                banner = data
            }
        }
    }
}

//#Preview {
////    var movieItem = MovieItem(movieName: "mName", banner: "locatoin", personalRating: 1, dateOfViewing: Date.now, dateToWatchAgain: Date.now, recomendTorewatch: false, source: "URL or other source", genres: .UNKNOWN)
//    AddEditMovieItem(movieName: "asf", personalRating: 1, dateOfViewing: .now, recomendTorewatch: false, movieItemToUpdate: .constant(MovieItem(movieName: "asf", personalRating: 1, dateOfViewing: .now, recomendTorewatch: false, genres: .UNKNOWN)))
//}
