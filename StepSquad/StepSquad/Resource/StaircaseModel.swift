//
//  StaircaseModel.swift
//  StepSquad
//
//  Created by Groo on 2/20/25.
//

import Foundation

enum KoreanProvince: String, Codable {
    case gangwon = "강원특별자치도"
    case gyeonggi = "경기도"
    case gyeongnam = "경상남도"
    case gyeongbuk = "경상북도"
    case jeonnam = "전라남도"
    case jeonbuk = "전북특별자치도"
    case jeju = "제주특별자치도"
    case chungnam = "충청남도"
    case chungbuk = "충청북도"
}

class Staircase: Codable {
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
