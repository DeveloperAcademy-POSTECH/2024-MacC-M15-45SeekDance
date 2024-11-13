//
//  LevelModel.swift
//  StepSquad
//
//  Created by Groo on 11/13/24.
//

import Foundation

class Level: Codable {
    var level: Int
    var minStaircase: Int
    var maxStaircase: Int
    var reward: String
    var rewardImage: String
    var completedDate: Date?
    var difficulty: String
    var wikiLink: String
    var achievementId: String
    
    // TODO: - UserDefaults에서 불러올 경우 수정하기
    init(level: Int, minStaircase: Int, maxStaircase: Int, reward: String, rewardImage: String, completedDate: Date? = nil, difficulty: String, wikiLink: String, achievementId: String) {
        self.level = level
        self.minStaircase = minStaircase
        self.maxStaircase = maxStaircase
        self.reward = reward
        self.rewardImage = rewardImage
        self.completedDate = completedDate
        self.difficulty = difficulty
        self.wikiLink = wikiLink
        self.achievementId = achievementId
    }
}

var levels: [Level] = [
    Level(
        level: 1,
        minStaircase: 0,
        maxStaircase: 4,
        reward: "감초",
        rewardImage: "",
        difficulty: "Easy",
        wikiLink: "",
        achievementId: "min5"),
]
