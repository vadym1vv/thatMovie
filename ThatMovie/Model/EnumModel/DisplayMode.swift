//
//  DisplayView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.01.2024.
//

import Foundation
import SwiftUI

enum DisplayMode: String {
    
    case single, double, triple, singleWithOptionsSquare
    
    var displayModeIcon: String {
        switch self {
        case .single:
            return "circlebadge.fill"
        case .double:
            return "circle.grid.2x1.fill"
        case .triple:
            return "circle.grid.3x3.fill"
        case .singleWithOptionsSquare:
            return "square.fill.text.grid.1x2"
        }
    }
    
    var cardGridColumns: Int {
        switch self {
        case .single, .singleWithOptionsSquare:
            return 1
        case .double:
            return 2
        case .triple:
            return 3
        }
    }
    
    static func currentDisplayModyByString(str: String) -> DisplayMode {
        switch(str) {
        case "single":
            return .single
        case "double":
            return .double
        case "triple":
            return .triple
        case "singleWithOptionsSquare":
            return .singleWithOptionsSquare
        default:
            return .triple
        }
    }
    
    
//    func movieCardView(movie: MovieItem) -> some View{
//        switch self {
//        case .single, .double, .triple:
//            return AnyView(MovieCardView(posterPath: movie.posterPath ?? ""))
//        case .doubleWithOptionsSquare:
//            return AnyView(ToWatchOptionsCardView(movieItem: movie))
//        }
//    }
    
    @ViewBuilder
    func movieCardView(movie: MovieItem, showUpdateDialog: Binding<Bool>, movieItemToUpdate: MovieItemToUpdateInfo, notificationVM: NotificationVM) -> some View{
        switch self {
        case .single, .double, .triple:
             AsyncImageView(posterPath: movie.posterPath)
        case .singleWithOptionsSquare:
            MovieCardWatchOptionsView(movieItem: movie, movieItemToUpdate: movieItemToUpdate, showUpdateDialog: showUpdateDialog)
        }
    }
    
}
