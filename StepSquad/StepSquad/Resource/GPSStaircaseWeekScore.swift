//
//  GPSStaircaseWeekScore.swift
//  StepSquad
//
//  Created by Groo on 7/14/25.
//

import Foundation

@Observable
class GPSStaircaseWeekScore: Codable {
    private var scores: [String: Int]
    private let savePath = URL.documentsDirectory.appending(path: "GPSStaircaseWeekScore")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([String: Int].self, from: data)
            scores = decoded
        } catch {
            scores = [String: Int]()
        }
    }
    
    // MARK: 특정 계단 인증 완료 후 이번주 점수에 더하기
    func addScore(score: Int, todayDate: Date = Date.now) {
        let formattedToday = todayDate.formatted(date: .numeric, time: .omitted)
        if let dayScore = scores[formattedToday] {
            scores[formattedToday]! += score // 오늘 기록이 있을 때
        } else {
            scores[formattedToday] = score // 오늘 기록이 없을 때
        }
    }
    
    // MARK: 이번주 점수 계산 후 반환
    func getWeeklyScore() -> Int {
        cleanOutdatedScores()
        var totalScore = 0
        for dayScore in scores {
            totalScore += dayScore.value
        }
        return totalScore
    }
    
    // MARK: 이번주가 아닌 점수 삭제
    func cleanOutdatedScores(todayDate: Date = Date.now) {
        let today = Calendar.current.component(.weekday, from: todayDate) // 오늘의 요일, 일요일 = 1 ~ 토요일 = 7
        // TODO: 토요일부터 오늘까지의 점수를 제외하고 항목 모두 삭제
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(levels)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save GPSStaircaseWeekScore.")
        }
    }
}
