//
//  StairStepModel.swift
//  Gari
//
//  Created by hanseoyoung on 10/27/24.
//

import Foundation

class StairStepModel: Codable {
    var id = UUID()
    var stairType: String
    var stairStepDate: Date

    init(id: UUID = UUID(), stairType: String, stairStepDate: Date) {
        self.id = id
        self.stairType = stairType
        self.stairStepDate = stairStepDate
    }
}

var sampleStepModels: [StairStepModel] = []
