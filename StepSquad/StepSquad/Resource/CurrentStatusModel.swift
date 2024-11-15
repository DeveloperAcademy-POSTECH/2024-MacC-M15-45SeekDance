//
//  CurrentStatusModel.swift
//  StepSquad
//
//  Created by Groo on 11/14/24.
//

import Foundation

class CurrentStatus: Codable {
    private var totalStaircase: Int // 누적 오른 층계
    var currentLevel: Level { // 현재 레벨
        for level in levels {
            if level.minStaircase <= totalStaircase && totalStaircase <= level.maxStaircase {
                return level
            }
        }
        return levels.first! // 에러 발생시 레벨 1으로 설정
    }
    var currentProgress: Int { // 현재 레벨의 현재 단계
        let gap = (currentLevel.maxStaircase + 1) - currentLevel.minStaircase
        let rest = totalStaircase - currentLevel.minStaircase
        return Int(Double(rest) / Double(gap) * 5 + 1)
    }
    var progressImage: String { // 현재 단계 이미지
        return "\(currentLevel.difficulty.rawValue)\(currentProgress)"
    }
    
    init(totalStaircase: Int = 0) {
        self.totalStaircase = totalStaircase
    }
    
    // MARK: totalStaircase 값 반환하기
    func getTotalStaircase() -> Int {
        return self.totalStaircase
    }
    
    // MARK: totalStaircase 업데이트하기
    func updateStaircase(_ totalStaircase: Int) {
        self.totalStaircase = totalStaircase
    }
}
