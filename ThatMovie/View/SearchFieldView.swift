//
//  SearchField.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.11.2023.
//

import SwiftUI

struct SearchFieldView: View {
    @State var searchStr: String = ""
    @State var showAdditionalSearchCriteria: Bool = false
    @Binding var showSearchField: Bool
    
    @State var date: Date = .now
    
    var body: some View {
        
        VStack {
            HStack {
                TextField("Search", text: $searchStr, onCommit: {
                    print(searchStr)
                })
                    .padding(.leading, 10)
                    .padding(6)
                    .background {
                        RoundedRectangle(cornerRadius: 20)
                            .fill(Color(UIColor.systemGray6))
                    }
                    .overlay(alignment: .trailing) {
                        ZStack {
                            Button(action: /*@START_MENU_TOKEN@*/{}/*@END_MENU_TOKEN@*/, label: {
    //                            Image(systemName: "magnifyingglass")
    //                                .foregroundStyle(.black)
                                Image.resizableSystemImage(systemName: "magnifyingglass")
                                    .foregroundStyle(.black)
                                    .padding(7)
                            })
                        }
                    }
                Button(action: {
                    withAnimation {
                        self.showAdditionalSearchCriteria.toggle()
                    }
                }, label: {
                    Image.resizableSystemImage(systemName: "slider.horizontal.2.square.badge.arrow.down")
                        .rotationEffect(.degrees(self.showAdditionalSearchCriteria ? 180 : 0))
                        .foregroundStyle(.black)
                    
                        
                })
                Button(action: {
                    withAnimation {
                        self.showSearchField.toggle()
                    }
                }, label: {
                    Image.resizableSystemImage(systemName: "xmark.circle")
                        .foregroundStyle(.black)
                        
                })
            }
            .frame(width: .infinity, height: 30)
            if showAdditionalSearchCriteria {
                DatePicker("Select Date", selection: $date)
            }
            
        }
//        .foregroundColor(.black)
        
    }
}

#Preview {
    SearchFieldView(showSearchField: .constant(true))
}
