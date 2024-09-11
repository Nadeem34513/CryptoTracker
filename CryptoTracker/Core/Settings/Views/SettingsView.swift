//
//  SettingsView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 11/09/24.
//

import SwiftUI

struct SettingsView: View {
    
    private let coingeckoURL = URL(string: "https://www.coingecko.com")!
    private let githubURL = URL(string: "https://github.com/Nadeem34513/CryptoTracker")!
    private let defaultURL = URL(string: "https://google.com")!
    
    var body: some View {
        NavigationStack {
            List {
                coingeckoSection
                developerSection
                applicationSection
            }
            .listStyle(.insetGrouped)
            .tint(Color.blue)
            .navigationTitle("About")
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    XMarkButton()
                }
            }
        }
    }
}

#Preview {
    SettingsView()
}

extension SettingsView {
    private var coingeckoSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("coingecko")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                
                Text("The cryptocurrency data that is used in this app comes from a free API from CoinGecko! Prices may be slightly delayed.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Vist CoinGecko", destination: coingeckoURL)
        } header: {
            Text("Coingecko")
        }
    }
    
    private var developerSection: some View {
        Section {
            VStack(alignment: .leading) {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 100, height: 100)
                    .clipShape(RoundedRectangle(cornerRadius: 20))
                    .padding(.bottom, 6)
                
                Text("This App is developer by Nadeem Noushad. It uses SwiftUI and is written in 100% Swift. The project benefits from multi-threading, publishers/subscribers and data persistance. This project is completely Open Sourced.")
                    .font(.callout)
                    .fontWeight(.medium)
                    .foregroundStyle(Color.theme.accent)
            }
            .padding(.vertical)
            
            Link("Source code", destination: githubURL)
        } header: {
            Text("Developer")
        }
    }
    
    private var applicationSection: some View {
        Section {
            Link("Terms of Service", destination: defaultURL)
            Link("Privacy Policy", destination: defaultURL)
            Link("Company Website", destination: defaultURL)
            Link("Learn More", destination: defaultURL)
        } header: {
            Text("Application")
        }
    }
}
