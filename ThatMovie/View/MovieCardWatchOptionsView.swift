//
//  ToWatchOptionsCardView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 19.12.2023.
//

import SwiftUI

struct MovieCardWatchOptionsView: View {
    
    @ObservedObject var notificationVM: NotificationVM
    @State var movieItem: MovieItem
    @ObservedObject var movieItemToUpdate: MovieItemToUpdateInfo
    @Binding var showUpdateDialog: Bool
    
    var body: some View {
        
    HStack {
        AsyncImageView(posterPath: movieItem.posterPath)
            .frame(width: 150)
//                .padding()
        Spacer()
        
        VStack {
            Text(movieItem.title.unwrap)
                .font(.title3)
            Divider()
            HStack {
                Text("Scheduled:")
                    .foregroundStyle(.black)
                if(movieItem.personalDateToWatch != nil) {
                    Text("\(movieItem.personalDateToWatch!.formatted(date: .numeric, time: .shortened))")
                    Button(role: .destructive) {
                        movieItem.personalIsPlanedToWatch = true
                        movieItem.personalDateToWatch = nil
                        if let id = movieItem.id {
                            notificationVM.removePendingNotification(identifier: String(id))
                        }
                    } label: {
                        Image(systemName: "xmark")
                    }
                } else {
                    Button {
                        self.movieItemToUpdate.movieItem = movieItem
                        self.showUpdateDialog.toggle()
                    } label: {
                            Label("Set date", systemImage: "bell")
                    }
                    
                }
            }
            Divider()
            HStack {
                Button {
                    movieItem.personalDateOfViewing = Date.now
                    movieItem.personalIsPlanedToWatch = false
                    movieItem.personalDateToWatch = nil
                    if let id = movieItem.id {
                        notificationVM.removePendingNotification(identifier: String(id))
                    }
                } label: {
                    Label("Watched", systemImage: "clock.badge.checkmark")
                }
                
                Button(role: .destructive) {
                    movieItem.personalIsPlanedToWatch = false
                    movieItem.personalDateToWatch = nil
                    movieItem.personalDateOfViewing = nil
                    if let id = movieItem.id {
                        notificationVM.removePendingNotification(identifier: String(id))
                    }
                } label: {
                    Image(systemName: "trash")
                }
                .buttonStyle(.borderedProminent)
            }
        }
        //            VStack {
        //                HStack{
        //                    HStack {
        //                        Text("Scheduled:")
        //                            .foregroundStyle(.black)
        ////                        if(movieItem.personalDateToWatch != nil) {
        ////                            Text(movieItem.personalDateToWatch!.formatted(date: .numeric, time: .shortened))
        ////                        } else {
        ////                            Button {
        ////                                if (movieItem.personalDateToWatch != nil) {
        ////                                    movieItem.personalDateToWatch = nil
        ////                                } else {
        //////                                    notificationVM.movieItem = movieItem
        ////                                    //                        movieItemToUpdate = movieItem
        ////                                    showUpdateDialog = true
        ////                                }
        ////                            } label: {
        ////                                HStack {
        ////                                    if let personalDateToWatch = movieItem.personalDateToWatch {
        ////                                        Text("\(personalDateToWatch.formatted(date: .numeric, time: .shortened))")
        ////                                    }
        ////                                    Label("Set date", systemImage: "bell")
        ////                                    //                        Image(systemName: movieItem.personalDateToWatch != nil ? "bell.slash" : "bell")
        ////                                }
        ////
        ////                            }
        ////                        }
        //
        //                        Button {
        //                            if (movieItem.personalDateToWatch != nil) {
        //                                movieItem.personalDateToWatch = nil
        //                            } else {
        ////                                notificationVM.movieItem = movieItem
        //                                movieItemToUpdate.movieItem = movieItem
        //                                //                        movieItemToUpdate = movieItem
        //                                showUpdateDialog = true
        //                            }
        //                        } label: {
        //                            HStack {
        //                                if let personalDateToWatch = movieItem.personalDateToWatch {
        //                                    Text("\(personalDateToWatch.formatted(date: .numeric, time: .shortened))")
        //                                }
        //                                Label(movieItem.personalDateToWatch != nil ? "cancel" : "set date", systemImage: movieItem.personalDateToWatch != nil ? "bell.slash" : "bell")
        //                                //                        Image(systemName: movieItem.personalDateToWatch != nil ? "bell.slash" : "bell")
        //                            }
        //
        //                        }
        //                    }
        //                    //                .overlay(alignment: .trailing) {
        //                    //                    DatePicker("", selection: Binding(get: {
        //                    //                        movieItem.personalDateToWatch ?? .now
        //                    //                    }, set: {
        //                    //                        movieItem.personalDateToWatch = $0
        //                    //                    }), displayedComponents: .date)
        //                    //                }
        //
        //                    Button {
        //                        movieItem.personalIsPlanedToWatch = false
        //                    } label: {
        //                        Label("cancel", systemImage: "xmark.circle")
        //                    }
        //
        //                    Button {
        //                        movieItem.personalDateOfViewing = Date.now
        //                    } label: {
        //                        Label("Watched", systemImage: "clock.badge.checkmark")
        //                    }
        //                }
        //
        //            }
        .padding()
    }
        
        
    }
}

#Preview {
    MovieCardWatchOptionsView(notificationVM: .init(), movieItem: .init(), movieItemToUpdate: .init(), showUpdateDialog: .constant(false))
}
