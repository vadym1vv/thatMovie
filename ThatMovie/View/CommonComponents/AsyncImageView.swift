//
//  AsyncImageView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 02.01.2024.
//

import SwiftUI

struct AsyncImageView: View {
    var posterPath: String?
    var body: some View {
        if ((posterPath) != nil && !posterPath!.isEmpty) {
            CachedImage(url: "\(StaticEndpoints.baseImageUrl)\(posterPath!)") { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure:
                    ProgressView()
                @unknown default:
                    ProgressView()
                }
            }
            .clipShape(RoundedRectangle(cornerRadius: 10))
        } else {
            Image("noImage")
                .resizable()
                .scaledToFit()
                .clipShape(RoundedRectangle(cornerRadius: 10))
        }
    }
}

#Preview {
    AsyncImageView()
}
