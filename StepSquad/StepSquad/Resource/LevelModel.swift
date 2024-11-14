//
//  LevelModel.swift
//  StepSquad
//
//  Created by Groo on 11/13/24.
//

import Foundation

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
    var difficulty: Difficulty
    var wikiLink: String
    var achievementId: String
    
    // TODO: - UserDefaults에서 불러올 경우 수정하기
    init(level: Int, minStaircase: Int, maxStaircase: Int, reward: String, rewardImage: String, difficulty: Difficulty, wikiLink: String, achievementId: String) {
        self.level = level
        self.minStaircase = minStaircase
        self.maxStaircase = maxStaircase
        self.reward = reward
        self.rewardImage = rewardImage
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
        rewardImage: "1_Gamcho",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min5"),
    Level(
        level: 2,
        minStaircase: 5,
        maxStaircase: 9,
        reward: "대추",
        rewardImage: "2_Daechu",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min10"),
    Level(
        level: 3,
        minStaircase: 10,
        maxStaircase: 14,
        reward: "생강",
        rewardImage: "3_Saenggang",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min15"),
    Level(
        level: 4,
        minStaircase: 15,
        maxStaircase: 29,
        reward: "도라지",
        rewardImage: "4_Doraji",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min30"),
    Level(
        level: 5,
        minStaircase: 30,
        maxStaircase: 59,
        reward: "황기",
        rewardImage: "5_Hwanggi",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr1"),
    Level(
        level: 6,
        minStaircase: 60,
        maxStaircase: 89,
        reward: "당귀",
        rewardImage: "6_Danggwi",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr1min30"),
    Level(
        level: 7,
        minStaircase: 90,
        maxStaircase: 119,
        reward: "결명자",
        rewardImage: "7_Gyeolmyeongja",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr2"),
    Level(
        level: 8,
        minStaircase: 120,
        maxStaircase: 149,
        reward: "칡",
        rewardImage: "8_ Chik",
        difficulty: .normal,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 9,
        minStaircase: 150,
        maxStaircase: 179,
        reward: "옥수수 수염",
        rewardImage: "9_Oksususuyeom",
        difficulty: .normal,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 10,
        minStaircase: 180,
        maxStaircase: 239,
        reward: "인삼",
        rewardImage: "10_Insam",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 11,
        minStaircase: 240,
        maxStaircase: 299,
        reward: "맥문동",
        rewardImage: "11_Maengmundong",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 12,
        minStaircase: 300,
        maxStaircase: 359,
        reward: "구기자",
        rewardImage: "12_Gugija",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 13,
        minStaircase: 360,
        maxStaircase: 479,
        reward: "산수유",
        rewardImage: "13_Sansuyu",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 14,
        minStaircase: 480,
        maxStaircase: 599,
        reward: "천마",
        rewardImage: "14_Chunma",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 15,
        minStaircase: 600,
        maxStaircase: 719,
        reward: "황정",
        rewardImage: "15_Hwangjeong",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 16,
        minStaircase: 720,
        maxStaircase: 839,
        reward: "백출",
        rewardImage: "16_Baekchul",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 17,
        minStaircase: 840,
        maxStaircase: 959,
        reward: "백복령",
        rewardImage: "17_Baekbongnyeong",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 18,
        minStaircase: 960,
        maxStaircase: 1199,
        reward: "천문동",
        rewardImage: "18_Cheonmundong",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 19,
        minStaircase: 1200,
        maxStaircase: 1439,
        reward: "하수오",
        rewardImage: "19_Hasuo",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: ""),
]
