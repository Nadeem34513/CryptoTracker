//
//  NetworkManager.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 08/09/24.
//

import Foundation
import Combine

class NetworkManager {
    
    enum NetworkError: LocalizedError {
        case badURLResponse(url: URL)
        case unknown
        
        var errorDescription: String? {
            switch self {
                case .badURLResponse(url: let url): return "[🔥] Bad response from url: \(url)"
                case .unknown: return "[⚠️] Unknown error occured"
            }
        }
    }
    
    static func download(url: URL) -> AnyPublisher<Data, Error> {
        URLSession.shared.dataTaskPublisher(for: url)
            .subscribe(on: DispatchQueue.global(qos: .background))
            .receive(on: DispatchQueue.main)
            .tryMap({ try handleURLResponse(output: $0, url: url) })
            .eraseToAnyPublisher()
    }
    
    static func handleURLResponse(output: URLSession.DataTaskPublisher.Output, url: URL) throws -> Data {
        guard
            let response = output.response as? HTTPURLResponse,
            response.statusCode >= 200 && response.statusCode < 300 else {
            print("Invalid response")
            throw NetworkError.badURLResponse(url: url)
        }
        
        return output.data
    }
    
    static func handleCompletion(completion: Subscribers.Completion<Error>) {
        switch completion {
            case .finished:
                break
            case .failure(let error):
                print("Error \(error)")
        }
    }
}
