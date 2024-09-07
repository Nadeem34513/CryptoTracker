//
//  CryptoTrackerApp.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 07/09/24.
//

import SwiftUI

@main
struct CryptoTrackerApp: App {
    var body: some Scene {
        WindowGroup {
            NavigationStack {
                HomeView()
                    .toolbar(.hidden, for: .navigationBar)
            }
        }
    }
}
