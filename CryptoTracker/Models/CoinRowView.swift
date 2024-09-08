//
//  CoinRowView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 07/09/24.
//

import SwiftUI

struct CoinRowView: View {
    let coin: CoinModel
    let showHoldingsColumn: Bool
    
    var body: some View {
        HStack(spacing: 0) {
            leftColumn
            
            Spacer()
            
            if showHoldingsColumn {
                holdingsColumn
                    .animation(.none, value: showHoldingsColumn)
            }
            
            priceColumn
        }
        .font(.subheadline)
    }
}

#Preview {
    CoinRowView(coin: PreviewProvider.dev.coin, showHoldingsColumn: true)
}

extension CoinRowView {
    private var leftColumn: some View {
        HStack(spacing: 0 ) {
            Text(String(coin.rank))
                .font(.headline)
                .frame(minWidth: 30)
                .foregroundStyle(Color.theme.secondaryText)
            
            //img
            CoinImageView(coin: coin)
                .frame(width: 30, height: 30)
            
//            AsyncImage(url: URL(string: coin.image), content: { image in
//                image
//                    .resizable()
//                    .frame(width: 30, height: 30)
//            }, placeholder: {
//                ProgressView()
//            })
            
            
                
            
            Text(coin.symbol.uppercased())
                .font(.headline)
                .padding(.leading, 6)
                .foregroundStyle(Color.theme.accent)
        }
    }
    
    private var holdingsColumn: some View {
        VStack(alignment: .trailing ) {
            Text(coin.currentHoldingsValue.asCurrencyWith2Decimals())
                .bold()
            Text((coin.currentHoldings ?? 0).asNumberString())
                .foregroundStyle(Color.theme.secondaryText)
        }
        .foregroundStyle(Color.theme.accent)
    }
    
    private var priceColumn: some View {
        VStack(alignment: .trailing) {
            Text(coin.currentPrice.asCurrencyWith6Decimals())
                .bold()
                .foregroundStyle(Color.theme.accent)
            
            Text(coin.priceChangePercentage24H?.asPercentString() ?? "0.00%")
                .foregroundStyle(
                    (coin.priceChangePercentage24H ?? 0) >= 0 ? Color.theme.green : Color.theme.red
                )
        }
        .frame(width: UIScreen.main.bounds.width / 3.5, alignment: .trailing)
    }
}
