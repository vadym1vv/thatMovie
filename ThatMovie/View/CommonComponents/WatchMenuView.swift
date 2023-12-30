//
//  WatchMenuView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 28.12.2023.
//

import SwiftUI
import SwiftData

struct WatchMenuView: View {
    
    @Query var allMovies: [MovieItem]
    @Environment(\.modelContext) var modelContext
    var movieDataVM: MovieDataVM = MovieDataVM()
    
    
    @Binding var shwoWatchNotificationProperties: Bool
    
    
    //    var isPlanedToWatch: Bool?
    var dateToWatch: Date?
    //    var currentApiMovieDetails: Details?
    
    var id: Int?
    var genres: [Int]?
    var title: String?
    var posterPath: String?
    var releaseDate: Date?
    
    private var currentMovieFromDb: MovieItem? {
        allMovies.first(where: {$0.id == id})
    }
    
    private var currentMenuSystemImage: String {
        if(currentMovieFromDb?.personalIsPlanedToWatch ?? false) {
            return NotificationTypeEnum.isPlanedToWatch.imageRepresentation
        } else if(currentMovieFromDb?.personalDateToWatch != nil) {
            return NotificationTypeEnum.dateToWatch.imageRepresentation
        } else if (currentMovieFromDb?.personalDateOfViewing != nil) {
            return NotificationTypeEnum.watched.imageRepresentation
        } else {
            return NotificationTypeEnum.non.imageRepresentation
        }
    }
    
    var body: some View {
        Menu {
            Button {
                if let newMovieItem = movieDataVM.setPlanedToWatch(movieDb: currentMovieFromDb, id: id, genres: genres, title: title, posterPath: posterPath, releaseDate: releaseDate) {
                    self.modelContext.insert(newMovieItem)
                }
            } label: {
                HStack {
                    Label("Watch list", systemImage: "bell.slash")
                }
            }
            
            Button {
                self.shwoWatchNotificationProperties.toggle()
            } label: {
                Label("Watch list with notification", systemImage: "bell")
            }
            
            if let currentMovieFromDb = currentMovieFromDb {
                if (currentMovieFromDb.personalIsPlanedToWatch || currentMovieFromDb.personalDateToWatch != nil) {
                    Button(role: .destructive) {
                        currentMovieFromDb.personalDateToWatch = nil
                        currentMovieFromDb.personalIsPlanedToWatch = false
                    } label: {
                        Label("Cancel", systemImage: "trash")
                    }
                }
            }
        } label: {
            Image(systemName: currentMenuSystemImage)
        }
    }
}

//#Preview {
//    WatchMenuView(shwoWatchNotificationProperties: .constant(true), notificationType: .constant(.dateToWatch))
//}
