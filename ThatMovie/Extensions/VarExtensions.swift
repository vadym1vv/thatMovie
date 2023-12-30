//
//  GeneralExtensions.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 14.11.2023.
//

import Foundation


//MARK: - Optional String
extension Optional where Wrapped == String {
    var unwrap: String {
        guard let self = self else { return ""}
        return self
    }
}

extension String {
    var formatToDate: Date? {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeZone = TimeZone.current
        dateFormatter.locale = Locale.current
        return dateFormatter.date(from: self)
    }
}

