//
//  MovieFilmView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 24.10.2023.
//

import SwiftUI

struct MovieFilmView: View {
    var body: some View {
//        ScrollView(.vertical) {
////            RoundedRectangle(cornerRadius: 50)
////                .stroke(Color.blue, style: StrokeStyle(lineWidth: 20, lineCap: .round, dash: [20]))
////            Text("asf")
////                Divider()
////                .frame(width: 10, height: .infinity)
////                .overlay(.pink)
////                .overlay(
//                
//        
////            Line()
////                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round,  dash: [40]))
//            
////            CGRect()
////                .stroke(style: StrokeStyle(lineWidth: 20, lineCap: .round,  dash: [40]))
////                .ignoresSafeArea()
//            
//                        // Your other content
//                        
////                DashedLine()
////                    .ignoresSafeArea()
////                    .frame(height: .infinity)
//            
//            
//            VStack {
//                           ForEach(0..<30) { _ in
//                               DashedLine()
//                                   .frame(height: 200) // Adjust the height as needed
//                           }
//                       }
//            .ignoresSafeArea()
////                       .padding()
//                        
//                        // Your other content
//                    
//            
//            
//        }
//        .frame(height: .infinity)
        ScrollView(.vertical) {
                    VStack {
                        ForEach(0..<50) { _ in
                            
//                                DashedLine()
//                                .background(Color.red)
//                                    .frame(minHeight: 100, alignment: .center)
//                                    .frame(width: 25)
                            
                            
                                
                                
                            
                                
                        }
                    }
                }
        .ignoresSafeArea()

//        .frame(width: 12, height: .infinity)
    }
}

                    
//struct Line: Shape {
//    func path(in rect: CGRect) -> Path {
//        var path = Path()
//        path.move(to: CGPoint(x: 20, y: 11))
//        path.addLine(to: CGPoint(x: 20, y: rect.width))
//        return path
//    }
//}

//struct DashedLine: View {
//    var body: some View {
//        GeometryReader { geometry in
//            Path { path in
//                path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
//                path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
//            }
//            .stroke(style: StrokeStyle(lineWidth: 30, lineCap: .round, dash: [50]))
//            .foregroundColor(Color.black)
//        }
//    }
//}


struct DashedLine: View {
    var body: some View {
        GeometryReader { geometry in
            Path { path in
                path.move(to: CGPoint(x: geometry.size.width / 2, y: 0))
                path.addLine(to: CGPoint(x: geometry.size.width / 2, y: geometry.size.height))
            }
            .stroke(style: StrokeStyle(lineWidth: 14, lineCap: .round, dash: [25]))
            .foregroundColor(Color.black)
        }
    }
}
                    

#Preview {
    MovieFilmView()
}
