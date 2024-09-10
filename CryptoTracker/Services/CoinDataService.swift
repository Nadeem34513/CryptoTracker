//
//  CoinDataService.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 07/09/24.
//

import Foundation
import Combine

class CoinDataService {
    
    static let instance = CoinDataService()
    @Published var allCoins: [CoinModel] = []
    var coinSubscription: AnyCancellable?
    
    init() {
        downloadCoins()
    }
    
    func downloadCoins(){
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/markets?x_cg_demo_api_key=CG-WsXtSXUossc3W8HMPJDpsxwc&vs_currency=usd&order=market_cap_desc&per_page=250&page=1&sparkline=true&price_change_percentage=24h") else { return }
        
        
        coinSubscription = NetworkManager.download(url: url)
            .decode(type: [CoinModel].self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedCoins in
                print(returnedCoins)
                self?.allCoins = returnedCoins
                self?.coinSubscription?.cancel()
            })
    }
}
