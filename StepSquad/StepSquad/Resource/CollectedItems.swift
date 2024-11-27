//
//  CollectedItems.swift
//  StepSquad
//
//  Created by Groo on 11/27/24.
//

import Foundation

@Observable
class CollectedItems: Codable {
    private var items: [String: Date]
    private let savePath = URL.documentsDirectory.appending(path: "CollectedItems")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([String: Date].self, from: data)
            items = decoded
        } catch {
            items = [String: Date]()
        }
    }
    
    func collectItem(item: String, collectedDate: Date) {
        self.items[item] = collectedDate
        save()
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(levels)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save collected items.")
        }
    }
    
    func getCollectedDateString(item: String) -> String {
        if items.contains(where: { $0.key == item }) {
            return items[item]!.formatted(date: .numeric, time: .omitted)
        }
        return "Error: 달성하지 않은 레벨"
    }
    
    func isCollected(item: String) -> Bool {
        return items.contains(where: { $0.key == item })
    }
    
    func isEmpty() -> Bool {
        return items.isEmpty
    }
    
    func getItemsKeys() -> [String] {
        return items.keys.map(\.self)
    }
}
