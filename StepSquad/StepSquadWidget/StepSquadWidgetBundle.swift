//
//  StepSquadWidgetBundle.swift
//  StepSquadWidget
//
//  Created by heesohee on 11/20/24.
//

import WidgetKit
import SwiftUI

@main
struct StepSquadWidgetBundle: Widget {
//        StepWidgetControl()
        
        let kind: String = "StepSquadWidget"
        
        var body: some WidgetConfiguration {
            StaticConfiguration(kind: kind, provider: StairClimbProvider()) { entry in
                StepWidgetView(entry: entry)
            }
            .configurationDisplayName("계단 사랑단 위젯")
            .description("오늘 오른 계단 수를 보여줍니다.")
            .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
        }
    }
    
