//
//  ToWatchOptionsCardView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 19.12.2023.
//

import SwiftUI

struct ToWatchOptionsCardView: View {
    
    @ObservedObject var notificationVM: NotificationVM
    @State var movieItem: MovieItem
    @Binding var movieItemToUpdate: MovieItem?
    @Binding var showUpdateDialog: Bool

    var body: some View {
        
        HStack {
            AsyncImage(url: URL(string: "\(ApiUrls.baseImageUrl)\(movieItem.posterPath ?? defaultImage())")) { image in
                image
                    .resizable()
                    .scaledToFit()
            } placeholder: {
                ProgressView()
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(1)
            Spacer()
            VStack {
                Button {
                    if (movieItem.personalDateToWatch != nil) {
                        movieItem.personalDateToWatch = nil
                    } else {
                        notificationVM.movieItem = movieItem
//                        movieItemToUpdate = movieItem
                        showUpdateDialog = true
                    }
                } label: {
                    HStack {
                        if let personalDateToWatch = movieItem.personalDateToWatch {
                            Text("\(personalDateToWatch.formatted(date: .numeric, time: .shortened))")
                        }
                        Label(movieItem.personalDateToWatch != nil ? "cancel" : "set date", systemImage: movieItem.personalDateToWatch != nil ? "bell.slash" : "bell")
//                        Image(systemName: movieItem.personalDateToWatch != nil ? "bell.slash" : "bell")
                    }
                    
                }
//                .overlay(alignment: .trailing) {
//                    DatePicker("", selection: Binding(get: {
//                        movieItem.personalDateToWatch ?? .now
//                    }, set: {
//                        movieItem.personalDateToWatch = $0
//                    }), displayedComponents: .date)
//                }

                Button {
                    movieItem.personalIsPlanedToWatch = false
                } label: {
                    Label("cancel", systemImage: "xmark.circle")
                }
                
                Button {
                    movieItem.personalDateOfViewing = Date.now
                } label: {
                    Label("Watched", systemImage: "clock.badge.checkmark")
                }

            }
        }
    }
    func defaultImage() -> String {
        if let defaultImagePath = Bundle.main.resourcePath {
            let imageName = "noImage.jpg"
            return defaultImagePath + "/" + imageName
        }
        return ""
    }
}

//#Preview {
//    ToWatchOptionsCardView(movieItem: .init(personalRecomendTorewatch: <#T##Bool#>, personalShowNotification: <#T##Bool#>), movieItemToUpdate: <#Binding<MovieItem?>#>, showUpdateDialog: <#Binding<Bool>#>)
//}
