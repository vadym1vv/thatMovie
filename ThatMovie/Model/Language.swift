//
//  Languages.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 21.11.2023.
//

import Foundation

struct LanguageIdentifier {
    var iso_639_1: String
    var englishName: String
    var name: String
}

enum Language: String, Identifiable, CaseIterable {
    var id: Self {self}
    case  en, es, hi, de, fr, pl, ua
    
    var languageName: LanguageIdentifier {
       switch self {
       case .en:
           return LanguageIdentifier(iso_639_1: "en", englishName: "English", name: "English")
       case .es:
           return LanguageIdentifier(iso_639_1: "es", englishName: "Spanish", name: "Español")
       case .hi:
           return LanguageIdentifier(iso_639_1: "hi", englishName: "Hindi", name: "हिन्दी")
       case .de:
           return LanguageIdentifier(iso_639_1: "de", englishName: "German", name: "Deutsch")
       case .fr:
           return LanguageIdentifier(iso_639_1: "fr", englishName: "French", name: "Français")
       
       case .pl:
           return LanguageIdentifier(iso_639_1: "pl", englishName: "Polish", name: "Polski")
       case .ua:
           return LanguageIdentifier(iso_639_1: "ua", englishName: "Ukrainian", name: "Український")
       }
   }
    
    var urlLanguageRepresentation: String {
        switch self {
        case .en:
            return "language=en&"
        case .es:
            return "language=es&"
        case .hi:
            return "language=hi&"
        case .de:
            return "language=de&"
        case .fr:
            return "language=fr&"
        case .pl:
            return "language=pl&"
        case .ua:
            return "language=ua&"
        }
    }
    
}
