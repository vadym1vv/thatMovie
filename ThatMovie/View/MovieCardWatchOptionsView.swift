//
//  ToWatchOptionsCardView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 19.12.2023.
//

import SwiftUI

struct MovieCardWatchOptionsView: View {
    @ObservedObject var movieItemToUpdate: MovieItemToUpdateInfo
    
    @State var movieItem: MovieItem
    @Binding var showUpdateDialog: Bool
    
    private let notificationVM: NotificationVM = NotificationVM()
    
    var movieCategory: MovieCategory
    
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
                                    movieItem.personalIsPlannedToWatch = true
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
                            Divider()
                            Text("Watched: \(personalDateOfViewing.formatted(date: .numeric, time: .omitted))")
                        }
                    }
                    
                    Divider()
                    Spacer()
                    HStack {
                        Spacer()
                        if (movieItem.personalDateToWatch != nil || movieItem.personalIsPlannedToWatch) {
                            Button {
                                movieItem.personalDateOfViewing = Date.now
                                movieItem.personalIsPlannedToWatch = false
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
                            movieCategory.deleteMovieByCurrentCategory(movieItem: movieItem)
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
            .background {
                RoundedRectangle(cornerRadius: 20)
                    .fill(Color("AdditionalBackground"))
            }
            .foregroundStyle(Color(UIColor.label))
            .padding(4)
        }
        .frame(height: 240)
        .background(RoundedRectangle(cornerRadius: 8).fill(Color("SecondaryBackground")))
    }
}

//#Preview {
//    MovieCardWatchOptionsView(notificationVM: .init(), movieItem: .init(), movieItemToUpdate: .init(), showUpdateDialog: .constant(false))
//}
