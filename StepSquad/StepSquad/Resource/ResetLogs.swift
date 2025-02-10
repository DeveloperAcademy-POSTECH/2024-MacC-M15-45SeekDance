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
    let descentDate: Date              // 하산 날짜
    let floorsClimbed: Float             // 오른 계단 층수
    let dDay: Int
}

class ClimbingManager: ObservableObject {
    @Published var records: [ClimbingRecord] = [] // 기록 배열
    private var currentRound: Int = 1 // 회차 관리 변수
    
    private let userDefaultsKey = "ClimbingRecords" // 저장소 키

    init() {
        loadRecords() // 앱 실행 시 기록 불러오기
    }

    // 기록 추가
    func addRecord(descentDate: Date, floorsClimbed: Float, dDay: Int) {
        let newRecord = ClimbingRecord(
            round: currentRound,
            descentDate: descentDate,
            floorsClimbed: floorsClimbed,
            dDay: dDay
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
    
    // 가장 최근의 기록을 반환하는 함수
    func getLatestRecord() -> ClimbingRecord? {
        return records.last
    }
//    let latestRecord = manager.getLatestRecord() {
//        Text("최근 회차 층수: \(latestRecord.floorsClimbed)")
//        Text("D-Day: \(latestRecord.dDay)")
}
