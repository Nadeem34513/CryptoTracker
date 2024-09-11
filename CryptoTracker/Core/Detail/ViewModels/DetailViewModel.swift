//
//  CoinDetailViewModel.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 10/09/24.
//

import Foundation
import Combine

class DetailViewModel: ObservableObject {
    @Published private var coinDetail: CoinDetailModel? = nil
    @Published var overviewStats: [StatisticModel] = []
    @Published var additionalStats: [StatisticModel] = []
    @Published var coin: CoinModel
    @Published var coinDescription: String? = nil
    @Published var websiteURL: String? = nil
    @Published var redditURL: String? = nil
    
    private var coinDetailDataService: CoinDetailDataService
    private var cancellables = Set<AnyCancellable>()

    init(coin: CoinModel) {
        self.coin = coin
        coinDetailDataService = CoinDetailDataService(coin: coin)
        getDetail()
    }
    
    func getDetail() {
        coinDetailDataService.$coinDetail
            .combineLatest($coin)
            .map(mapDataToStatistics)
            .sink { [weak self] returnedArray in
                guard let self = self else { return }
                self.overviewStats = returnedArray.overview
                self.additionalStats = returnedArray.additional
            }
            .store(in: &cancellables)
        
        coinDetailDataService.$coinDetail
            .sink(receiveValue: { [weak self] returnedData in
                guard let self = self else { return }
                
                self.coinDescription = returnedData?.readableDescription
                self.websiteURL = returnedData?.links?.homepage?.first
                self.redditURL = returnedData?.links?.subredditURL
            })
            .store(in: &cancellables)
    }
    
    private func mapDataToStatistics(coinDetailsModel: CoinDetailModel?, coinModel: CoinModel) -> (overview: [StatisticModel], additional: [StatisticModel]) {
        var overviewStats: [StatisticModel] = []
        var additionalStats: [StatisticModel] = []
        
        guard let coinDetail = coinDetailsModel else { return (overviewStats, additionalStats)}
        
        overviewStats.append(contentsOf: getOverviewStats(coin: coinModel))
        additionalStats.append(contentsOf: getAdditionalStats(coin: coinModel, coinDetail: coinDetail))
        
        return (overviewStats, additionalStats)
    }
    
    // creating overview stats data
    private func getOverviewStats(coin: CoinModel) -> [StatisticModel] {
        let price = coin.currentPrice.asCurrencyWith6Decimals()
        let pricePercentageChange = coin.priceChangePercentage24H
        let priceStat = StatisticModel(title: "Current Price", value: price, percentageChange: pricePercentageChange)
        
        let marketCap = "$" + (coin.marketCap?.formattedWithAbbreviations() ?? "")
        let marketCapChange = coin.marketCapChangePercentage24H
        let marketCapStat = StatisticModel(title: "Market Capitalization", value: marketCap, percentageChange: marketCapChange)
        
        let rankStat = StatisticModel(title: "Rank", value: String(coin.rank))
        
        let volume = "$" + (coin.totalVolume?.formattedWithAbbreviations() ?? "")
        let volumeStat = StatisticModel(title: "Total Volume", value: volume)
        
        return [priceStat, marketCapStat, rankStat, volumeStat]
    }
    
    // creating additional stats data
    private func getAdditionalStats(coin: CoinModel, coinDetail: CoinDetailModel) -> [StatisticModel] {
        let high = coin.high24H?.asCurrencyWith2Decimals() ?? "n/a"
        let highStat = StatisticModel(title: "24h High", value: high)
        
        let low = coin.low24H?.asCurrencyWith2Decimals() ?? "n/a"
        let lowStat = StatisticModel(title: "24h Low", value: low)
        
        let priceChange = coin.priceChange24H?.asCurrencyWith6Decimals() ?? "n/a"
        let pricePercentageChange = coin.priceChangePercentage24H
        let priceChangeStat = StatisticModel(title: "24h Price change", value: priceChange, percentageChange: pricePercentageChange)
        
        let marketChange = coin.marketCapChange24H?.formattedWithAbbreviations() ?? "n/a"
        let marketCapChange = coin.marketCapChangePercentage24H
        let marketChangeStat = StatisticModel(title: "24h Market Cap Change", value: marketChange, percentageChange: marketCapChange)

        let blockTime = coinDetail.blockTimeInMinutes ?? 0
        let blockTimeString = blockTime == 0 ? "n/a" : String(blockTime)
        let blockTimeStat = StatisticModel(title: "Block Time", value: blockTimeString)

        let hashing = coinDetail.hashingAlgorithm ?? "n/a"
        let hashingStat = StatisticModel(title: "Hashing Algorithm", value: hashing)
        
        return [highStat, lowStat, priceChangeStat, marketChangeStat, blockTimeStat, hashingStat]
    }
}
