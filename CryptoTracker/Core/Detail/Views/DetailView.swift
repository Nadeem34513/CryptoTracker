//
//  DetailView.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 10/09/24.
//

import SwiftUI

struct DetailView: View {
    @StateObject var vm: DetailViewModel
    @State private var showReadMore: Bool = false
    
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
            
            VStack {
                ChartView(coin: vm.coin)
                    .padding(.vertical)
                
                VStack(spacing: 20) {
                    overviewTitle
                    Divider()
                    descriptionSection
                    overviewGrid
                    
                    additionalDetailsText
                    Divider()
                    additionalDetailsGrid
                    
                    websiteSection
                }
                .padding()
                .navigationTitle(vm.coin.name)
                .toolbar {
                    ToolbarItem(placement: .topBarTrailing) {
                        navigationBarTrailingItems
                    }
                }
            }
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
    
    private var descriptionSection: some View {
        ZStack {
            if let coinDescription = vm.coinDescription, !coinDescription.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    Text(coinDescription)
                        .lineLimit(showReadMore ? .max : 4)
                        .font(.callout)
                        .foregroundStyle(Color.theme.secondaryText)
                        .animation(showReadMore ? Animation.easeInOut : .none, value: showReadMore)
                    Button(action: {
                        showReadMore.toggle()
                    }, label: {
                        Text(!showReadMore ? "Read more" : "Less")
                            .font(.caption)
                            .fontWeight(.bold)
                            .tint(Color.blue)
                    })
                }
                .onTapGesture {
                    showReadMore = true
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
        }
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
    
    private var navigationBarTrailingItems: some View {
        HStack {
            Text(vm.coin.symbol.uppercased())
                .font(.headline)
                .foregroundStyle(Color.theme.secondaryText)
            CoinImageView(coin: vm.coin)
                .frame(width: 25, height: 25)
        }
    }
    
    private var websiteSection: some View {
        VStack(alignment: .leading, spacing: 20) {
            if let websiteURL = vm.websiteURL, let url = URL(string: websiteURL) {
                Link("Website", destination: url)
            }
            
            if let redditURL = vm.redditURL, let url = URL(string: redditURL) {
                Link("Reddit", destination: url)
            }
        }
        .tint(Color.blue)
        .frame(maxWidth: .infinity, alignment: .leading)
        .font(.headline)
    }
}
