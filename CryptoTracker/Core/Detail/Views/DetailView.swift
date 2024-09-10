//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 10/09/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    
    init(coin: CoinModel) {
        _vm = StateObject(wrappedValue: DetailViewModel(coin: coin))
    }
    
    private let spacing: CGFloat = 25
    private let columns: [GridItem] = [
        GridItem(.flexible()),
        GridItem(.flexible())
    ]
    
    var body: some View {
        ScrollView {
            VStack(spacing: 20) {
                Text("graph")
                    .frame(height: 150)
                
                overviewTitle
                Divider()
                overviewGrid
                
                additionalDetailsText
                Divider()
                additionalDetailsGrid
            }
            .padding()
            .navigationTitle(vm.coin.name)
        }
    }
}

#Preview {
    NavigationStack {
        DetailView(coin: DeveloperPreview.instance.coin)
            .navigationTitle(DeveloperPreview.instance.coin.name)
    }
}

extension DetailView {
    private var overviewTitle: some View {
        Text("Overview")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var overviewGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading, spacing: spacing,
            pinnedViews: [], content: {
                ForEach(vm.overviewStats) { stats in
                    StatisticView(stat: stats)
                }
        })
    }
    
    private var additionalDetailsText: some View {
        Text("Additional Details")
            .font(.title)
            .bold()
            .foregroundStyle(Color.theme.accent)
            .frame(maxWidth: .infinity, alignment: .leading)
    }
    
    private var additionalDetailsGrid: some View {
        LazyVGrid(
            columns: columns,
            alignment: .leading, spacing: spacing,
            pinnedViews: [], content: {
                ForEach(vm.additionalStats) { stats in
                    StatisticView(stat: stats)
                }
        })
    }
}
