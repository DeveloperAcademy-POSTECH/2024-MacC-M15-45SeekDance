//
//  StairStepModel.swift
//  Gari
//
//  Created by hanseoyoung on 10/27/24.
//

import SwiftData
import Foundation

@Model
class StairStepModel {
    @Attribute(.unique) var id: UUID
    var stairType: String
    var stairStepDate: Date
    var stairNum: Int

    init(id: UUID = UUID(), stairType: String, stairStepDate: Date, stairNum: Int) {
        self.id = id
        self.stairType = stairType
        self.stairStepDate = stairStepDate
        self.stairNum = stairNum
    }
}
