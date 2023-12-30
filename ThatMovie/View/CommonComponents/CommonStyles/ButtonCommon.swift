//
//  ButtonBorderedScaled.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 09.12.2023.
//

import SwiftUI

struct ButtonBorderedScaled: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .padding()
            .background(.black)
            .foregroundStyle(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .scaleEffect(configuration.isPressed ? 1.2 : 1)
            .animation(.easeOut(duration: 0.2), value: configuration.isPressed)
    }
}
