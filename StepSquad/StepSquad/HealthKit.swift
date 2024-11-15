//
//  HealthKit.swift
//  StepSquad
//
//  Created by heesohee on 11/11/24.
//

import HealthKit
import WidgetKit
import Foundation
import SwiftUI


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
    
    @AppStorage("TodayFlightsClimbed", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var TodayFlightsClimbed: Double = 0.0
    @AppStorage("WeeklyFlightsClimbed", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var weeklyFlightsClimbed: Double = 0.0
    @AppStorage("TotalFlightsClimbedSinceAuthorization", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var TotalFlightsClimbedSinceAuthorization: Double = 0.0
    @AppStorage("LastFetchTime", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var LastFetchTime: String = ""
    
    
    // MARK: - HealthKit 사용 권한을 요청하는 메서드
    // 권한을 요청하고 받은 날짜를 기록하는 메서드
    func configure() {
        guard HKHealthStore.isHealthDataAvailable() else {
            print("HealthKit 데이터 사용 불가")
            return
        }
        
        let readTypes: Set = [HKObjectType.quantityType(forIdentifier: .flightsClimbed)!]
        
        healthStore.requestAuthorization(toShare: nil, read: readTypes) { [weak self] (success, error) in
            if let error = error {
                //                print("HealthKit 권한 요청 오류: \(error.localizedDescription)")
                return
            }
            
            if success {
                //                print("HealthKit 권한 허용됨")
                
                // 권한 요청 날짜를 기록하는 로직
                self?.storeAuthorizationDate()
                
                // 권한 허용 후에만 데이터를 가져오는 로직 실행
                self?.getWeeklyStairDataAndSave()
                self?.fetchAndSaveFlightsClimbedSinceAuthorization()
                
                
            } else {
                print("HealthKit 권한 거부됨")
            }
        }
    }
    
    // 권한 허용 날짜를 UserDefaults에 저장하는 함수
    private func storeAuthorizationDate() {
        let authorizationDateKey = "HealthKitAuthorizationDate"
        
        // UserDefaults에 날짜가 저장되어 있는지 확인
        if UserDefaults.standard.object(forKey: authorizationDateKey) == nil {
            let currentDate = Date()
            
            // 권한 허용 날짜 저장
            UserDefaults.standard.set(currentDate, forKey: authorizationDateKey)
            print("HealthKit 권한 허용 날짜를 \(currentDate)로 저장했습니다.")
        } else {
            // 이미 날짜가 저장된 경우, 기존 날짜를 사용
            if let savedDate = UserDefaults.standard.object(forKey: authorizationDateKey) as? Date {
                print("이전에 저장된 HealthKit 권한 허용 날짜: \(savedDate)")
            }
        }
    }
    
    
    
    // MARK: - 헬스킷 권한을 받은 당일 부터의 계단 오르기 데이터를 가져오는 기능
    func fetchAndSaveFlightsClimbedSinceAuthorization() {
        guard let authorizationDate = UserDefaults.standard.object(forKey: "HealthKitAuthorizationDate") as? Date else {
            print("권한 허용 날짜가 설정되지 않았습니다.")
            return
        }
        
        guard let flightsClimbedType = HKObjectType.quantityType(forIdentifier: .flightsClimbed) else {
            print("계단 오르기 데이터 타입을 찾을 수 없습니다.")
            return
        }
        
        // 권한 허용 날짜의 자정으로 시작 시점 설정
        let calendar = Calendar.current
        let startOfAuthorizationDate = calendar.startOfDay(for: authorizationDate)
        let predicate = HKQuery.predicateForSamples(withStart: startOfAuthorizationDate, end: Date(), options: [])
        
        // 데이터 소스 필터링을 위한 추가 조건
        let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()]) // 로컬 기기 데이터만 선택
        let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, devicePredicate])
        
        let query = HKStatisticsQuery(quantityType: flightsClimbedType, quantitySamplePredicate: compoundPredicate, options: .cumulativeSum) { _, result, error in
            if let error = error {
                print("계단 오르기 데이터 가져오기 오류: \(error.localizedDescription)")
                return
            }
            
            let totalFlightsClimbed = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
            
            // 날짜 포맷 설정
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.dateFormat = "a hh:mm, yyyy/MM/dd" // "오후 11:29, 2024/11/10" 형식
            
            // 현재 시각 포맷팅
            let currentFetchTime = Date()
            let formattedFetchTime = formatter.string(from: currentFetchTime)
            
            // UserDefaults에 계단 데이터와 함께 패치 시각 저장
            let appGroupDefaults = UserDefaults(suiteName: "group.macmac.pratice.carot")
            appGroupDefaults?.set(totalFlightsClimbed, forKey: "TotalFlightsClimbedSinceAuthorization")
            appGroupDefaults?.set(formattedFetchTime, forKey: "LastFetchTime") // 포맷된 패치 시각 저장
            
            // 패치 결과를 콘솔에 출력
            print("총 계단 오르기 수 \(totalFlightsClimbed)를 App Group UserDefaults에 저장했습니다.")
            print("총 계단 오르기 수 \(totalFlightsClimbed)를 저장했습니다. (패치 시각: \(formattedFetchTime))")
        }
        
        healthStore.execute(query)
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
                    
                    DispatchQueue.main.async {
                        self.TodayFlightsClimbed = totalFlightsClimbed
                    }
                    
                    WidgetCenter.shared.reloadAllTimelines()
                } else {
                    print("UserDefaults에 접근하는 데 실패했습니다.")
                }
                
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
            
            // 데이터 소스 필터링을 위한 추가 조건
            let devicePredicate = HKQuery.predicateForObjects(from: [HKDevice.local()]) // 로컬 기기 데이터만 선택
            let compoundPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, devicePredicate])
            
            let query = HKStatisticsQuery(quantityType: stairType, quantitySamplePredicate: compoundPredicate, options: .cumulativeSum) { _, result, error in
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
                //                print("주간 계단 수 (토-금): \(totalFlightsClimbed)를 UserDefaults에 저장했습니다.")
            }
            healthStore.execute(query)
        }
    }
}

