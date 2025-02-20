//
//  StaircaseModel.swift
//  StepSquad
//
//  Created by Groo on 2/20/25.
//

import Foundation

class Staircase: Codable {
    let id: String // TODO: id는 영문명으로 계단 이미지도 id와 동일하게 설정
    let name: String
    let title: String
    let steps: Int
    let locationX: Int // TODO: 인증방식에 따라 Location으로 변경
    let locationY: Int
    let description: String
    let reward: String // TODO: 리워드 이미지 파일명은 "[id]_reward"로 설정
    let achievementId: String
    
    init(id: String, name: String, title: String, steps: Int, location: (Int, Int), description: String, reward: String, achievementId: String) {
        self.id = id
        self.name = name
        self.title = title
        self.steps = steps
        self.locationX = location.0
        self.locationY = location.1
        self.description = description
        self.reward = reward
        self.achievementId = achievementId
    }
}
