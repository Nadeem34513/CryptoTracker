//
//  CoinDetailModel.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 10/09/24.
//

import Foundation

struct CoinDetailModel: Codable {
    let id, symbol, name, webSlug: String?
    let blockTimeInMinutes: Int?
    let hashingAlgorithm: String?
    let categories: [String]?
    let description: Description?
    let links: Links?
    
    enum CodingKeys: String, CodingKey {
        case id, symbol, name
        case webSlug = "web_slug"
        case blockTimeInMinutes = "block_time_in_minutes"
        case hashingAlgorithm = "hashing_algorithm"
        case categories
        case description, links
    }
    
    var readableDescription: String? {
        return description?.en?.removingHTMLOccurances
    }
}

struct Description: Codable {
    let en: String?
}

struct Links: Codable {
    let homepage: [String]?
    let twitterScreenName, facebookUsername: String?
    let subredditURL: String?
    
    enum CodingKeys: String, CodingKey {
       case homepage
       case twitterScreenName = "twitter_screen_name"
       case facebookUsername = "facebook_username"
       case subredditURL = "subreddit_url"
    }
}
