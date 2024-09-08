//
//  MarketDataService.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 08/09/24.
//

import Foundation
import Combine

class MarketDataService {
    static let instance = MarketDataService()
    @Published var marketData: MarketDataModel? = nil
    var marketDataSubscription: AnyCancellable?
    
    init () {
        downloadMarketData()
    }
    
    private func downloadMarketData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/global") else { return }
        
        marketDataSubscription = NetworkManager.download(url: url)
            .decode(type: GlobalData.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedGlobalData in
                self?.marketData = returnedGlobalData.data
                self?.marketDataSubscription?.cancel()
            })
    }
}
