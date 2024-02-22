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
            .foregroundStyle(Color(UIColor.label))
            .padding([.leading, .trailing], 6)
            .padding([.top, .bottom], 1)
            .background(
                UnevenRoundedRectangle(cornerRadii: .init(topLeading: 7, bottomLeading: isSelected ? 0 : 7, bottomTrailing: isSelected ? 0 : 7, topTrailing: 7), style: .continuous)
//                    .fill(Color("AdditionalBackground"))
                    .foregroundStyle(Color( isSelected ?  "AdditionalBackground" : "SecondaryBackground") )
                    .opacity(isSelected ? 1 : 0.3)
            ).overlay(alignment: .bottom) {
                if(isSelected) {
                    Divider()
                }
            }
    }
}

#Preview {
    MovieSectionItemView(movieItemName: "random", isSelected: false)
}
