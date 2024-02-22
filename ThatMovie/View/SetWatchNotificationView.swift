//
//  SetWatchNotificationView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 28.12.2023.
//

import SwiftUI
import SwiftData

struct SetWatchNotificationView: View {
    //    @Binding var showUpdateDialog: Bool
    @Query private var allMovies: [MovieItem]
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
    @State private var customNotificationTitle: String?
    @State private var allowNotificationWithSound: Bool = false
    @State private var dateToWatch: Date?
    
    private let notificationVM: NotificationVM = NotificationVM()
    private let movieDataVM: MovieDataVM = MovieDataVM()
    
    var id: Int?
    var genres: [Int]?
    var title: String?
    var posterPath: String?
    var releaseDate: Date?
    
    var currentDbMovie: MovieItem? {
        allMovies.first(where: {$0.id == id})
    }
    var body: some View {
        NavigationStack {
            List {
                Section("Notification description") {
                    TextField(title ?? "Set description", text: Binding(get: {
                        self.customNotificationTitle ?? currentDbMovie?.title ?? ""
                    }, set: {
                        self.customNotificationTitle = $0
                    }))
                }
                
                Section("Notificaiton properties") {
                    Toggle(allowNotificationWithSound ? "Notification with sound" : "Silent notificaiton", systemImage: allowNotificationWithSound ? "bell" : "bell.slash", isOn: $allowNotificationWithSound)
                        .tint(Color(UIColor.label))
                    
                    VStack {
//                        HStack {
//                            Button {
//                                
//                            } label: {
//                                Text("this evening")
//                                    .foregroundStyle(Color(.lightGray))
//                            }
//                            .buttonStyle(.borderedProminent)
//                            .tint(.primaryBackground)
//                            
//                            Button {
//                                
//                            } label: {
//                                Text("Tomorrow")
//                                    .foregroundStyle(Color(.lightGray))
//                            }
//                            .buttonStyle(.borderedProminent)
//                            .tint(.primaryBackground)
//                            
//                            Button {
//                                
//                            } label: {
//                                Text("next month")
//                                    .foregroundStyle(Color(.lightGray))
//                            }
//                            .buttonStyle(.borderedProminent)
//                            .tint(.primaryBackground)
//                            
//                        }
//                        Text("Or")
                        //                            DatePicker("", selection: $dateToWatch, in: Date()...)
                        
                       
                            DatePicker("", selection: Binding(get: {
                                dateToWatch ?? currentDbMovie?.personalDateToWatch ?? .now
                            }, set: {
                                self.dateToWatch = $0
                            }), in: Date()...)
                            .tint(Color(UIColor.label))
//                            .frame(maxWidth: .init())
                        
                        
                    }
                }
                
                HStack {
                    
                    Button {
                       
                            if let dateToWatch = dateToWatch {
                                if let newMovieItem = self.movieDataVM.setDateToWatch(movieDb: currentDbMovie, newDateToWatch: dateToWatch, id: id, genres: genres, title: title, posterPath: posterPath, releaseDate: releaseDate) {
                                    self.modelContext.insert(newMovieItem)
                                }
                                notificationVM.sendNotification(identifier: String(id!) , date: self.dateToWatch!, type: "date", title: "Movie time", body: self.title ?? currentDbMovie?.title ?? "U set movie reminder for tuday🍿", allowSound: allowNotificationWithSound)
                            }
                            
                            
                        
                        self.dismiss()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.secondaryBackground)
                    .disabled(dateToWatch == nil)
                    
                    Button(role: .destructive) {
                        //                        self.customNotificationTitle = nil
                        //                        self.isSilentNotification = false
                        self.dismiss()
                    } label: {
                        Text("Cancel")
                    }
                    .buttonStyle(.borderedProminent)
                }
            }
            .background(Color(.additionalBackground))
            .foregroundStyle(Color(UIColor.label))
            .scrollContentBackground(.hidden)
        }
        .presentationDetents([.medium])
        
    }
}


//#Preview {
//    SetWatchNotificationView(allMovies: <#T##[MovieItem]#>, dismiss: <#T##arg#>, modelContext: <#T##arg#>, notificationVM: <#T##NotificationVM#>)
//}
