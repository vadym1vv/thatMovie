//
//  UrlPage.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 02.12.2023.
//

import Foundation

struct UrlPage {
    var page: Int
    
    var getUrlPage: String {
        return "page=\(page)"
    }
}
