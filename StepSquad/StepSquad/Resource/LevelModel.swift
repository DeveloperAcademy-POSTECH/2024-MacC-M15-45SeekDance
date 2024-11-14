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
    var item: String
    var itemImage: String
    var difficulty: Difficulty
    var wikiLink: String
    var achievementId: String
    
    // TODO: - UserDefaults에서 불러올 경우 수정하기
    init(level: Int, minStaircase: Int, maxStaircase: Int, item: String, itemImage: String, difficulty: Difficulty, wikiLink: String, achievementId: String) {
        self.level = level
        self.minStaircase = minStaircase
        self.maxStaircase = maxStaircase
        self.item = item
        self.itemImage = itemImage
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
        item: "감초",
        itemImage: "1_Gamcho",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min5"),
    Level(
        level: 2,
        minStaircase: 5,
        maxStaircase: 9,
        item: "대추",
        itemImage: "2_Daechu",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min10"),
    Level(
        level: 3,
        minStaircase: 10,
        maxStaircase: 14,
        item: "생강",
        itemImage: "3_Saenggang",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min15"),
    Level(
        level: 4,
        minStaircase: 15,
        maxStaircase: 29,
        item: "도라지",
        itemImage: "4_Doraji",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min30"),
    Level(
        level: 5,
        minStaircase: 30,
        maxStaircase: 59,
        item: "황기",
        itemImage: "5_Hwanggi",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr1"),
    Level(
        level: 6,
        minStaircase: 60,
        maxStaircase: 89,
        item: "당귀",
        itemImage: "6_Danggwi",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr1min30"),
    Level(
        level: 7,
        minStaircase: 90,
        maxStaircase: 119,
        item: "결명자",
        itemImage: "7_Gyeolmyeongja",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr2"),
    Level(
        level: 8,
        minStaircase: 120,
        maxStaircase: 149,
        item: "칡",
        itemImage: "8_ Chik",
        difficulty: .normal,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 9,
        minStaircase: 150,
        maxStaircase: 179,
        item: "옥수수 수염",
        itemImage: "9_Oksususuyeom",
        difficulty: .normal,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 10,
        minStaircase: 180,
        maxStaircase: 239,
        item: "인삼",
        itemImage: "10_Insam",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 11,
        minStaircase: 240,
        maxStaircase: 299,
        item: "맥문동",
        itemImage: "11_Maengmundong",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 12,
        minStaircase: 300,
        maxStaircase: 359,
        item: "구기자",
        itemImage: "12_Gugija",
        difficulty: .hard,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 13,
        minStaircase: 360,
        maxStaircase: 479,
        item: "산수유",
        itemImage: "13_Sansuyu",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 14,
        minStaircase: 480,
        maxStaircase: 599,
        item: "천마",
        itemImage: "14_Chunma",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 15,
        minStaircase: 600,
        maxStaircase: 719,
        item: "황정",
        itemImage: "15_Hwangjeong",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 16,
        minStaircase: 720,
        maxStaircase: 839,
        item: "백출",
        itemImage: "16_Baekchul",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 17,
        minStaircase: 840,
        maxStaircase: 959,
        item: "백복령",
        itemImage: "17_Baekbongnyeong",
        difficulty: .expert,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 18,
        minStaircase: 960,
        maxStaircase: 1199,
        item: "천문동",
        itemImage: "18_Cheonmundong",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: ""),
    Level(
        level: 19,
        minStaircase: 1200,
        maxStaircase: 1439,
        item: "하수오",
        itemImage: "19_Hasuo",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: ""),
]
