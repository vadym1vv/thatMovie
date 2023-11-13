//
//  ViewRouter.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 09.11.2023.
//

import SwiftUI

class ViewRouter: ObservableObject {
    
    @Published var currentPage: Page = .home
}


enum Page {
    case home
    case liked
    case records
    case user
}
