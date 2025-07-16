//
//  DateFormatter.swift
//  StepSquad
//
//  Created by Groo on 7/16/25.
//

import Foundation

public let dateFormatter: DateFormatter = {
    let formatter = DateFormatter()
    formatter.locale = Locale(identifier: "en_US_POSIX")
    formatter.dateFormat = "yyyy-MM-dd"
    return formatter
}()
