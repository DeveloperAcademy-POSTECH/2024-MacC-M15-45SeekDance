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
    let id: String // 영문명 TODO: 계단 이미지도 id와 동일하게 설정
    let name: String // 계단명
    let title: String // 계단의 부제
    let steps: Int // 계단 개수
    let latitude: Double // 위도
    let longitude: Double // 경도
    let province: KoreanProvince // 해당 지역
    let description: String // 설명
    let verificationLocation: String // 인증 위치 TODO: 인증 위치 파일명은 "[id]_location"
    let reward: String // 획득 재료 TODO: 리워드 이미지 파일명은 "[id]_reward"로 설정
    let achievementId: String
    
    init(id: String, name: String, title: String, steps: Int, latitude: Double, longitude: Double, province: KoreanProvince, description: String, verificationLocation: String, reward: String, achievementId: String) {
        self.id = id
        self.name = name
        self.title = title
        self.steps = steps
        self.latitude = latitude
        self.longitude = longitude
        self.province = province
        self.description = description
        self.verificationLocation = verificationLocation
        self.reward = reward
        self.achievementId = achievementId
    }
}

let localStaircases: [GPSStaircase] = [
//    GPSStaircase(id: "Test1", name: "동네 계단", title: "우리 동네에 이런 계단이 있다고?", steps: 70, latitude: <#T##Double#>, province: .jeju, description: "네 있습니다. 참고 설명입니다.", reward: "굉장한 선물", achievementId: "test1"),
]
