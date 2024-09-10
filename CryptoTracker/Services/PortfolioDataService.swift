//
//  PortfolioDataService.swift
//  CryptoTracker
//
//  Created by Nadeem Noushad on 09/09/24.
//

import Foundation
import CoreData

class PortfolioDataService {
    static let instance = PortfolioDataService()
    
    let container: NSPersistentContainer
    let containerName: String = "PortfolioContainer"
    let entityName: String = "PortfolioEntity"
    @Published var savedEntity: [PortfolioEntity] = []
    
    private init() {
        container = NSPersistentContainer(name: "PortfolioContainer")
        container.loadPersistentStores { (_, error) in
            if let error {
                print("Error loading Core Data \(error)")
            }
            self.getPortfolio()
        }
    }
    
    // MARK: PUBLIC
    func updatePortfolio(coin: CoinModel, amount: Double) {
        // check if coin is already in core data
        if let entity = savedEntity.first(where: { $0.coinID == coin.id }) {
            // if amount is greater than 0 -> update, 
            // 0 or less than 0 -> delete
            if amount > 0 {
                update(entity: entity, updatedAmount: amount)
            } else {
                delete(entity: entity)
            }
        } else {
            // add coin if not present in Core Data
            add(coin: coin, amount: amount)
        }
    }
    
    
    // MARK: PRIVATE
    private func getPortfolio() {
        let request = NSFetchRequest<PortfolioEntity>(entityName: entityName)
        
        do {
            savedEntity = try container.viewContext.fetch(request)
        } catch let error {
            print("Error fetching portfolio from Core Data \(error.localizedDescription)")
        }
    }
    
    private func add(coin: CoinModel, amount: Double) {
        let entity = PortfolioEntity(context: container.viewContext)
        entity.coinID = coin.id
        entity.amount = amount
        
        applyChanges()
    }
    
    private func update(entity: PortfolioEntity, updatedAmount: Double){
        entity.amount = updatedAmount
        applyChanges()
    }
    
    private func delete(entity: PortfolioEntity) {
        container.viewContext.delete(entity)
        applyChanges()
    }
    
    private func saveData() {
        do {
            try container.viewContext.save()
        } catch let error {
            print("Error saving to Core Data \(error.localizedDescription)")
        }
    }
    
    private func applyChanges() {
        saveData()
        getPortfolio()
    }
    
    
}
