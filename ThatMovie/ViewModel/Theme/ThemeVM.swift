//
//  ThemeVM.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 08.02.2024.
//

import Foundation

class ThemeVM {
    static var shared = ThemeVM()
    
    func setDarkMode(enable: Bool) {
        let defaults = UserDefaults.standard
        defaults.setValue(enable, forKey: ThemeConstants.DARK_MODE)
    }
    
    func getDarkMode() -> Bool {
        let defaults = UserDefaults.standard
        return defaults.bool(forKey: ThemeConstants.DARK_MODE)
    }
}
