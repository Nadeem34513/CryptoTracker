//
//  MarketDataModel.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 08/09/24.
//

import Foundation

struct GlobalData: Codable {
    let data: MarketDataModel?
}

struct MarketDataModel: Codable {
    let totalMarketCap, totalVolume, marketCapPercentage: [String: Double]
    let marketCapChangePercentage24HUsd: Double

    enum CodingKeys: String, CodingKey {
        case totalMarketCap = "total_market_cap"
        case totalVolume = "total_volume"
        case marketCapPercentage = "market_cap_percentage"
        case marketCapChangePercentage24HUsd = "market_cap_change_percentage_24h_usd"
    }
    
    let decoder = JSONDecoder()
    
    init(from decoder: any Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        self.totalMarketCap = try container.decode([String : Double].self, forKey: .totalMarketCap)
        self.totalVolume = try container.decode([String : Double].self, forKey: .totalVolume)
        self.marketCapPercentage = try container.decode([String : Double].self, forKey: .marketCapPercentage)
        self.marketCapChangePercentage24HUsd = try container.decode(Double.self, forKey: .marketCapChangePercentage24HUsd)
    }
    
    var marketCap: String {
        if let item = totalMarketCap.first(where: {$0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var volume: String {
        if let item = totalVolume.first(where: { $0.key == "usd" }) {
            return "$" + item.value.formattedWithAbbreviations()
        }
        return ""
    }
    
    var btcDominance: String {
        if let item = marketCapPercentage.first(where: { $0.key == "btc" }) {
            return "\(item.value.asPercentString())"
        }
        return ""
    }
}
