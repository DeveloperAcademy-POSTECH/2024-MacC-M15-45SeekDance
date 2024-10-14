//
//  Data.swift
//  AppName
//
//  Created by heesohee on 10/14/24.
//

import Foundation

struct Mission {
    let id: UUID
    let title: String
    let duration: Float
    let kWh: Float
    let metaphor: String
    let level: MissionLevel
    let reward: String
    let action: String
    let description: String
}

// Level에 대한 enum 정의
enum MissionLevel {
    case easy
    case normal
    case hard
}

let missions = [
    Mission(
        id: UUID(),
        title: "사무실: 점심, 퇴근 1시간 전 냉방 끄기",
        duration: 3.75,
        kWh: 0.2,
        metaphor: "",
        level: .easy,
        reward: "",
        action: "",
        description: ""
    ),
    
    Mission(
        id: UUID(),
        title: "40W 선풍기",
        duration: 10,
        kWh: 0.006666666667,
        metaphor: "",
        level: .easy,
        reward: "",
        action: "",
        description: ""
    ),
    Mission(
        id: UUID(),
        title: "사무실: 비데 온열기능 끄기",
        duration: 10,
        kWh: 0.001388888889,
        metaphor: "",
        level: .easy,
        reward: "",
        action: "",
        description: ""
    ),
    Mission(
        id: UUID(),
        title: "가정: 사용하지 않는 조명 소등하기",
        duration: 10,
        kWh: 0.005,
        metaphor: "",
        level: .normal,
        reward: "",
        action: "",
        description: ""
    ),
    Mission(
        id: UUID(),
        title: "사무실: 에어컨 설정온도 1도 높이고, 여름철 실내온도 26도 유지하기",
        duration: 10,
        kWh: 0.008333333333,
        metaphor: "",
        level: .normal,
        reward: "",
        action: "",
        description: ""
    ),
    Mission(
        id: UUID(),
        title: "사무실: 퇴근시 냉온수기 전원 끄기",
        duration: 10,
        kWh: 0.009583333333,
        metaphor: "",
        level: .normal,
        reward: "",
        action: "",
        description: ""
    ),
    Mission(
        id: UUID(),
        title: "PC",
        duration: 24.82758621,
        kWh: 0.2,
        metaphor: "",
        level: .hard,
        reward: "",
        action: "",
        description: ""
    ),
]
