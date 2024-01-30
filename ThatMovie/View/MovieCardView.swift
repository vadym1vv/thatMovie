////
////  MovieCardView.swift
////  ThatMovie
////
////  Created by Vadym Vasylaki on 09.11.2023.
////
//
//import SwiftUI
//
//struct MovieCardView: View {
//    
////    @State var posterPath: Result
//    var posterPath: String
//    
//    var body: some View {
//        ZStack {
////            AsyncImage(url: URL(string: "https://hws.dev/img/cupcakes@3x.jpg")) { image in
//            AsyncImage(url: URL(string: "\(ApiUrls.baseImageUrl)\(posterPath)")) { image in
//                image
//                    .resizable()
//                    .scaledToFit()
//            } placeholder: {
//                ProgressView()
//            }
//            .clipShape(RoundedRectangle(cornerRadius: 10))
//            .padding(1)
////            VStack {
////                HStack {
////                    Spacer()
////                    HStack {
////                        Text("movie name")
////                            .padding([.leading, .trailing], 5)
////                            .background(Color(UIColor.systemGray6))
////                            .clipShape(.rect(cornerRadius: 10))
////                    }
////                    Spacer()
////                    Image(systemName: "star")
////                        .padding()
////                }
////                Spacer()
////                HStack {
////                            HStack {
////                                Image(systemName: "eye")
////                                Text("1886k")
////                            }
////                            .padding([.leading, .trailing], 5)
////                            .background(Color(UIColor.systemGray6))
////                            .clipShape(.rect(cornerRadius: 10))
////                       
////                    Text("Rating: 6.7")
////                        .padding([.leading, .trailing], 5)
////                        .background(Color(UIColor.systemGray6))
////                        .clipShape(.rect(cornerRadius: 10))
////                }
////                
////            }
//        }
//    }
//}
//
//#Preview {
//    MovieCardView(posterPath: "/pD6sL4vntUOXHmuvJPPZAgvyfd9.jpg")
//}
