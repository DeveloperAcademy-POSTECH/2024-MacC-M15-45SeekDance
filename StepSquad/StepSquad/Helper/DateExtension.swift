//
//  DateExtension.swift
//  StepSquad
//
//  Created by Groo on 7/30/25.
//

import Foundation

extension Date: RawRepresentable {
    public var rawValue: String {
        self.timeIntervalSinceReferenceDate.description
    }
    
    public init?(rawValue: String) {
        self = Date(timeIntervalSinceReferenceDate: Double(rawValue) ?? 0.0)
    }
}
