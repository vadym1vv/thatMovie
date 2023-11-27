//
//  LanguageSelectorView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 21.11.2023.
//

import SwiftUI

struct LanguageSelectorView: View {
    
    @AppStorage("selectedLanguage") var selectedLanguage: Language = .en
    
    var body: some View {
        List {
            ForEach(Language.allCases) { language in
                Button(action: {
                    selectedLanguage = language
                }, label: {
                    Text(language.languageName.name)
                        .frame(alignment: .trailing)
                        .frame(width: .infinity, alignment: .center)
                })
            }
        }
    }
}

#Preview {
    LanguageSelectorView()
}
