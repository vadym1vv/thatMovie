//
//  GeneralExtensions.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.11.2023.
//

import Foundation


//MARK: - Optional String
extension Optional where Wrapped == String {
    var stringValue: String {
        guard let self = self else { return ""}
        return self
    }
}
