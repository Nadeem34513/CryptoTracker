//
//  CoinDetailDataService.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 10/09/24.
//

import Foundation
import Combine

class CoinDetailDataService {

    var coinDetailSubscription: AnyCancellable?
    var coin: CoinModel
    @Published var coinDetail: CoinDetailModel? = nil
    
    init(coin: CoinModel) {
        self.coin = coin
        downloadData()
    }
    
    private func downloadData() {
        guard let url = URL(string: "https://api.coingecko.com/api/v3/coins/\(coin.id)?x_cg_demo_api_key=CG-WsXtSXUossc3W8HMPJDpsxwc&localization=false&tickers=false&market_data=false&community_data=false&developer_data=false&sparkline=false") else { return }
        
        coinDetailSubscription = NetworkManager.download(url: url)
            .decode(type: CoinDetailModel.self, decoder: JSONDecoder())
            .sink(receiveCompletion: NetworkManager.handleCompletion) { [weak self] returnedData in
                self?.coinDetail = returnedData
                self?.coinDetailSubscription?.cancel()
            }

    }
}
