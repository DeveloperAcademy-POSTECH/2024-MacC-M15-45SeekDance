//
//  StairModel.swift
//  Gari
//
//  Created by hanseoyoung on 10/27/24.
//

import Foundation

class StairModel: Codable {
    var id: UUID
    var name: String
    var numberOfStairs: Int
    var serialNumber: String

    init(id: UUID = UUID(), name: String, numberOfStairs: Int, serialNumber: String) {
        self.id = id
        self.name = name
        self.numberOfStairs = numberOfStairs
        self.serialNumber = serialNumber
    }
}

// MARK: - NFC 태그를 설치한 계단들

let gariStairs: [StairModel] = [
    StairModel(name: "78계단", numberOfStairs: 78, serialNumber: "04d1c489230289"),
    StairModel(name: "C5 5층에서 6층", numberOfStairs: 25, serialNumber: "0443a4eb210289"),
    StairModel(name: "C5 1층에서 5층", numberOfStairs: 114, serialNumber: "0463e4e1200289"),
]
