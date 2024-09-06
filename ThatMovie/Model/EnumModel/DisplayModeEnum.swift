//
//  DisplayView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 04.01.2024.
//

import Foundation
import SwiftUI

enum DisplayModeEnum: String {
    
    case single, singleSwappable, double, triple, singleWithOptionsSquare
    
    var displayModeIcon: String {
        switch self {
        case .single:
            return "circlebadge.fill"
        case .singleSwappable:
            return "hand.draw.fill"
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
        case .single, .singleWithOptionsSquare, .singleSwappable:
            return 1
        case .double:
            return 2
        case .triple:
            return 3
        }
    }
    
    var scrollSpacing: CGFloat {
            switch self {
            case .singleSwappable:
                return 0
            default:
                return 10
            }
        }
    
    static func currentDisplayModByString(str: String) -> DisplayModeEnum {
        switch(str) {
        case "single":
            return .single
        case "singleSwappable":
            return .singleSwappable
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

    @ViewBuilder
    func movieCardView(movie: MovieItem, showUpdateDialog: Binding<Bool>, movieItemToUpdate: MovieItemToUpdateInfo, notificationVM: NotificationVM, movieCategory: MovieCategory) -> some View{
        switch self {
        case .single, .singleSwappable, .double, .triple:
             AsyncImageView(posterPath: movie.posterPath)
        case .singleWithOptionsSquare:
            MovieCardWatchOptionsView(movieItemToUpdate: movieItemToUpdate, movieItem: movie, showUpdateDialog: showUpdateDialog, movieCategory: movieCategory)
        }
    }
    
}
