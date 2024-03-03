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

extension Int {
    var roundedWithAbbreviations: String {
        let number = Double(self)
        let thousand = number / 1000
        let million = number / 1000000
        if million >= 1.0 {
            return "\(round(million*10)/10)M"
        }
        else if thousand >= 1.0 {
            return "\(round(thousand*10)/10)k"
        }
        else {
            return "\(self)"
        }
    }
}
