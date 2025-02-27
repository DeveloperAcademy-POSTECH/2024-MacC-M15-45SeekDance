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

let gpsStaircases: [GPSStaircase] = [
    GPSStaircase(id: "Test1", name: "초량 이바구길 168 계단", title: "역사가 오래된 초량의 이바구 길", steps: 168, latitude: 35.117143, longitude: 129.035298, province: .gyeongnam, description: "이바구길을 이바구를 떨며 걸어올라가 볼까나?", verificationLocation: "인증 장소 예시", reward: "국밥 육수", achievementId: "test1"),
]
