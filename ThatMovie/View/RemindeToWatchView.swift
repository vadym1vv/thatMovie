//
//  RemindeToWatchView.swift
//  ThatMovie
//
//  Created by Vadym Vasylaki on 18.02.2024.
//

import SwiftUI
import SwiftData

struct RemindeToWatchView: View {
    
    @Query(filter: #Predicate<MovieItem> { movie in
        movie.personalDateToWatch != nil && !movie.personalIsPlannedToWatch
    }) var watchedMovies: [MovieItem]
    
    @AppStorage("allowAutoRewatchListNotifications") var allowAutoRewatchListNotifications: Bool = false
    @AppStorage("allowAutoRewatchListNotificationsWithSound") var allowAutoRewatchListNotificationsWithSound: Bool = false
    @Environment(\.dismiss) private var dismiss
    
    @State private var remindeToWatchAfter: Int = 1
    @State private var displayInfoSetingsWatchedListNotifications: Bool = false
    
    private let notivicationVM = NotificationVM()
    var body: some View {
        NavigationStack {
            List {
                VStack {
                    Button {
                        displayInfoSetingsWatchedListNotifications.toggle()
                    } label: {
                        HStack {
                            Text("Info")
                            Spacer()
                            Image(systemName: displayInfoSetingsWatchedListNotifications ? "chevron.up" : "chevron.down")
                        }
                    }
                    if(displayInfoSetingsWatchedListNotifications) {
                        Text("After the movie is marked as watched, you can choose to be notified after a certain period of time - just in case you want to rewatch it😉🤌.")
                            .padding(.top)
                    }
                }
                Section("Notification settings") {
                    Toggle("Allow rewatch notifications", isOn: $allowAutoRewatchListNotifications)
                    Toggle("Allow rewatch with sound", isOn: $allowAutoRewatchListNotificationsWithSound)
                        .disabled(!allowAutoRewatchListNotifications)
                    
                    HStack {
                        Picker(selection: $remindeToWatchAfter) {
                            ForEach(1...5, id: \.self) { year in
                                Text("\(year)")
                            }
                        } label: {
                            Text("Reminde to rewatch after:")
                        }
                        Text(remindeToWatchAfter == 1 ? "year" : "years")
                    }
                    
                }
                
                Section {
                    HStack {
                        Button {
                            self.dismiss()
                        } label: {
                            Text("Cancel")
                        }
                        .tint(Color("DeleteColor"))
                    }
                }
                .buttonStyle(.borderedProminent)
                .foregroundStyle(Color(UIColor.label))
            }
            .background(Color(.additionalBackground))
            .tint(Color(UIColor.label))
            .scrollContentBackground(.hidden)
        }
        .presentationDetents([.medium])
    }
}

#Preview {
    RemindeToWatchView()
}
