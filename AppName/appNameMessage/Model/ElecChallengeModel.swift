//
//  Challenge.swift
//  AppName
//
//  Created by hanseoyoung on 10/15/24.
//

import Foundation

// ChallengeRecord와 연결되어야 함.
class ElecChallenge {
    let id = UUID()
    let name: String
    let totalKwh: Double
    let date: Int
    //추후에 Date 타입으로 변경

    init(name: String, totalKwh: Double, date: Int) {
        self.name = name
        self.totalKwh = totalKwh
        self.date = date
    }
}

let sampleData = [
    ElecChallenge(name: "Challenge 1", totalKwh: 8, date: 2),
    ElecChallenge(name: "Challenge 2", totalKwh: 3, date: 1),
    ElecChallenge(name: "Challenge 3", totalKwh: 4, date: 3),
    ElecChallenge(name: "Challenge 4", totalKwh: 1, date: 0)
]

