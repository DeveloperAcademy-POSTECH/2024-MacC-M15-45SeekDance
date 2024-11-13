//
//  LevelModel.swift
//  StepSquad
//
//  Created by Groo on 11/13/24.
//

import Foundation

class CurrentStatus: Codable {
    var totalStaircase: Int // 누적 오른 층계
    var currentLevel: Level { // 현재 레벨
        for level in levels {
            if level.minStaircase <= totalStaircase && totalStaircase <= level.maxStaircase {
                return level
            }
        }
        return levels.first! // 에러 발생시 레벨 1으로 설정
    }
    var currentProgress: Int { // 현재 레벨의 현재 단계
        let gap = (currentLevel.maxStaircase + 1) - currentLevel.minStaircase
        let rest = totalStaircase - currentLevel.minStaircase
        return Int(floor(Double(rest / gap) * 5 + 1))
    }
    var progressImage: String { // 현재 단계 이미지
        return "\(currentLevel.difficulty.rawValue)\(currentProgress)"
    }
    
    // TODO: - UserDefaults에서 불러올 경우 수정하기
    init(totalStaircase: Int = 0) {
        self.totalStaircase = totalStaircase
    }
    
    static let currentStatusExample: CurrentStatus = CurrentStatus()
}

enum Difficulty: String, Codable {
    case easy = "Easy"
    case normal = "Normal"
    case hard = "Hard"
    case expert = "Expert"
    case impossible = "Impossible"
}

class Level: Codable {
    var level: Int
    var minStaircase: Int
    var maxStaircase: Int
    var reward: String
    var rewardImage: String
    var completedDate: Date?
    var difficulty: Difficulty
    var wikiLink: String
    var achievementId: String
    
    // TODO: - UserDefaults에서 불러올 경우 수정하기
    init(level: Int, minStaircase: Int, maxStaircase: Int, reward: String, rewardImage: String, completedDate: Date? = nil, difficulty: Difficulty, wikiLink: String, achievementId: String) {
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

// MARK: 레벨 1 ~ 19 저장
var levels: [Level] = [
    Level(
        level: 1,
        minStaircase: 0,
        maxStaircase: 4,
        reward: "감초",
        rewardImage: "",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min5"),
    Level(
        level: 2,
        minStaircase: 5,
        maxStaircase: 9,
        reward: "대추",
        rewardImage: "",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min10"),
    Level(
        level: 3,
        minStaircase: 10,
        maxStaircase: 14,
        reward: "생강",
        rewardImage: "",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min15"),
    Level(
        level: 4,
        minStaircase: 15,
        maxStaircase: 29,
        reward: "도라지",
        rewardImage: "",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min30"),
    Level(
        level: 5,
        minStaircase: 30,
        maxStaircase: 59,
        reward: "황기",
        rewardImage: "",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr1"),
    Level(
        level: 6,
        minStaircase: 60,
        maxStaircase: 89,
        reward: "당귀",
        rewardImage: "",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr1min30"),
    Level(
        level: 7,
        minStaircase: 90,
        maxStaircase: 119,
        reward: "결명자",
        rewardImage: "",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr2"),
    Level(
        level: 8,
        minStaircase: 120,
        maxStaircase: 149,
        reward: "칡",
        rewardImage: "",
        difficulty: .normal,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 9,
        minStaircase: 150,
        maxStaircase: 179,
        reward: "옥수수 수염",
        rewardImage: "",
        difficulty: .normal,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 10,
        minStaircase: 180,
        maxStaircase: 239,
        reward: "인삼",
        rewardImage: "",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 11,
        minStaircase: 240,
        maxStaircase: 299,
        reward: "맥문동",
        rewardImage: "",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 12,
        minStaircase: 300,
        maxStaircase: 359,
        reward: "구기자",
        rewardImage: "",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 13,
        minStaircase: 360,
        maxStaircase: 479,
        reward: "산수유",
        rewardImage: "",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 14,
        minStaircase: 480,
        maxStaircase: 599,
        reward: "천마",
        rewardImage: "",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 15,
        minStaircase: 600,
        maxStaircase: 719,
        reward: "황정",
        rewardImage: "",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 16,
        minStaircase: 720,
        maxStaircase: 839,
        reward: "백출",
        rewardImage: "",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 17,
        minStaircase: 840,
        maxStaircase: 959,
        reward: "백복령",
        rewardImage: "",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 18,
        minStaircase: 960,
        maxStaircase: 1199,
        reward: "천문동",
        rewardImage: "",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 19,
        minStaircase: 1200,
        maxStaircase: 1439,
        reward: "하수오",
        rewardImage: "",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: ""),
]
