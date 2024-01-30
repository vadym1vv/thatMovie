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
//            AsyncImage(url: URL(string: "\(ApiUrls.baseImageUrl)\(posterPath!)")) { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//            } placeholder: {
//                ProgressView()
//            }
//            AsyncImage(url: URL(string: "\(ApiUrls.baseImageUrl)\(posterPath!)")!, placeholder: {
//                ProgressView()
//            }, image: { image in
//                Image(uiImage: image)
//                    .resizable()
////                    .scaledToFit()
//            }).aspectRatio(contentMode: .fit)
            CachedImage(url: "\(ApiUrls.baseImageUrl)\(posterPath!)") { phase in
                switch phase {
                case .empty:
                    ProgressView()
                case .success(let image):
                    image
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                case .failure(let error):
                    let _ = print(error)
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
