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
    
    private var dataService = CoinDataService.instance
    private var cancellables = Set<AnyCancellable>()
    
    init() {
        fetchCoins()
    }
    
    func fetchCoins() {
        dataService.$allCoins
            .sink { [weak self] returnedCoins in
                self?.allCoins = returnedCoins
            }
            .store(in: &cancellables)
    }
}
