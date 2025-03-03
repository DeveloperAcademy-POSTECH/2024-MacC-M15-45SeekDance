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
    let description: String // 설명
    let province: KoreanProvince // 해당 지역
    let steps: Int // 계단 개수
    let latitude: Double // 위도
    let longitude: Double // 경도
    let verificationLocation: String // 인증 위치 TODO: 인증 위치 파일명은 "[id]_location"
    let reward: String // 획득 재료 TODO: 리워드 이미지 파일명은 "[id]_reward"로 설정
    let achievementId: String // id의 맨 앞글자를 소문자로 만듬
    
    init(id: String, name: String, title: String, description: String, province: KoreanProvince, steps: Int, latitude: Double, longitude: Double, verificationLocation: String, reward: String) {
        self.id = id
        self.name = name
        self.title = title
        self.description = description
        self.province = province
        self.steps = steps
        self.latitude = latitude
        self.longitude = longitude
        self.verificationLocation = verificationLocation
        self.reward = reward
        self.achievementId = id.prefix(1).lowercased() + id.suffix(id.count - 1)
    }
}

let gpsStaircases: [GPSStaircase] = [
    GPSStaircase(
        id: "Test1",
        name: "초량 이바구길 168 계단",
        title: "역사가 오래된 초량의 이바구 길",
        description: "이바구길을 이바구를 떨며 걸어올라가 볼까나?",
        province: .gyeongnam,
        steps: 168,
        latitude: 35.117143,
        longitude: 129.035298,
        verificationLocation: "인증 장소 예시",
        reward: "국밥 육수"),
    GPSStaircase(
        id: "Busan168",
        name: "초량 이바구길 168 계단",
        title: "이바구 떨며 오르세요",
        description: "부산의 경사로를 몸소 느껴보자",
        province: .gyeongnam,
        steps: 168,
        latitude: 35.117143,
        longitude: 129.035298,
        verificationLocation: "계단 아래",
        reward: "국밥 육수"),
    GPSStaircase(
        id: "Busan40",
        name: "부산 40 계단",
        title: "피난민의 역사가 깃든",
        description: "원조 만남의 광장",
        province: .gyeongnam,
        steps: 40,
        latitude: 35.103911,
        longitude: 129.034629,
        verificationLocation: "조각상 앞",
        reward: "다대기"),
]
