//
//  DeveloperAppInfoPopup.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 20.02.2024.
//

import SwiftUI

struct DeveloperAppInfoPopup: View {
    var body: some View {
        NavigationStack {
            List {
                Section("About API provider") {
                    VStack {
                        Text("All data used in this app are provided to the user free of charge by TMDB. You can find more details by clicking on:")
                        Link("TheMovieDb website", destination: URL(string: "https://themoviedb.org")!)
                            .fontWeight(.heavy)
                            .padding(3)
                    }
                }
                Section("About me(developer😅)") {
                    Text("Hi. I'm the creator))). If U found some annoying bug OR you have some ideas how to improve your experience while using this app(maybe some new features) - write me a ✉️: vasylaki@icloud.com")
                }
            }
            .background(Color(.additionalBackground))
        }
        .presentationDetents([.medium])
        .scrollContentBackground(.hidden)
    }
}

#Preview {
    DeveloperAppInfoPopup()
}
