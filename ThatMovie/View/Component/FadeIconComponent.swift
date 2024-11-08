//
//  FadeIcon.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 01.11.2024.
//

import SwiftUI

struct FadeIconComponent: View {
    
    var iconName: String = "icons8-bookmark"
    var color: Color
    var opacity: CGFloat = 1
    var width: CGFloat = 75
    var height: CGFloat = 75
    var isSelected: Bool
    
    var calculatedHeight: CGFloat {
        if height > 75 {
            return height
        }
        return 75
    }
    
    var calculatedWidth: CGFloat {
        if width > 75 {
            return width
        }
        return 75
    }
    
    var body: some View {
        Image(iconName)
//            .renderingMode(.template)
            .resizable()
            .scaledToFit()
            .frame(width: calculatedWidth, height: calculatedHeight)
//            .foregroundStyle(color)
            .opacity(opacity)
    }
}

#Preview {
    FadeIconComponent(iconName: "icons8-bookmark", color: Color(UIColor.systemYellow), opacity: 0.2, isSelected: true)
}
