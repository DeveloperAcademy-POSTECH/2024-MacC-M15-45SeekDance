//
//  ResetLogs.swift
//  StepSquad
//
//  Created by heesohee on 1/23/25.
//

import Foundation

struct ClimbingRecord: Identifiable, Codable {
    var id: UUID = UUID()              // 각 기록의 고유 ID
    let round: Int                     // 회차
    let descentTime: TimeInterval      // 하산에 걸린 시간 (초 단위)
    let descentDate: Date              // 하산 날짜
    let floorsClimbed: Int             // 오른 계단 층수
}

class ClimbingManager: ObservableObject {
    @Published private(set) var records: [ClimbingRecord] = [] // 기록 배열
    private var currentRound: Int = 1 // 회차 관리 변수
    
    private let userDefaultsKey = "ClimbingRecords" // 저장소 키

    init() {
        loadRecords() // 앱 실행 시 기록 불러오기
    }

    // 기록 추가
    func addRecord(descentTime: TimeInterval, descentDate: Date, floorsClimbed: Int) {
        let newRecord = ClimbingRecord(
            round: currentRound,
            descentTime: descentTime,
            descentDate: descentDate,
            floorsClimbed: floorsClimbed
        )
        records.append(newRecord)
        currentRound += 1 // 회차 증가
        saveRecords() // UserDefaults에 저장
    }

    // 기록 저장 (UserDefaults 사용)
    private func saveRecords() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(records) {
            UserDefaults.standard.set(encoded, forKey: userDefaultsKey)
        }
    }

    // 기록 불러오기
    private func loadRecords() {
        let decoder = JSONDecoder()
        if let savedData = UserDefaults.standard.data(forKey: userDefaultsKey),
           let decoded = try? decoder.decode([ClimbingRecord].self, from: savedData) {
            records = decoded
            currentRound = (records.last?.round ?? 0) + 1 // 마지막 회차 이후로 시작
        }
    }
}
