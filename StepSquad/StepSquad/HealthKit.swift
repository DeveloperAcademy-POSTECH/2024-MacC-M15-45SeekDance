//
//  HealthKit.swift
//  StepSquad
//
//  Created by heesohee on 11/11/24.
//

import HealthKit
import WidgetKit
import Foundation


// 계단 오름 샘플 데이터를 저장할 구조체
struct StairClimbSample: Identifiable {
    let id = UUID()
    let flightsClimbed: Double // 오른 층 수
    let startDate: Date // 계단 오름 시작 시각
    let endDate: Date // 계단 오름 종료 시각
    let source: String // 데이터 수집 장비 이름 (iPhone, Apple Watch 등)
}

// HealthKitService 클래스 내에 추가
class HealthKitService: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    // 계단 오름 샘플 데이터를 저장할 배열
    @Published var stairClimbData = [StairClimbSample]()
    
    // 헬스킷에서 데이터가 변경되면 뷰에 업데이트 되도록 @Published로 선언
    @Published var TodayFlightsClimbed: Double = 0.0
    @Published var weeklyFlightsClimbed: Double = 0.0
    
    // HealthKit 사용 권한을 요청하는 메서드
    func configure() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit 데이터 사용 불가")
            return
            
        }
        
        
        // 읽기 권한에 대해 설정
        let readTypes: Set = [HKObjectType.quantityType(forIdentifier: .flightsClimbed)!]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { (success, error) in
            if let error = error {
                print("HealthKit 권한 요청 오류: \(error.localizedDescription)")
            } else {
                print(success ? "HealthKit 권한 허용됨" : "HealthKit 권한 거부됨")
            }
        }
    }
    
    // MARK: - 오늘 계단 오르기 수를 호출 및 앱스토리지 저장하는 함수
    func getTodayStairDataAndSave() {
        if let stairType = HKObjectType.quantityType(forIdentifier: .flightsClimbed) {
            let calendar = Calendar.current
            let endDate = Date()
            let startDate = calendar.startOfDay(for: endDate)
            let predicate = HKQuery.predicateForSamples(withStart: startDate, end: endDate, options: [])
            let sortDescriptor = NSSortDescriptor(key: HKSampleSortIdentifierEndDate, ascending: false)
            
            let query = HKSampleQuery(sampleType: stairType, predicate: predicate, limit: 100, sortDescriptors: [sortDescriptor]) { (query, result, error) in
                if let error = error {
                    print("오늘의 계단 오르기 데이터 가져오기 오류: \(error.localizedDescription)")
                    return
                }
                
                guard let result = result, !result.isEmpty else {
                    print("오늘의 계단 오르기 데이터가 없습니다.")
                    return
                }
                
                var totalFlightsClimbed: Double = 0.0
                
                for item in result {
                    if let sample = item as? HKQuantitySample {
                        let flights = sample.quantity.doubleValue(for: HKUnit.count())
                        totalFlightsClimbed += flights
                    }
                }
                
                if let userDefaults = UserDefaults(suiteName: "group.macmac.pratice.carot") {
                    userDefaults.set(totalFlightsClimbed, forKey: "TodayFlightsClimbed")
                    print("오늘 오른 계단 수 \(totalFlightsClimbed)를 App Group UserDefaults에 저장했습니다.")
                    // UI 업데이트를 위해 @Published 변수도 업데이트
                    DispatchQueue.main.async {
                        self.TodayFlightsClimbed = totalFlightsClimbed
                    }
                    
                    WidgetCenter.shared.reloadAllTimelines()
                } else {
                    print("UserDefaults에 접근하는 데 실패했습니다.")
                }
                
                // 데이터 업데이트 후, Published 변수를 통해 UI와 연동
                DispatchQueue.main.async {
                    self.stairClimbData = result.compactMap { item in
                        guard let sample = item as? HKQuantitySample else { return nil }
                        let flights = sample.quantity.doubleValue(for: HKUnit.count())
                        let startDate = sample.startDate
                        let endDate = sample.endDate
                        let sourceName = sample.sourceRevision.source.name
                        return StairClimbSample(flightsClimbed: flights, startDate: startDate, endDate: endDate, source: sourceName)
                    }
                }
            }
            healthStore.execute(query)
        } else {
            print("계단 오르기 데이터 타입을 찾을 수 없습니다.")
        }
    }
    
    
    // MARK: - UserDefaults에 토-다음 금요일을 한주로 일주일 치 계단 오르기 수를 호출 및 앱스토리지에 저장하는 함수
    func getWeeklyStairDataAndSave() {
        if let stairType = HKObjectType.quantityType(forIdentifier: .flightsClimbed) {
            let calendar = Calendar.current
            let today = Date()
            
            // 주간 범위 설정 (이번 주 토요일부터 다음 금요일)
            var startOfWeek: Date?
            if calendar.component(.weekday, from: today) == 7 {
                // 오늘이 토요일인 경우, 오늘을 시작일로 설정
                startOfWeek = calendar.startOfDay(for: today)
            } else {
                // 오늘이 토요일이 아닌 경우, 지난 토요일을 시작일로 설정
                startOfWeek = calendar.nextDate(after: today, matching: DateComponents(weekday: 7), matchingPolicy: .nextTime, direction: .backward)
            }
            
            guard let startOfWeekDate = startOfWeek else {
                print("시작 날짜를 설정할 수 없습니다.")
                return
            }
            
            //  종료일을 다음 금요일로 설정
            let endOfWeekDate = calendar.date(byAdding: .day, value: 6, to: startOfWeekDate) ?? today
            
            let predicate = HKQuery.predicateForSamples(withStart: startOfWeekDate, end: endOfWeekDate, options: [])
            let query = HKStatisticsQuery(quantityType: stairType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
                guard error == nil else {
                    print("주간 계단 데이터 가져오기 오류: \(error!.localizedDescription)")
                    return
                }
                
                let totalFlightsClimbed = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
                UserDefaults(suiteName: "group.macmac.pratice.carot")?.set(totalFlightsClimbed, forKey: "WeeklyFlightsClimbed")
                // 이 부분에서 바로 @AppStorage의 값을 업데이트합니다.
                DispatchQueue.main.async {
                    self.weeklyFlightsClimbed = totalFlightsClimbed
                }
                print("주간 계단 수 (토-금): \(totalFlightsClimbed)를 UserDefaults에 저장했습니다.")
            }
            healthStore.execute(query)
        }
    }
}

