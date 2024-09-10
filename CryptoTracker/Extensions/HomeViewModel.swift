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
    private var portfolioDataService = PortfolioDataService.instance
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
            .combineLatest($portfolioCoins)
            .map(convertDataToStatisticModel)
            .sink { [weak self] statistics in
                self?.statistics = statistics
            }
            .store(in: &cancellables)
            
        $allCoins
            .combineLatest(portfolioDataService.$savedEntity)
            .map(mapToCoinMode)
            .sink { [weak self] returnedCoins in
                self?.portfolioCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
    
    func updatePortfolio(coin: CoinModel, amount: Double) {
        portfolioDataService.updatePortfolio(coin: coin, amount: amount)
    }
    
    func reloadData() {
        coinDataService.downloadCoins()
        marketDataService.downloadMarketData()
        print("reloaded")
    }
    
    private func mapToCoinMode(coinModel: [CoinModel], portfolioEntity: [PortfolioEntity]) -> [CoinModel] {
        coinModel
            .compactMap { (coin) -> CoinModel? in
                guard let entity = portfolioEntity.first(where: { $0.coinID == coin.id }) else  { return nil }
                return coin.updateHoldings(amount: entity.amount)
            }
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
    
    private func convertDataToStatisticModel(marketDataModel: MarketDataModel?, portfolioCoins: [CoinModel]) -> [StatisticModel] {
        var stats: [StatisticModel] = []
        guard let data = marketDataModel else { return stats }
    
        
        let marketCap = StatisticModel(title: "Market Cap", value: data.marketCap, percentageChange: data.marketCapChangePercentage24HUsd)
        
        let volume = StatisticModel(title: "24h Volume", value: data.volume)
        let btcDominance = StatisticModel(title: "BTC Dominance", value: data.btcDominance)
        
        let portfolioValue = portfolioCoins
            .map({ $0.currentHoldingsValue })
            .reduce(0, +)
        
        let previousValue = portfolioCoins
            .map(getPercentageChange)
            .reduce(0, +)
        
        let percentageChange = ((portfolioValue - previousValue) / portfolioValue) * 100
        
        let portfolio = StatisticModel(title: "Portfolio Value", value: portfolioValue.formattedWithAbbreviations(), percentageChange: percentageChange)
        
        stats.append(contentsOf: [marketCap, volume, btcDominance, portfolio])
        return stats
    }
    
    private func getPercentageChange(coin: CoinModel) -> Double {
        let currentValue = coin.currentHoldingsValue
        let percentChange = (coin.priceChangePercentage24H ?? 0) / 100
        let previousValue = currentValue / (1 + percentChange)
        return previousValue
    }
}
