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



// MARK: - Calendar Extension
extension Calendar {
    func isDateInThisWeek(_ date: Date) -> Bool {
        guard let startOfWeek = self.date(from: self.dateComponents([.yearForWeekOfYear, .weekOfYear], from: Date())) else {
            return false
        }
        let endOfWeek = self.date(byAdding: .day, value: 7, to: startOfWeek)!
        return (startOfWeek...endOfWeek).contains(date)
    }
}

// HealthKitService 클래스 내에 추가
class HealthKitService: ObservableObject {
    
    let healthStore = HKHealthStore()
    
    @AppStorage("TodayFlightsClimbed", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var TodayFlightsClimbed: Double = 0.0
    @AppStorage("WeeklyFlightsClimbed", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var weeklyFlightsClimbed: Double = 0.0
    @AppStorage("TotalFlightsClimbedSinceAuthorization", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var TotalFlightsClimbedSinceAuthorization: Double = 0.0
    @AppStorage("LastFetchTime", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var LastFetchTime: String = ""
    @AppStorage("authorizationDateKey", store: UserDefaults(suiteName: "group.macmac.pratice.carot")) var authorizationDateKey: String = ""
    @AppStorage("HealthKitAuthorized") var isHealthKitAuthorized: Bool = false // AppStorage로 데이터 관리
    
    
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
                print("HealthKit 권한 요청 오류: \(error.localizedDescription)")
                return
            }
            
            if success {
                //   print("HealthKit 권한 허용됨")
                //                self?.isHealthKitAuthorized = true
                //                UserDefaults.standard.set(true, forKey: "HealthKitAuthorized")
                self?.fetchAllFlightsClimbedData()
                // 권한 요청 날짜를 기록하는 로직
                self?.storeAuthorizationDate()
                
                // 권한 허용 후에만 데이터를 가져오는 로직 실행
                self?.getWeeklyStairDataAndSave()
                self?.fetchAndSaveFlightsClimbedSinceAuthorization()
                
            } else {
                self?.isHealthKitAuthorized = false
                //                self?.isHealthKitAuthorized = false
                print("HealthKit 권한 거부됨")
                //                UserDefaults.standard.set(false, forKey: "HealthKitAuthorized")
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
                //                print("이전에 저장된 HealthKit 권한 허용 날짜: \(savedDate)")
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
        // 사용자가 데이터를 주작했는지 아닌지 파악하는 부분 NSPredicate -> 메타 데이터 쿼리 조건, yes가 아닌 데이터만 가져 오겠다는 것.
        let userEnteredPredicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)
        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, userEnteredPredicate])
        
        
        let query = HKStatisticsQuery(quantityType: flightsClimbedType, quantitySamplePredicate: combinedPredicate, options: .cumulativeSum) { _, result, error in
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
            //            print("총 계단 오르기 수 \(totalFlightsClimbed)를 저장했습니다. (패치 시각: \(formattedFetchTime))")
        }
        
        healthStore.execute(query)
    }
    
