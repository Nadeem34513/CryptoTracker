//
//  CoinImageViewModel.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 08/09/24.
//

import Foundation
import SwiftUI
import Combine

class CoinImageViewModel: ObservableObject {
    @Published var image: UIImage? = nil
    @Published var isLoading: Bool = false
    
    private let coin: CoinModel
    private let imageService: CoinImageService
    var cancellables = Set<AnyCancellable>()
    
    init(coin: CoinModel) {
        self.coin = coin
        self.imageService = CoinImageService(coin: coin)
        self.isLoading = true
        self.getCoinImage()
    }
    
    func getCoinImage() {
        imageService.$image
            .sink(receiveCompletion: { [weak self] (_) in
                self?.isLoading = false
            }, receiveValue: { [weak self] returnedImage in
                guard
                    let self = self,
                    let image = returnedImage else { return }
                self.image = image
                self.isLoading = false
            })
            .store(in: &cancellables)
        
                
    }
}

