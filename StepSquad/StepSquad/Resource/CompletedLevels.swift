//
//  CompletedLevels.swift
//  StepSquad
//
//  Created by Groo on 11/14/24.
//

import Foundation

@Observable
class CompletedLevels: Codable {
    private var levels: [Int: Date]
    private let savePath = URL.documentsDirectory.appending(path: "CompletedLevels")
    var lastUpdatedLevel: Int {
        return levels.keys.max() ?? -1
    }
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([Int: Date].self, from: data)
            levels = decoded
        } catch {
            levels = [Int: Date]()
        }
    }
    
    func upgradeLevel(level: Int, completedDate: Date) {
        self.levels[level] = completedDate
        save()
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(levels)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
    
    func getCompletedDateString(level: Int) -> String {
        if level <= lastUpdatedLevel {
            return levels[level]?.formatted(date: .numeric, time: .omitted) ?? "Error: 달성하지 않은 레벨"
        }
        return "Error: 달성하지 않은 레벨"
    }
    
    func isCompleted(level: Int) -> Bool {
        return levels.keys.contains(level)
    }
}
