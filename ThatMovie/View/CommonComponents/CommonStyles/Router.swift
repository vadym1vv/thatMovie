//
//  Router.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 13.12.2023.
//

//import SwiftUI
import Foundation
import SwiftUI

class Router: ObservableObject {
    @Published var path = NavigationPath()
    static let shared = Router()
    func reset() {
        path = NavigationPath()
    }
}
