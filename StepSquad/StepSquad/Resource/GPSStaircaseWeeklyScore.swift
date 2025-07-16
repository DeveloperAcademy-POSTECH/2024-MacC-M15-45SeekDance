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
        print("addScore")
        print("before scores: \(scores)")
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeStyle = .none
        let formattedTodayString = dateFormatter.string(from: todayDate)
        print("todayDate: \(todayDate)")
        print("formattedTodayString: \(formattedTodayString)")
        
        if let dayScore = scores[formattedTodayString] {
            scores[formattedTodayString]! += score // 오늘 기록이 있을 때
        } else {
            scores[formattedTodayString] = score // 오늘 기록이 없을 때
        }
        
        print("after scores: \(scores)")
    }
    
    // MARK: 이번주 점수 계산 후 반환
    func getWeeklyScore() -> Int {
        print("getWeeklyScore")
        cleanOutdatedScores()
        var totalScore = 0
        for dayScore in scores {
            totalScore += dayScore.value
        }
        return totalScore
    }
    
    // MARK: 이번주가 아닌 점수 삭제
    func cleanOutdatedScores(todayDate: Date = Date.now) {
        print("cleanOutdatedScores")
        let dateFormatter: DateFormatter = .init()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        dateFormatter.timeStyle = .none
        let formattedTodayString = dateFormatter.string(from: todayDate)
        let today = Calendar.current.component(.weekday, from: todayDate) // 오늘의 요일, 일요일 = 1 ~ 토요일 = 7
        print("today: \(today)")
        
        // TODO: 토요일부터 오늘까지의 점수를 제외하고 항목 모두 삭제
        if (today == 7) {
            let todayScore = scores[formattedTodayString] ?? 0
            scores.removeAll()
            scores[formattedTodayString] = todayScore
        } else {
            for (key, _) in scores {
                guard let targetDate = dateFormatter.date(from: key) else {
                    print("GPSStaircaseWeekScore: targetDate 설정이 잘못되었습니다.")
                    return
                }
                if let gap = Calendar.current.dateComponents([.day], from: targetDate, to: todayDate).day {
                    if (gap > today) {
                        scores.removeValue(forKey: key)
                        print("deleted gap: \(gap)")
                    }
                }
            }
            print("scores: \(scores)")
        }
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