    func fetchAllFlightsClimbedData() {
        guard let flightsClimbedType = HKObjectType.quantityType(forIdentifier: .flightsClimbed) else {
            print("계단 오르기 데이터 타입을 찾을 수 없습니다.")
            return
        }
        
        // 전체 데이터를 가져오기 위해 시작일과 종료일을 nil로 설정
        let predicate = HKQuery.predicateForSamples(withStart: nil, end: nil, options: [])
        
        // 사용자가 입력한 데이터 제외 조건 추가 (선택 사항)
        let userEnteredPredicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)
        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, userEnteredPredicate])
        
        let query = HKStatisticsQuery(quantityType: flightsClimbedType, quantitySamplePredicate: combinedPredicate, options: .cumulativeSum) { [weak self] _, result, error in
            if let error = error {
                print("전체 계단 오르기 데이터 가져오기 오류: \(error.localizedDescription)")
                DispatchQueue.main.async {
                    self?.isHealthKitAuthorized = false
                }
                return
            }
            
            let totalFlightsClimbed = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
            
            DispatchQueue.main.async {
                // 데이터 값에 따라 isHealthKitAuthorized 업데이트
                if totalFlightsClimbed > 0 {
                    self?.isHealthKitAuthorized = true
                } else {
                    self?.isHealthKitAuthorized = false
                }
                
                print("전체 계단 오르기 데이터: \(totalFlightsClimbed)")
            }
        }
        
        healthStore.execute(query)
    }
    
    
    
    // MARK: - UserDefaults에 토-다음 금요일을 한주로 일주일 치 계단 오르기 수를 호출 및 앱스토리지에 저장하는 함수
    func getWeeklyStairDataAndSave() {
        if let stairType = HKObjectType.quantityType(forIdentifier: .flightsClimbed) {
            let calendar = Calendar.current
            let today = Date()
            
            // 시작일 계산: 오늘이 토요일이면 오늘, 아니면 지난 토요일
            let startOfWeekDate: Date
            if calendar.component(.weekday, from: today) == 7 {
                // 오늘이 토요일
                startOfWeekDate = calendar.startOfDay(for: today)
            } else {
                // 지난 토요일 계산
                startOfWeekDate = calendar.nextDate(
                    after: today,
                    matching: DateComponents(weekday: 7),
                    matchingPolicy: .nextTime,
                    direction: .backward
                ) ?? today
            }
            
            // 종료일: 현재 시간
            let endOfWeekDate = today
            
            // 권한을 받은 날짜 가져오기
            let authorizationDate = UserDefaults.standard.object(forKey: "HealthKitAuthorizationDate") as? Date
            
            // 시작일 계산
            let adjustedStartDate: Date
            if let authorizationDate = authorizationDate, calendar.isDateInThisWeek(authorizationDate) {
                // 첫 주에는 권한 날짜와 토요일 중 더 늦은 날짜를 사용
                adjustedStartDate = max(startOfWeekDate, calendar.startOfDay(for: authorizationDate))
            } else {
                // 이후 주부터는 항상 토요일을 기준으로
                adjustedStartDate = startOfWeekDate
            }
            
            let predicate = HKQuery.predicateForSamples(withStart: adjustedStartDate, end: endOfWeekDate, options: [])
            
            // 사용자가 데이터를 주작했는지 확인 (메타데이터 조건 추가)
            let userEnteredPredicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)
            let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, userEnteredPredicate])
            
            let query = HKStatisticsQuery(quantityType: stairType, quantitySamplePredicate: combinedPredicate, options: .cumulativeSum) { _, result, error in
                guard error == nil else {
                    print("주간 계단 데이터 가져오기 오류: \(error!.localizedDescription)")
                    return
                }
                
                var totalFlightsClimbed = result?.sumQuantity()?.doubleValue(for: HKUnit.count()) ?? 0.0
                
                // 데이터가 없으면 0을 반환
                if totalFlightsClimbed == 0.0 {
                    totalFlightsClimbed = 0.0
                    print("이번 주 계단 데이터가 없습니다. 0을 반환합니다.")
                }
                
                // UserDefaults에 주간 데이터 저장 (App Group 사용)
                UserDefaults(suiteName: "group.macmac.pratice.carot")?.set(totalFlightsClimbed, forKey: "WeeklyFlightsClimbed")
                
                // @AppStorage 값 업데이트
                DispatchQueue.main.async {
                    self.weeklyFlightsClimbed = totalFlightsClimbed
                }
                print("Authorization Date: \(String(describing: authorizationDate)), Start: \(adjustedStartDate), End: \(endOfWeekDate)")

                print("주간 계단 수 (토요일 시작): \(totalFlightsClimbed)를 UserDefaults에 저장했습니다.")
            }
            healthStore.execute(query)
        }
    }
}

