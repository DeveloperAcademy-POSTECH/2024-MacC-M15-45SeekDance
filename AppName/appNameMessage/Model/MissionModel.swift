//
//  MissionModel.swift
//  AppName
//
//  Created by hanseoyoung on 10/16/24.
//

import Foundation

class Mission: Codable {
    var missionID = UUID()
    let missionTitle: String
    let missionKwh: Float

    init(missionTitle: String, missionKwh: Float) {
        self.missionTitle = missionTitle
        self.missionKwh = missionKwh
    }
}

let sampleMissions: [Mission] = [
    Mission(missionTitle: "컴퓨터 24분 끄기", missionKwh: 0.2),
    Mission(missionTitle: "에어컨 12분 끄기", missionKwh: 0.2),
    Mission(missionTitle: "1층은 계단이동", missionKwh: 0.025),
    Mission(missionTitle: "전등키보드 1시간 안쓰기", missionKwh: 0.1),
    Mission(missionTitle: "쿨맵시 옷 입기", missionKwh: 0.01),
    Mission(missionTitle: "어쩌구 저쩌구", missionKwh: 0.3),
    Mission(missionTitle: "이열치열 대결하기", missionKwh: 0.4),
    Mission(missionTitle: "총장실 불끄기", missionKwh: 0.02),
    Mission(missionTitle: "디지털 디톡스 하기", missionKwh: 0.07)
]
