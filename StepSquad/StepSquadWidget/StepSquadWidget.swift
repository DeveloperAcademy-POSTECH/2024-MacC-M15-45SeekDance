//
//  StepSquadWidget.swift
//  StepSquadWidget
//
//  Created by heesohee on 11/20/24.
//

//import WidgetKit
//import SwiftUI
//
//struct Provider: AppIntentTimelineProvider {
//    func placeholder(in context: Context) -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: ConfigurationAppIntent())
//    }
//
//    func snapshot(for configuration: ConfigurationAppIntent, in context: Context) async -> SimpleEntry {
//        SimpleEntry(date: Date(), configuration: configuration)
//    }
//
//    func timeline(for configuration: ConfigurationAppIntent, in context: Context) async -> Timeline<SimpleEntry> {
//        var entries: [SimpleEntry] = []
//
//        // Generate a timeline consisting of five entries an hour apart, starting from the current date.
//        let currentDate = Date()
//        for hourOffset in 0 ..< 5 {
//            let entryDate = Calendar.current.date(byAdding: .hour, value: hourOffset, to: currentDate)!
//            let entry = SimpleEntry(date: entryDate, configuration: configuration)
//            entries.append(entry)
//        }
//
//        return Timeline(entries: entries, policy: .atEnd)
//    }
//
////    func relevances() async -> WidgetRelevances<ConfigurationAppIntent> {
////        // Generate a list containing the contexts this widget is relevant in.
////    }
//}
//
//struct SimpleEntry: TimelineEntry {
//    let date: Date
//    let configuration: ConfigurationAppIntent
//}
//
//struct StepWidgetEntryView : View {
//    var entry: Provider.Entry
//
//    var body: some View {
//        VStack {
//            Text("Time:")
//            Text(entry.date, style: .time)
//
//            Text("Favorite Emoji:")
//            Text(entry.configuration.favoriteEmoji)
//        }
//    }
//}
//
//struct StepWidget: Widget {
//    let kind: String = "StepWidget"
//
//    var body: some WidgetConfiguration {
//        AppIntentConfiguration(kind: kind, intent: ConfigurationAppIntent.self, provider: Provider()) { entry in
//            StepWidgetEntryView(entry: entry)
//                .containerBackground(.fill.tertiary, for: .widget)
//        }
//    }
//}
//
//extension ConfigurationAppIntent {
//    fileprivate static var smiley: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "😀"
//        return intent
//    }
//
//    fileprivate static var starEyes: ConfigurationAppIntent {
//        let intent = ConfigurationAppIntent()
//        intent.favoriteEmoji = "🤩"
//        return intent
//    }
//}
//
//#Preview(as: .systemSmall) {
//    StepWidget()
//} timeline: {
//    SimpleEntry(date: .now, configuration: .smiley)
//    SimpleEntry(date: .now, configuration: .starEyes)
//}



import WidgetKit
import SwiftUI
import Intents
import os

let logger = Logger(subsystem: "com.example.yourapp", category: "widget")


// MARK: - 데이터 모델 (TimelineEntry 구현)
struct StairClimbEntry: TimelineEntry {
    let date: Date
    let TodayFlightsClimbed: Double
    let WeeklyFlightsClimbed: Double
}

// MARK: - TimelineProvider 구현
struct StairClimbProvider: TimelineProvider {
    func placeholder(in context: Context) -> StairClimbEntry {
        StairClimbEntry(date: Date(), TodayFlightsClimbed: 0.0, WeeklyFlightsClimbed: 0.0)
    }
    
    func getSnapshot(in context: Context, completion: @escaping (StairClimbEntry) -> Void) {
        let stairData = fetchStairData()
        let entry = StairClimbEntry(date: Date(), TodayFlightsClimbed: stairData.today, WeeklyFlightsClimbed: stairData.weekly)
        completion(entry)
    }
    
    func getTimeline(in context: Context, completion: @escaping (Timeline<StairClimbEntry>) -> Void) {
        var entries: [StairClimbEntry] = []
        let currentDate = Date()
        let stairData = fetchStairData()
        
        // 데이터로 새로운 Entry 생성
        let entry = StairClimbEntry(date: currentDate, TodayFlightsClimbed: stairData.today, WeeklyFlightsClimbed: stairData.weekly)
        entries.append(entry)
        
        // 15분 간격으로 타임라인 업데이트
        let timeline = Timeline(entries: entries, policy: .after(currentDate.addingTimeInterval(15 * 60)))
        completion(timeline)
    }
    
    // App Group에서 데이터 읽기
    private func fetchStairData() -> (today: Double, weekly: Double) {
        let userDefaults = UserDefaults(suiteName: "group.macmac.pratice.carot")
        
        guard let defaults = userDefaults else {
            print("App Group UserDefaults 접근 실패")
            return (0.0, 0.0) // 기본값 반환
        }
        
        // 오늘 계단 데이터
        let todayData = defaults.double(forKey: "TodayFlightsClimbed")
        
        // 주간 계단 데이터
        let weeklyData = defaults.double(forKey: "WeeklyFlightsClimbed")
        
        print("위젯에서 가져온 데이터 - 오늘: \(todayData), 주간: \(weeklyData)")
        return (todayData, weeklyData)
    }
}

// ---

import WidgetKit
import SwiftUI
import AppIntents

struct StepWidgetView: View {
    var entry: StairClimbProvider.Entry
    
    var body: some View {
        VStack(spacing: 16) {
            // Today's Climb Section
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: "figure.stairs")
                        .font(.title2)
                        .foregroundColor(.blue)
                    Text("오늘 오른 층계 수")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Text("\(entry.TodayFlightsClimbed, specifier: "%.0f") 층")
                    .font(.system(size: 36, weight: .bold, design: .rounded))
                    .foregroundColor(.blue)
            }
            .padding(.bottom, 8)
            
            Divider()
                .background(Color.gray.opacity(0.5))
            
            // Weekly Climb Section
            VStack(spacing: 4) {
                HStack {
                    Image(systemName: "calendar") // Weekly icon
                        .font(.title2)
                        .foregroundColor(.green)
                    Text("이번 주 (토-금) 계단 수")
                        .font(.headline)
                        .foregroundColor(.primary)
                }
                Text("\(entry.WeeklyFlightsClimbed, specifier: "%.0f") 층")
                    .font(.system(size: 24, weight: .medium, design: .rounded))
                    .foregroundColor(.green)
            }
        }
        .padding()
        .containerBackground(for: .widget) {
            Color(.systemBackground)
        }
        .cornerRadius(15) // Rounded corners
        //    .shadow(radius: 5) // Shadow for depth effect
    }
}
