//
//  HealthDataManager.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/25/24.
//

import HealthKit

class HealthDataManager {
    private let healthStore = HKHealthStore()
    private let appGroupID = "group.com.stepSquad.widget"
    private let authorizationDateKey = "HealthKitAuthorizationDate"

    // 권한 요청 함수
    func requestAuthorization(completion: @escaping (Bool, Error?) -> Void) {
        guard HKHealthStore.isHealthDataAvailable() else {
            completion(false, nil)
            return
        }

        let stairClimbingType = HKObjectType.quantityType(forIdentifier: .flightsClimbed)!

        healthStore.requestAuthorization(toShare: nil, read: [stairClimbingType]) { success, error in
            if success {
                // 권한 승인 날짜 저장
                self.storeAuthorizationDateIfNeeded()
            }
            completion(success, error)
        }
    }

    // HealthKit에서 계단 오른 수 가져오기
    func fetchFlightsClimbed(completion: @escaping (Double?, Error?) -> Void) {
        // App Group UserDefaults에서 저장된 시작 날짜 가져오기
        let sharedDefaults = UserDefaults(suiteName: appGroupID)
        let startDate = sharedDefaults?.object(forKey: authorizationDateKey) as? Date ?? Date.distantPast

        guard let flightsClimbedType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else {
            completion(nil, nil)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)
        let query = HKStatisticsQuery(quantityType: flightsClimbedType, quantitySamplePredicate: predicate, options: .cumulativeSum) { _, result, error in
            if let sum = result?.sumQuantity() {
                let flightsClimbed = sum.doubleValue(for: HKUnit.count())
                completion(flightsClimbed, nil)
            } else {
                completion(nil, error)
            }
        }
        healthStore.execute(query)
    }

    // 권한 승인 날짜를 App Group UserDefaults에 저장
    private func storeAuthorizationDateIfNeeded() {
        let sharedDefaults = UserDefaults(suiteName: appGroupID)
        if sharedDefaults?.object(forKey: authorizationDateKey) == nil {
            let currentDate = Date()
            sharedDefaults?.set(currentDate, forKey: authorizationDateKey)
            print("HealthKit 권한 승인 날짜 저장: \(currentDate)")
        }
    }
}
