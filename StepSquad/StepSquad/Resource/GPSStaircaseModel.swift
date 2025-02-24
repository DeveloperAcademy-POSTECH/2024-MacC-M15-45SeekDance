//
//  StaircaseModel.swift
//  StepSquad
//
//  Created by Groo on 2/20/25.
//

import Foundation

enum KoreanProvince: String, Codable {
    case gangwon = "강원"
    case gyeonggi = "수도권"
    case gyeongnam = "부산/울산/경남"
    case gyeongbuk = "대구/경북"
    case jeonnam = "광주/전남"
    case jeonbuk = "전북"
    case jeju = "제주"
    case chungnam = "대전/충남"
    case chungbuk = "충북"
}

class GPSStaircase: Codable, Identifiable {
    let id: String // TODO: id는 영문명으로 계단 이미지도 id와 동일하게 설정
    let name: String
    let title: String
    let steps: Int
    let locationX: Int // TODO: 인증방식에 따라 Location으로 변경
    let locationY: Int
    let province: KoreanProvince
    let description: String
    let reward: String // TODO: 리워드 이미지 파일명은 "[id]_reward"로 설정
    let achievementId: String
    
    init(id: String, name: String, title: String, steps: Int, location: (Int, Int), province: KoreanProvince, description: String, reward: String, achievementId: String) {
        self.id = id
        self.name = name
        self.title = title
        self.steps = steps
        self.locationX = location.0
        self.locationY = location.1
        self.province = province
        self.description = description
        self.reward = reward
        self.achievementId = achievementId
    }
}

let localStaircases: [GPSStaircase] = [
    GPSStaircase(id: "Test1", name: "동네 계단", title: "우리 동네에 이런 계단이 있다고?", steps: 70, location: (1, 2), province: .jeju, description: "네 있습니다. 참고 설명입니다.", reward: "굉장한 선물", achievementId: "test1"),
    GPSStaircase(id: "Test2", name: "먼 계단", title: "먼 동네에 이런 계단이 있다고?", steps: 70, location: (1, 2), province: .jeju, description: "네 있습니다. 참고 설명입니다.", reward: "굉장히 선물", achievementId: "test2"),
]
