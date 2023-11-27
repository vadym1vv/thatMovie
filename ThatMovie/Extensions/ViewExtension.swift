//
//  ViewExtension.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.11.2023.
//

import SwiftUI

extension Image {
    static func resizableSystemImage(systemName: String) -> some View {
        return Image(systemName: systemName)
            .resizable()
            .scaledToFit()
    }
}
