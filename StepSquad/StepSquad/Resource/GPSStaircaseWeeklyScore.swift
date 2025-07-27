//
//  GPSStaircaseWeekScore.swift
//  StepSquad
//
//  Created by Groo on 7/14/25.
//

import Foundation

@Observable
class GPSStaircaseWeeklyScore: Codable {
    private var scores: [String: Int]
    private let savePath = URL.documentsDirectory.appending(path: "GPSStaircaseWeeklyScore")
    
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode([String: Int].self, from: data)
            scores = decoded
        } catch {
            scores = [String: Int]()
        }
    }
    
    // MARK: 특정 계단 인증 완료 후 scores에 기록
    func addScore(score: Int, todayDate: Date = Date.now) {
        let formattedTodayString = dateFormatter.string(from: todayDate)
        print(formattedTodayString)
        if let dayScore = scores[formattedTodayString] {
            scores[formattedTodayString]! += score // 오늘 기록이 있을 때
        } else {
            scores[formattedTodayString] = score // 오늘 기록이 없을 때
        }
        save()
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
        let formattedTodayString = dateFormatter.string(from: todayDate)
        let today = Calendar.current.component(.weekday, from: todayDate) // 오늘의 요일, 일요일 = 1 ~ 토요일 = 7
        
        // TODO: 토요일(7)부터 오늘까지의 점수를 제외하고 항목 모두 삭제
        if (today == 7) {
            let todayScore = scores[formattedTodayString] ?? 0
            scores.removeAll()
            scores[formattedTodayString] = todayScore
        } else {
            for (key, _) in scores {
                guard let targetDate = dateFormatter.date(from: key) else {
                        scores.removeValue(forKey: key)
                    print("GPSStaircaseWeeklyScore: 잘못된 key(\(key)) 삭제")
                    return
                }
                if let gap = Calendar.current.dateComponents([.day], from: targetDate, to: todayDate).day {
                    if (gap > today) {
                        scores.removeValue(forKey: key)
                        print("deleted gap: \(gap)")
                    }
                }
            }
        }
        save()
    }
    
    func save() {
        do {
            let data = try JSONEncoder().encode(scores)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save GPSStaircaseWeekScore.")
        }
    }
}
