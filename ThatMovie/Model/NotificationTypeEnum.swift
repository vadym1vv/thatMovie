//
//  NotificationTypeEnum.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 28.12.2023.
//

import Foundation

enum NotificationTypeEnum {
    case dateToWatch, isPlanedToWatch, watched, non
    
    var imageRepresentation: String {
        switch self {
        case .dateToWatch:
            return "bell"
        case .isPlanedToWatch:
            return "bell.slash"
        case .watched:
            return "eye"
        case .non:
            return "ellipsis.circle"
        }
    }
}
