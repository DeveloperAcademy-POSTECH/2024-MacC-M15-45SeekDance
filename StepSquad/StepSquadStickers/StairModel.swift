//
//  StairModel.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/10/24.
//

import Foundation

class StairModel: Codable {
    var id: UUID
    var name: String
    var numberOfStairs: Int
    var serialNumber: String
    var isVisited: Bool
    var stickerName: String

    init(id: UUID = UUID(), name: String, numberOfStairs: Int, serialNumber: String, isVisited: Bool = false, stickerName: String = "") {
        self.id = id
        self.name = name
        self.numberOfStairs = numberOfStairs
        self.serialNumber = serialNumber
        self.isVisited = isVisited
        self.stickerName = stickerName
    }
}
