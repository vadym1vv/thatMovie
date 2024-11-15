//
//  RadialMenuIcon.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 07.02.2024.
//

import SwiftUI

struct RadialMenuIcon: View {
    
    @Binding var radialMenuIsHidden: Bool
    
    var buttonImage: String = "arrow.up.left.circle"
    
    var body: some View {
        
        Image(systemName: buttonImage)
            .resizable()
            .scaledToFit()
            .rotationEffect(.degrees(self.radialMenuIsHidden ? 0 : 180))
            .frame(width: 50, height: 50)
            .zIndex(1)
        Circle()
            .fill(Color("SecondaryBackground"))
            .opacity(0.4)
        Circle()
            .fill(Color("SecondaryBackground")
                .opacity(0.8))
            .frame(width: self.radialMenuIsHidden ?  0 : 420,
                   height: self.radialMenuIsHidden ? 0 : 420)
    }
}

#Preview {
    RadialMenuIcon(radialMenuIsHidden: .constant(false))
}
