//
//  MovieCardView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 24.10.2023.
//

import SwiftUI

struct MovieCardView: View {
    var body: some View {
        VStack {
            VStack(spacing: 0) {
                Rectangle()
                    .frame(width: .infinity, height: 20)
                HStack {
                    ExtractedView()
                    Spacer()
                    Text("asfasf")
                    Spacer()
                    ExtractedView()
                }
                Rectangle()
                    .frame(width: .infinity, height: 20)
                    .padding(0)
            }
        }
    }
}

  

#Preview {
    MovieCardView()
}

struct ExtractedView: View {
    var body: some View {
        VStack {
            Group {
                ForEach(0..<10) { _ in
                    RoundedRectangle(cornerRadius: 10)
                        .frame(width: 25, height: 25)
                        .padding(6)
                        .foregroundStyle(Color.white)
                        .background(Color.black)
                }
            }
        }
        .background(.black)
    }
}
