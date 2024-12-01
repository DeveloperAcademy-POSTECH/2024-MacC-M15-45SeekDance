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
            
            // 주간 범위 설정 (이번 주 토요일부터 다음 금요일)
            var startOfWeek: Date?
            if calendar.component(.weekday, from: today) == 7 {
                // 오늘이 토요일인 경우, 오늘을 시작일로 설정
                startOfWeek = calendar.startOfDay(for: today)
            } else {
                // 오늘이 토요일이 아닌 경우, 지난 토요일을 시작일로 설정
                startOfWeek = calendar.nextDate(
                    after: today,
                    matching: DateComponents(weekday: 7),
                    matchingPolicy: .nextTime,
                    direction: .backward
                )
            }
            
            guard let startOfWeekDate = startOfWeek else {
                print("시작 날짜를 설정할 수 없습니다.")
                return
            }
            
            // 권한을 받은 날짜 가져오기
            guard let authorizationDate = UserDefaults.standard.object(forKey: "HealthKitAuthorizationDate") as? Date else {
                print("권한 허용 날짜가 설정되지 않았습니다.")
                return
            }
            
            // 권한을 받은 날짜와 주간 시작일 중 더 나중의 날짜를 사용
            let adjustedStartDate = max(startOfWeekDate, calendar.startOfDay(for: authorizationDate))
            
            // 종료일을 다음 금요일로 설정
            let endOfWeekDate = calendar.date(byAdding: .day, value: 6, to: startOfWeekDate) ?? today
            
            let predicate = HKQuery.predicateForSamples(withStart: adjustedStartDate, end: endOfWeekDate, options: [])
            
            // 사용자가 데이터를 주작했는지 아닌지 파악하는 부분 NSPredicate -> 메타 데이터 쿼리 조건, yes가 아닌 데이터만 가져 오겠다는 것.
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
                
                UserDefaults(suiteName: "group.macmac.pratice.carot")?.set(totalFlightsClimbed, forKey: "WeeklyFlightsClimbed")
                
                // 이 부분에서 바로 @AppStorage의 값을 업데이트
                DispatchQueue.main.async {
                    self.weeklyFlightsClimbed = totalFlightsClimbed
                }
                print("주간 계단 수 (토-금): \(totalFlightsClimbed)를 UserDefaults에 저장했습니다.")
            }
            healthStore.execute(query)
        }
    }

    // MARK: - 위젯 관련함수
    func migrateAuthorizationDateToSharedDefaults() {
        let authorizationDateKey = "HealthKitAuthorizationDate"
        let sharedDefaults = UserDefaults(suiteName: "group.com.stepSquad.widget")

        // 기본 UserDefaults에서 날짜 확인
        if let savedDate = UserDefaults.standard.object(forKey: authorizationDateKey) as? Date {
            // Shared UserDefaults로 값 저장
            sharedDefaults?.set(savedDate, forKey: "widgetData")
            //print("기존 HealthKit 권한 허용 날짜 \(savedDate)를 Shared Defaults로 옮겼습니다.")
        } else {
            print("기본 UserDefaults에 저장된 HealthKit 권한 허용 날짜가 없습니다.")
        }
    }

}

extension UserDefaults {
    static var shared: UserDefaults {
        let appGroupId = "group.com.stepSquad.widget"
        return UserDefaults(suiteName: appGroupId)!
    }
}
