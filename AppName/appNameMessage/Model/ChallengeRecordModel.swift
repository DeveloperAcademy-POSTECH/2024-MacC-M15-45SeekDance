//
//  ChallengeRecord.swift
//  AppName
//
//  Created by hanseoyoung on 10/15/24.
//

import Foundation

class ChallengeRecord: Codable {
    var recordId = UUID()
    let recordName: String
    let recordTarget: String
    let recordkWh: Double

    init(recordName: String, recordTarget: String, recordkWh: Double) {
        self.recordName = recordName
        self.recordTarget = recordTarget
        self.recordkWh = recordkWh
    }
}

let sampleRecords: [ChallengeRecord] = [
    ChallengeRecord(recordName: "Energy Saver", recordTarget: "나", recordkWh: 0.2),
    ChallengeRecord(recordName: "Green Energy", recordTarget: "Tanya", recordkWh: 0.3),
    ChallengeRecord(recordName: "Solar Power", recordTarget: "한서영", recordkWh: 0.4)
]
