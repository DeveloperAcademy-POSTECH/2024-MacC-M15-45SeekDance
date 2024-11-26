//
//  StepSquadWidget.swift
//  StepSquadWidget
//
//  Created by hanseoyoung on 11/25/24.
//

import WidgetKit
import SwiftUI

struct FlightsClimbedEntry: TimelineEntry {
    let date: Date
    let flightsClimbed: Int
    let progressImage: String
    let level: Int?
}

struct Provider: TimelineProvider {
    let healthDataManager = HealthDataManager()

    func placeholder(in context: Context) -> FlightsClimbedEntry {
        FlightsClimbedEntry(date: Date(), flightsClimbed: 0, progressImage: "Easy1", level: 1)
    }

    func getSnapshot(in context: Context, completion: @escaping (FlightsClimbedEntry) -> Void) {
        let entry = FlightsClimbedEntry(date: Date(), flightsClimbed: 0, progressImage: "Easy1", level: 1)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FlightsClimbedEntry>) -> Void) {
        healthDataManager.fetchFlightsClimbed { flightsClimbed, _ in
            let flights = Int(flightsClimbed ?? 0)

            if let result = calculateLevel(for: flights) {
                let gap = (result.level.maxStaircase + 1) - result.level.minStaircase
                let rest = flights - result.level.minStaircase
                let currentProgress = Int(Double(rest) / Double(gap) * 5 + 1)
                let progressImage = "\(result.level.difficulty.rawValue)\(currentProgress)"

                // 엔트리 생성
                let entry = FlightsClimbedEntry(
                    date: Date(),
                    flightsClimbed: flights,
                    progressImage: progressImage,
                    level: result.level.level
                )
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            } else {
                // 기본값
                let entry = FlightsClimbedEntry(
                    date: Date(),
                    flightsClimbed: flights,
                    progressImage: "Easy1",
                    level: nil
                )
                let timeline = Timeline(entries: [entry], policy: .atEnd)
                completion(timeline)
            }
        }
    }


}

struct FlightsClimbedWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack {
            VStack {
                // 진행 단계 이미지
                Image(entry.progressImage)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 60)
                    .padding(.bottom, 8)

                // 오른 층수
                Text("총 계단 수: \(entry.flightsClimbed)")
                    .font(.headline)
                    .foregroundColor(.white)
                    .padding(.bottom, 4)

                // 난이도와 레벨
                if let level = entry.level {
                    Text("난이도: \(currentDifficulty(for: entry.flightsClimbed))")
                        .font(.subheadline)
                        .foregroundColor(.white)
                        .padding(.bottom, 2)

                    Text("레벨 \(level)")
                        .font(.title2)
                        .bold()
                        .foregroundColor(.white)
                } else {
                    Text("레벨 없음")
                        .font(.title3)
                        .bold()
                        .foregroundColor(.white)
                }
            }
            .padding()
        }
        .containerBackground(Color.black, for: .widget)
    }

    // 난이도 계산 함수
    func currentDifficulty(for count: Int) -> String {
        switch count {
        case 0...29:
            return "Easy"
        case 30...179:
            return "Normal"
        case 180...359:
            return "Hard"
        case 360...959:
            return "Expert"
        case 960...:
            return "Impossible"
        default:
            return "Unknown"
        }
    }
}



struct FlightsClimbedWidget: Widget {
    let kind: String = "FlightsClimbedWidget"

    var body: some WidgetConfiguration {
        StaticConfiguration(kind: kind, provider: Provider()) { entry in
            FlightsClimbedWidgetEntryView(entry: entry)
        }
        .configurationDisplayName("계단 오른 수")
        .description("현재 오른 계단 수와 진행 단계를 보여줍니다.")
        .supportedFamilies([.systemSmall, .systemMedium, .systemLarge])
    }
}


extension View {
    func widgetBackground(_ backgroundView: some View) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                backgroundView
            }
        } else {
            return background(backgroundView)
        }
    }
}
