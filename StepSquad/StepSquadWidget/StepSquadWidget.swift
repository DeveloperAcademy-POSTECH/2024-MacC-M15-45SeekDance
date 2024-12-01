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
    let progressPercentage: Double
    let flightsToNextLevel: Int
    let level: Int?
    let isHealthDataAvailable: Bool
}

struct Provider: TimelineProvider {
    let healthDataManager = HealthDataManager()

    func placeholder(in context: Context) -> FlightsClimbedEntry {
        FlightsClimbedEntry(date: Date(), flightsClimbed: 0, progressPercentage: 0.0, flightsToNextLevel: 5, level: nil, isHealthDataAvailable: true)
    }

    func getSnapshot(in context: Context, completion: @escaping (FlightsClimbedEntry) -> Void) {
        let entry = FlightsClimbedEntry(date: Date(), flightsClimbed: 221, progressPercentage: 0.7, flightsToNextLevel: 10, level: 9, isHealthDataAvailable: true)
        completion(entry)
    }

    func getTimeline(in context: Context, completion: @escaping (Timeline<FlightsClimbedEntry>) -> Void) {
        healthDataManager.fetchAllFlightsClimbedData { isHealthDataAvailable in
            healthDataManager.fetchFlightsClimbed { flightsClimbed, error in
                guard error == nil else {
                    let entry = FlightsClimbedEntry(
                        date: Date(),
                        flightsClimbed: 0,
                        progressPercentage: 0.0,
                        flightsToNextLevel: 0,
                        level: 1,
                        isHealthDataAvailable: false
                    )
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                    return
                }

                let flights = Int(flightsClimbed ?? 0)

                if !isHealthDataAvailable {
                    let entry = FlightsClimbedEntry(
                        date: Date(),
                        flightsClimbed: 0,
                        progressPercentage: 0.0,
                        flightsToNextLevel: 0,
                        level: 1,
                        isHealthDataAvailable: false
                    )
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                    return
                }

                if let levelData = LevelManager.calculateLevel(for: flights) {
                    let totalGap = (levelData.maxStaircase + 1) - levelData.minStaircase
                    let progressSteps = flights - levelData.minStaircase
                    let progressPercentage = levelData.level < 19 ? Double(progressSteps) / Double(totalGap) : 1.0
                    let flightsToNextLevel = (levelData.maxStaircase + 1) - flights

                    let entry = FlightsClimbedEntry(
                        date: Date(),
                        flightsClimbed: flights,
                        progressPercentage: progressPercentage,
                        flightsToNextLevel: max(flightsToNextLevel, 0),
                        level: levelData.level,
                        isHealthDataAvailable: true
                    )
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                } else {
                    let entry = FlightsClimbedEntry(
                        date: Date(),
                        flightsClimbed: flights,
                        progressPercentage: 0.0,
                        flightsToNextLevel: 0,
                        level: 1,
                        isHealthDataAvailable: true
                    )
                    let timeline = Timeline(entries: [entry], policy: .atEnd)
                    completion(timeline)
                }
            }
        }
    }
}

struct FlightsClimbedWidgetEntryView: View {
    var entry: Provider.Entry

    var body: some View {
        ZStack(alignment: .leading) {
            if entry.isHealthDataAvailable {
                VStack(alignment: .leading, spacing: 0) {
                    Text("총 오른 층수")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(red: 0.3, green: 0.43, blue: 0.22))

                    Text("\(entry.flightsClimbed)")
                        .font(.system(size: 40, weight: .bold))
                        .foregroundColor(Color(red: 0.95, green: 0.98, blue: 0.94))
                        .padding(.bottom, 9)

                    if let level = entry.level {
                        Text("레벨 \(level)")
                            .font(Font.custom("SF Pro", size: 12))
                            .foregroundColor(Color(red: 0.3, green: 0.43, blue: 0.22))

                        ProgressView(value: entry.progressPercentage)
                            .tint(Color(red: 0.3, green: 0.43, blue: 0.22))
                            .padding(.vertical, 8)

                        if level >= 19 {
                            Text("계단 오르기 마스터!")
                                .font(Font.custom("SF Pro", size: 11))
                                .kerning(0.06)
                                .foregroundColor(Color(red: 0.3, green: 0.43, blue: 0.22))
                        } else {
                            Text("\(entry.flightsToNextLevel)층 오르면 레벨 업")
                                .font(Font.custom("SF Pro", size: 11))
                                .kerning(0.06)
                                .foregroundColor(Color(red: 0.3, green: 0.43, blue: 0.22))
                        }
                    } else {
                        Text("레벨 없음")
                            .font(.title3)
                            .bold()
                            .foregroundColor(.white)
                    }
                }
                .padding(.vertical, 14)
                .padding(.horizontal, 12)
            } else {
                VStack(alignment: .leading) {
                    Text("데이터 연동이\n필요해요")
                        .font(.system(size: 13, weight: .bold))
                        .foregroundColor(Color(red: 0.3, green: 0.43, blue: 0.22))

                    Image("WidgetImage")
                        .resizable()
                        .scaledToFit()
                        .padding(.top, 8)
                        .padding(.trailing, 7)
                }
            }
        }
        .widgetBackground(Color(red: 0.55, green: 0.78, blue: 0.4))
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
    func widgetBackground(_ color: Color) -> some View {
        if #available(iOSApplicationExtension 17.0, *) {
            return containerBackground(for: .widget) {
                color
            }
        } else {
            return background(color)
        }
    }
}
