//
//  HomeViewModel.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 07/09/24.
//

import Foundation
import Combine

class HomeViewModel: ObservableObject {
    @Published var allCoins: [CoinModel] = []
    @Published var portfolioCoins: [CoinModel] = []
    @Published var searchText: String = ""
    @Published var statistics: [StatisticModel] = []
    
    private var coinDataService = CoinDataService.instance
    private var marketDataService = MarketDataService.instance
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        addSubscribers()
    }
    
    func addSubscribers() {
        $searchText
            .combineLatest(coinDataService.$allCoins)
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .map(filterCoins)
            .sink { [weak self] filteredCoins in
                self?.allCoins = filteredCoins
            }
            .store(in: &cancellables)
            
        marketDataService.$marketData
            .map(convertDataToStatisticModel)
            .sink { [weak self] statistics in
                self?.statistics = statistics
            }
            .store(in: &cancellables)
            
    }
    
    private func filterCoins(text: String, startingCoins: [CoinModel]) -> [CoinModel] {
        guard !text.isEmpty else { return startingCoins }
        
        let lowercasedText = text.lowercased()
        return startingCoins.filter { coin in
            return coin.name.lowercased().contains(lowercasedText) ||
            coin.symbol.lowercased().contains(lowercasedText) ||
            coin.id.lowercased().contains(lowercasedText)
        }
    }
    
    private func convertDataToStatisticModel(marketDataModel: MarketDataModel?) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else { return stats }
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        let portfolioValue = StatisticModel(title: "Portfolio Value", value: "$0.00", percentageChange: 0)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolioValue])
        return stats
    }
}
