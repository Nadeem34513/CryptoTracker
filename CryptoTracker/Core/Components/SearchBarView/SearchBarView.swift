//
//  SearchBarView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 08/09/24.
//

import SwiftUI

struct SearchBarView: View {
    @Binding var text: String
    var body: some View {
        HStack {
            Image(systemName: "magnifyingglass")
                .foregroundStyle(!text.isEmpty ? Color.theme.accent : Color.theme.secondaryText)
            TextField("Search by name or symbol...", text: $text)
                .autocorrectionDisabled(true)
                .keyboardType(.asciiCapable)
                .foregroundStyle(Color.theme.accent)
                .overlay(alignment: .trailing) {
                    if !text.isEmpty {
                        Image(systemName: "xmark.circle.fill")
                            .padding(4)
                            .offset(x: 4)
                            .foregroundStyle(Color.theme.accent)
                            .onTapGesture {
                                text = ""
                                
                            }
                    }
                        
                }
        }
        .font(.headline)
        .padding()
        .background(
            RoundedRectangle(cornerRadius: 20)
                .fill(Color.theme.background)
                .shadow(color: Color.theme.accent.opacity(0.2), radius: 10, x: 0.0, y: 0.0)
        )
        .padding()
        
    }
}

#Preview {
    SearchBarView(text: .constant(""))
}
