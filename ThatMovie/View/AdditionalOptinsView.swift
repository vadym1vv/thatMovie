//
//  AdditionalOptinsView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 21.11.2023.
//

import SwiftUI

struct AdditionalOptinsView<T: View> : View {
    
    var someView: T
    
    init(@ViewBuilder someView: () -> T) {
        self.someView = someView()
    }
    
    var body: some View {
        someView
    }
}

#Preview {
    
    AdditionalOptinsView {}
}
