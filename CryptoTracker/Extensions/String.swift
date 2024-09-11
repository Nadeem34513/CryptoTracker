//
//  String.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 11/09/24.
//

import Foundation

extension String {
    var removingHTMLOccurances: String? {
        return self.replacingOccurrences(of: "<[^>]+>", with: "", options: .regularExpression)
    }
}
