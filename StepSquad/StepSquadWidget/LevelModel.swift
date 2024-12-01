//
//  LevelModel.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/25/24.
//

//
//  LevelModel.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/25/24.
//

import Foundation

enum Difficulty: String, Codable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
    case expert = "Expert"
    case impossible = "Impossible"
    case nfc = "NFC"
}

class Level: Codable {
    var level: Int
    var minStaircase: Int
    var maxStaircase: Int

    // Initializer for Level
    init(level: Int, minStaircase: Int, maxStaircase: Int) {
        self.level = level
        self.minStaircase = minStaircase
        self.maxStaircase = maxStaircase
    }
}

struct LevelManager {
    static let levels: [Level] = [
        Level(level: 1, minStaircase: 0, maxStaircase: 4),
        Level(level: 2, minStaircase: 5, maxStaircase: 9),
        Level(level: 3, minStaircase: 10, maxStaircase: 14),
        Level(level: 4, minStaircase: 15, maxStaircase: 29),
        Level(level: 5, minStaircase: 30, maxStaircase: 59),
        Level(level: 6, minStaircase: 60, maxStaircase: 89),
        Level(level: 7, minStaircase: 90, maxStaircase: 119),
        Level(level: 8, minStaircase: 120, maxStaircase: 149),
        Level(level: 9, minStaircase: 150, maxStaircase: 179),
        Level(level: 10, minStaircase: 180, maxStaircase: 239),
        Level(level: 11, minStaircase: 240, maxStaircase: 299),
        Level(level: 12, minStaircase: 300, maxStaircase: 359),
        Level(level: 13, minStaircase: 360, maxStaircase: 479),
        Level(level: 14, minStaircase: 480, maxStaircase: 599),
        Level(level: 15, minStaircase: 600, maxStaircase: 719),
        Level(level: 16, minStaircase: 720, maxStaircase: 839),
        Level(level: 17, minStaircase: 840, maxStaircase: 959),
        Level(level: 18, minStaircase: 960, maxStaircase: 1199),
        Level(level: 19, minStaircase: 1200, maxStaircase: Int.max),
    ]

    static func calculateLevel(for flightsClimbed: Int) -> Level? {
        return levels.first { flightsClimbed >= $0.minStaircase && flightsClimbed <= $0.maxStaircase }
    }
}
