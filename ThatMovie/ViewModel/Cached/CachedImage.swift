//
//  CachedImage.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 09.01.2024.
//

import SwiftUI

struct CachedImage< Content: View>: View {
    
    @StateObject private var manager = CachedImageManager()
    let content: (AsyncImagePhase) -> Content
    let url: String
    let animation: Animation?
    let transition: AnyTransition
    
    init( url: String, animation: Animation? = nil, transition: AnyTransition = .identity, @ViewBuilder content: @escaping (AsyncImagePhase) -> Content) {
        self.content = content
        self.url = url
        self.animation = animation
        self.transition = transition
    }
    
    var body: some View {
        ZStack {
            switch manager.currentState {
            case .loading:
                content(.empty)
                    .transition(transition)
            case .failed(let error):
                content(.failure(error))
            case .success(let data):
                if let image = UIImage(data: data) {
                    content(.success(Image(uiImage: image)))
                        .transition(transition)
                } else {
                    content(.failure(CachedImageError.invalidData))
                                .transition(transition)
                }
            default:
                content(.empty)
                    .transition(transition)
            }
        }
        .animation(animation, value: manager.currentState)
        .task {
            await manager.load(url)
        }
    }
}

extension CachedImage {
    enum CachedImageError: Error {
        case invalidData
    }
}



//#Preview {
//    CachedImage(content: "") {_ in
//        EmptyView()
//    }
//}
