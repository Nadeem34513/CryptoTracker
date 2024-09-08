//
//  LocalFileManager.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 08/09/24.
//

import Foundation
import SwiftUI

class LocalFileManager {
    
    static let instance = LocalFileManager()
    private init() {
        
    }
    
    func createFolderIfNeeded(folderName: String) {
        guard let url = getFolderPath(folderName: folderName) else { return }
        
        if !FileManager.default.fileExists(atPath: url.path()) {
            do {
                try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true)
                print("directory created")
            } catch let error {
                print("Error creating directory \(error)")
            }
        }
    }
    
    private func getFolderPath(folderName: String) -> URL? {
        return FileManager
            .default
            .urls(for: .cachesDirectory, in: .userDomainMask)
            .first?
            .appendingPathComponent(folderName)
    }
    
    private func getImagePath(key: String, folderName: String) -> URL? {
        guard let folderUrl = getFolderPath(folderName: folderName) else { return nil }
        
        return folderUrl.appendingPathComponent(key + ".png")
    }
    
    func saveImage(key: String, image: UIImage, folderName: String) {
        guard
            let url = getImagePath(key: key, folderName: folderName),
            let data = image.pngData() else { return }
        
        do {
            try data.write(to: url)
        } catch let error {
            print("Error saving image to FM \(error)")
        }
    }
    
    func fetchImage(key: String, folderName: String) -> UIImage? {
        guard
            let url = getImagePath(key: key, folderName: folderName),
            FileManager.default.fileExists(atPath: url.path()) else { return nil }
        
        return UIImage(contentsOfFile: url.path())
    }
}
