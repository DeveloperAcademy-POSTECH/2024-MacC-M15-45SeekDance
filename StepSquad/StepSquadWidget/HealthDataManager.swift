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

    // MARK: - 권한 요청 함수
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

    // MARK: - HealthKit에서 계단 오른 수 가져오기
    func fetchFlightsClimbed(completion: @escaping (Double?, Error?) -> Void) {
        // MARK: - App Group UserDefaults에서 저장된 시작 날짜 가져오기
        let sharedDefaults = UserDefaults(suiteName: appGroupID)
        let authorizationDate = sharedDefaults?.object(forKey: authorizationDateKey) as? Date ?? Date.distantPast

        let calendar = Calendar.current
           let startDate = calendar.startOfDay(for: authorizationDate)

        guard let flightsClimbedType = HKQuantityType.quantityType(forIdentifier: .flightsClimbed) else {
            completion(nil, nil)
            return
        }

        let predicate = HKQuery.predicateForSamples(withStart: startDate, end: Date(), options: .strictStartDate)

        let userEnteredPredicate = NSPredicate(format: "metadata.%K != YES", HKMetadataKeyWasUserEntered)

        let combinedPredicate = NSCompoundPredicate(andPredicateWithSubpredicates: [predicate, userEnteredPredicate])

        let query = HKStatisticsQuery(quantityType: flightsClimbedType, quantitySamplePredicate: combinedPredicate, options: .cumulativeSum) { _, result, error in
            if let sum = result?.sumQuantity() {
                let flightsClimbed = sum.doubleValue(for: HKUnit.count())
                completion(flightsClimbed, nil)
            } else {
                completion(nil, error)
            }
        }

        healthStore.execute(query)
    }


    // MARK: - 권한 승인 날짜를 App Group UserDefaults에 저장
    private func storeAuthorizationDateIfNeeded() {
        let sharedDefaults = UserDefaults(suiteName: appGroupID)
        if sharedDefaults?.object(forKey: authorizationDateKey) == nil {
            let currentDate = Date()
            sharedDefaults?.set(currentDate, forKey: authorizationDateKey)
            print("HealthKit 권한 승인 날짜 저장: \(currentDate)")
        }
    }
}
