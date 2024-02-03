//
//  MovieSectionItemView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 26.11.2023.
//

import SwiftUI

struct MovieSectionItemView: View {
    var movieItemName: String
    var isSelected: Bool
    var body: some View {
        Text(movieItemName)
            .foregroundStyle(.black)
            .padding([.leading, .trailing], 6)
            .padding([.top, .bottom], 1)
            .background(
                RoundedRectangle(cornerRadius:7)
                    .fill(Color( UIColor.systemGray5))
                    .opacity(isSelected ? 1 : 0)
            )
    }
}

#Preview {
    MovieSectionItemView(movieItemName: "random", isSelected: true)
}
