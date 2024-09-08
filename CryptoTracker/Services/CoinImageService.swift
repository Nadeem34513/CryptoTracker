//
//  CoinImageService.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 08/09/24.
//

import Foundation
import Combine
import SwiftUI

class CoinImageService {
    @Published var image: UIImage? = nil
    
    private var imageSubscription: AnyCancellable?
    private let coin: CoinModel
    private let fileManager = LocalFileManager.instance
    private let imageName: String
    private let folderName = "Crypto_Tracker"
    init(coin: CoinModel) {
        self.coin = coin
        self.imageName = coin.id
        getCoinImage()
    }
    
    func getCoinImage() {
        if let savedImage = fileManager.fetchImage(key: imageName, folderName: folderName) {
            image = savedImage
            print("getting saved image")
        } else {
            downloadImage()
            print("downloading images")
        }
    }
    
    private func downloadImage() {
        guard let url = URL(string: coin.image) else { return }
        
        
        imageSubscription = NetworkManager.download(url: url)
            .tryMap({ (data) -> UIImage? in
                return UIImage(data: data)
            })
            .sink(receiveCompletion: NetworkManager.handleCompletion, receiveValue: { [weak self] returnedImage in
                guard
                    let self = self,
                    let image = returnedImage else { return }
                self.image = returnedImage
                self.fileManager.saveImage(key: self.imageName, image: image, folderName: self.folderName)
                self.imageSubscription?.cancel()
            })
    }
}
