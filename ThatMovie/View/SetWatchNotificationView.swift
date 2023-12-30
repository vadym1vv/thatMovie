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
    @ObservedObject var notificationVM: NotificationVM
    @Environment(\.dismiss) var dismiss
    @Environment(\.modelContext) var modelContext
    
//    var dbMovieItem: MovieItem?

    @State private var customNotificationTitle: String?
    @State private var isSilentNotification: Bool = false
    @State private var dateToWatch: Date?
    
    
//    var dbIsSilentNotification: Bool?
    var id: Int?
    var genres: [Int]?
    var title: String?
    var posterPath: String?
    var releaseDate: Date?

    var movieDataVM: MovieDataVM = MovieDataVM()
    
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
                        Toggle("Silent notificaiton", systemImage: isSilentNotification ? "bell.slash" : "bell", isOn: $isSilentNotification)
                        
                        VStack {
                            HStack {
                                    Button("this evening") {
                                        
                                    }
                                    .buttonStyle(.borderedProminent)
                                    
                                    Button("Tomorrow") {
                                        
                                    }
                                    .buttonStyle(.borderedProminent)
                                    
                                    Button("next month") {
                                        
                                    }
                                    .buttonStyle(.borderedProminent)
                                    
                                }
                            Text("Or")
//                            DatePicker("", selection: $dateToWatch, in: Date()...)
                            DatePicker("", selection: Binding(get: {
                                dateToWatch ?? currentDbMovie?.personalDateToWatch ?? .now
                            }, set: {
                                self.dateToWatch = $0
                            }), in: Date()...)
                            }
                        }
                HStack {
                    
                    Button {
//                        self.currentDbMovie?.personalDateToWatch = self.dateToWatch
                        if let dateToWatch = dateToWatch {
                            if let newMovieItem = self.movieDataVM.setDateToWatch(movieDb: currentDbMovie, newDateToWatch: dateToWatch, id: id, genres: genres, title: title, posterPath: posterPath, releaseDate: releaseDate) {
                                self.modelContext.insert(newMovieItem)
                            }
                            
                        }
                        notificationVM.sendNotification(date: self.dateToWatch!, type: "date", title: "Movie time", body: self.title ?? currentDbMovie?.title ?? "U set movie reminder for tuday🍿")
                        self.dismiss()
                    } label: {
                        Text("Save")
                            .frame(maxWidth: .infinity)
                    }
                    .buttonStyle(.borderedProminent)
                    .foregroundStyle(.black)
                    .disabled(self.dateToWatch == nil)
                    
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
        }
        .presentationDetents([.medium])
    }
}
//
//#Preview {
//    SetWatchNotificationView(notificationVM: .init(), dbDateToWatch: .now, dbMovieItem: .constant(.))
//}
