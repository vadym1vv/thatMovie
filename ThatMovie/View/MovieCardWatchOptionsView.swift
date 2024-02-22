//
//  ToWatchOptionsCardView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 19.12.2023.
//

import SwiftUI

struct MovieCardWatchOptionsView: View {
    
    @State var movieItem: MovieItem
    @ObservedObject var movieItemToUpdate: MovieItemToUpdateInfo
    @Binding var showUpdateDialog: Bool
    
    private let notificationVM: NotificationVM = NotificationVM()
    
    var body: some View {
        
        HStack {
            AsyncImageView(posterPath: movieItem.posterPath)
                .frame(width: 150)
                .padding(.leading, 7)
                .padding([.top, .bottom], 10)
            
            VStack(alignment: .center) {
                Group {
                    Spacer()
                    Text(movieItem.title.unwrap)
                        .font(.title3)
                    Divider()
                    VStack(alignment: .center) {
                        
                        if(movieItem.personalDateToWatch != nil) {
                            Text("Scheduled for")
                            HStack{
                                Text("\(movieItem.personalDateToWatch!.formatted(date: .numeric, time: .shortened))")
                                Button(role: .destructive) {
                                    movieItem.personalIsPlanedToWatch = true
                                    movieItem.personalDateToWatch = nil
                                    if let id = movieItem.id {
                                        notificationVM.removePendingNotification(identifier: String(id))
                                    }
                                    
                                } label: {
                                    Image(systemName: "xmark")
                                        .foregroundStyle(Color("DeleteColor"))
                                        .padding(7)
                                        .overlay(Circle().stroke()
                                            .foregroundStyle(Color("PrimaryBackground")))
                                }
                            }
                        } else {
                            HStack {
                                Text("Schedule:")
                                Button {
                                    self.movieItemToUpdate.movieItem = movieItem
                                    self.showUpdateDialog.toggle()
                                } label: {
                                    Label("Set date", systemImage: "bell")
                                        .padding(3)
                                        .overlay(RoundedRectangle(cornerRadius: 4).stroke()
                                            .foregroundStyle(Color("PrimaryBackground")))
                                }
                            }
                        }
                        if let personalDateOfViewing = movieItem.personalDateOfViewing {
                            Text("\(personalDateOfViewing.formatted(date: .numeric, time: .shortened))")
                        }
 
                    }
                    
                    Divider()
                    Spacer()
                    HStack {
                        Spacer()
                        if (movieItem.personalDateToWatch != nil || movieItem.personalIsPlanedToWatch) {
                            Button {
                                movieItem.personalDateOfViewing = Date.now
                                movieItem.personalIsPlanedToWatch = false
                                movieItem.personalDateToWatch = nil
                                if let id = movieItem.id {
                                    notificationVM.removePendingNotification(identifier: String(id))
                                }
                            } label: {
                                Label("Watched", systemImage: "clock.badge.checkmark")
                                    .padding(3)
                                    .overlay(RoundedRectangle(cornerRadius: 4).stroke()
                                        .foregroundStyle(Color("PrimaryBackground")))
                            }
                            Spacer()
                        }
                        
                        
                        
                        Button {
                            movieItem.personalIsFavourite.toggle()
                        } label: {
                            Image(systemName: movieItem.personalIsFavourite ? "star.fill" : "star")
                                .foregroundStyle(Color("FavouriteColor"))
                                .padding(7)
                                .overlay(Circle().stroke()
                                    .foregroundStyle(Color("PrimaryBackground")))
                            
                        }
                        
                        
                        Spacer()
                        
                        Button(role: .destructive) {
                            movieItem.personalIsPlanedToWatch = false
                            movieItem.personalDateToWatch = nil
                            movieItem.personalDateOfViewing = nil
                            if let id = movieItem.id {
                                notificationVM.removePendingNotification(identifier: String(id))
                            }
                        } label: {
                            Image(systemName: "trash")
                                .foregroundStyle(Color("DeleteColor"))
                                .padding(7)
                                .overlay(Circle().stroke()
                                    .foregroundStyle(Color("PrimaryBackground")))
                        }
                        
                        Spacer()
                    }
                    .padding(.bottom, 5)
                }
                .padding(.leading, 3)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            //        .padding()
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("AdditionalBackground"))
                //                .fill(.red)
                
            }
            .foregroundStyle(Color(UIColor.label))
            
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
            .padding(4)
        }
        .frame(height: 240)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color("SecondaryBackground")))
    }
}

//#Preview {
//    MovieCardWatchOptionsView(notificationVM: .init(), movieItem: .init(), movieItemToUpdate: .init(), showUpdateDialog: .constant(false))
//}
