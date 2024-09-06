//
//  SwappableCardComponentView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 20.08.2024.
//

import SwiftUI

struct SwappableCardComponentView: View {
    
    @ObservedObject  var restApiMovieVm: RestApiMovieVM
    @State var offset: CGSize = .zero
    
    var body: some View {
        
        
        
        if let movieRest = restApiMovieVm.movieRest {
            //                VStack (spacing: 20){
            ForEach(movieRest.results) { movie in
//                NavigationLink(value: movie) {
                    AsyncImageView(posterPath: movie.posterPath)
                        .offset(offset)
                        .scaleEffect(getScaleAmount())
                        .rotationEffect(Angle(degrees: getRotationAmount()))
                        .gesture(
                            DragGesture()
                                .onChanged { value in
                                    withAnimation(.spring()) {
                                        offset = value.translation
                                    }
                                }
                                .onEnded { value in
                                    withAnimation(.spring()) {
                                        offset = .zero
                                    }
                                }
                        )
                        .onAppear {
                            if (movie.id == movieRest.results.last!.id && restApiMovieVm.currentNetworkCallState == .finished) {
                                if (restApiMovieVm.currentMovieGenreEndpoint != nil) {
                                    Task {
                                        await restApiMovieVm.loadNextMovieBySingleGenre()
                                    }
                                } else {
                                    Task {
                                        await restApiMovieVm.loadNextMovieByCurrentMovieCategoryEndpoint()
                                    }
                                }
                                
                            }
                        }
                                                    .frame(height: UIScreen.main.bounds.height - 50)
                        
                    //                                .frame(width: 200, height: 200)
                                                    
//                }
                .containerRelativeFrame(.vertical, alignment: .center)
                
            }
            //                }
        }
    }
    
    func getScaleAmount() -> CGFloat {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = abs(offset.width)
        let percentage = currentAmount / max
        return 1.0 - min(percentage, 0.5) * 0.5
    }
    
    func getRotationAmount() -> Double {
        let max = UIScreen.main.bounds.width / 2
        let currentAmount = offset.width
        let percentage = currentAmount / max
        let percentageAsDouble = Double(percentage)
        let maxAngle: Double = 10
        return percentageAsDouble * maxAngle
    }
}

#Preview {
    SwappableCardComponentView(restApiMovieVm: .init())
}
