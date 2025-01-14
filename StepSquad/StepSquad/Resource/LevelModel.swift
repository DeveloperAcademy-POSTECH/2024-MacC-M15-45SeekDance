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
    let level: Int
    let minStaircase: Int
    let maxStaircase: Int
    let item: String
    let itemImage: String
    let difficulty: Difficulty
    let wikiLink: String
    let achievementId: String
    
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

// MARK: 레벨 1 ~ 19 저장, 인덱스는 레벨 -1로 활용
let levels: [Int: Level] = [
    1 : Level(
        level: 1,
        minStaircase: 0,
        maxStaircase: 4,
        item: "감초",
        itemImage: "1_Gamcho",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min5"),
    2: Level(
        level: 2,
        minStaircase: 5,
        maxStaircase: 9,
        item: "대추",
        itemImage: "2_Daechu",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min10"),
    3: Level(
        level: 3,
        minStaircase: 10,
        maxStaircase: 14,
        item: "생강",
        itemImage: "3_Saenggang",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min15"),
    4: Level(
        level: 4,
        minStaircase: 15,
        maxStaircase: 29,
        item: "도라지",
        itemImage: "4_Doraji",
        difficulty: .easy,
        wikiLink: "",
        achievementId: "min30"),
    5: Level(
        level: 5,
        minStaircase: 30,
        maxStaircase: 59,
        item: "황기",
        itemImage: "5_Hwanggi",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr1"),
    6: Level(
        level: 6,
        minStaircase: 60,
        maxStaircase: 89,
        item: "당귀",
        itemImage: "6_Danggwi",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr1min30"),
    7: Level(
        level: 7,
        minStaircase: 90,
        maxStaircase: 119,
        item: "결명자",
        itemImage: "7_Gyeolmyeongja",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr2"),
    8: Level(
        level: 8,
        minStaircase: 120,
        maxStaircase: 149,
        item: "칡",
        itemImage: "8_Chik",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr2min30"),
    9: Level(
        level: 9,
        minStaircase: 150,
        maxStaircase: 179,
        item: "옥수수 수염",
        itemImage: "9_Oksususuyeom",
        difficulty: .normal,
        wikiLink: "",
        achievementId: "hr3"),
    10: Level(
        level: 10,
        minStaircase: 180,
        maxStaircase: 239,
        item: "인삼",
        itemImage: "10_Insam",
        difficulty: .hard,
        wikiLink: "",
        achievementId: "hr4"),
    11: Level(
        level: 11,
        minStaircase: 240,
        maxStaircase: 299,
        item: "맥문동",
        itemImage: "11_Maengmundong",
        difficulty: .hard,
        wikiLink: "",
        achievementId: "hr5"),
    12: Level(
        level: 12,
        minStaircase: 300,
        maxStaircase: 359,
        item: "구기자",
        itemImage: "12_Gugija",
        difficulty: .hard,
        wikiLink: "",
        achievementId: "hr6"),
    13: Level(
        level: 13,
        minStaircase: 360,
        maxStaircase: 479,
        item: "산수유",
        itemImage: "13_Sansuyu",
        difficulty: .expert,
        wikiLink: "",
        achievementId: "hr8"),
    14: Level(
        level: 14,
        minStaircase: 480,
        maxStaircase: 599,
        item: "천마",
        itemImage: "14_Chunma",
        difficulty: .expert,
        wikiLink: "",
        achievementId: "hr10"),
    15: Level(
        level: 15,
        minStaircase: 600,
        maxStaircase: 719,
        item: "황정",
        itemImage: "15_Hwangjeong",
        difficulty: .expert,
        wikiLink: "",
        achievementId: "hr12"),
    16: Level(
        level: 16,
        minStaircase: 720,
        maxStaircase: 839,
        item: "백출",
        itemImage: "16_Baekchul",
        difficulty: .expert,
        wikiLink: "",
        achievementId: "hr14"),
    17: Level(
        level: 17,
        minStaircase: 840,
        maxStaircase: 959,
        item: "백복령",
        itemImage: "17_Baekbongnyeong",
        difficulty: .expert,
        wikiLink: "",
        achievementId: "hr16"),
    18: Level(
        level: 18,
        minStaircase: 960,
        maxStaircase: 1199,
        item: "천문동",
        itemImage: "18_Cheonmundong",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: "hr20"),
    19: Level(
        level: 19,
        minStaircase: 1200,
        maxStaircase: 1439,
        item: "산삼",
        itemImage: "19_Sansam",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: "hr24"),
    // TODO: - 만렙 설정하기
    20: Level(
        level: 20,
        minStaircase: 1440,
        maxStaircase: Int.max,
        item: "",
        itemImage: "",
        difficulty: .impossible,
        wikiLink: "",
        achievementId: "")
]
