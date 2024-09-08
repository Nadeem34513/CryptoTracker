//
//  UIApplication.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 09/09/24.
//

import Foundation
import SwiftUI

extension UIApplication {
    
    func endEditing() {
        sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
    
}
