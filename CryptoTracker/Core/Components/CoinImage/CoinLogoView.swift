//
//  CoinLogoView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 09/09/24.
//

import SwiftUI

struct CoinLogoView: View {
    let coin: CoinModel
    var body: some View {
        VStack {
            CoinImageView(coin: coin)
                .frame(width: 50, height: 50)
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.accent)
                .lineLimit(1)
                .minimumScaleFactor(0.5)
            
            Text(coin.name)
                .foregroundStyle(Color.theme.secondaryText)
                .font(.caption)
                .lineLimit(2)
                .minimumScaleFactor(0.5)
                .multilineTextAlignment(.center)
        }
        .padding(6)
    }
}

#Preview {
    CoinLogoView(coin: DeveloperPreview.instance.coin)
}
