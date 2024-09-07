//
//  ContentView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 07/09/24.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        ZStack {
            Color.theme.background.ignoresSafeArea()
            VStack {
                Text("CRYPTO TRACKER")
                    .font(.headline)
                Text("Accent Color")
                    .foregroundStyle(Color.theme.accent)
                Text("Green Color")
                    .foregroundStyle(Color.theme.green)
                Text("Red Color")
                    .foregroundStyle(Color.theme.red)
                Text("Secondary text Color")
                    .foregroundStyle(Color.theme.secondaryText)
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
