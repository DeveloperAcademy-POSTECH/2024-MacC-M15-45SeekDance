//
//  AppNameApp.swift
//  AppName
//
//  Created by hanseoyoung on 10/12/24.
//

import SwiftUI
import SwiftData

@main
struct StepSquadApp: App {
    
    // Healthkit 인증 코드가 있는 객체를 선언
    let service = HealthKitService()
    
    var stairStepContainer: ModelContainer = {
        let schema = Schema([StairStepModel.self])
        let modelConfiguration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        
        do {
            return try ModelContainer(for: schema, configurations: [modelConfiguration])
        } catch {
            fatalError("\(error)")
        }
    } ()
    
    var body: some Scene {
        WindowGroup {
            MainViewPhase3()
        }
        .modelContainer(stairStepContainer)
    }
    // MARK: - HealthKit 사용 권한을 요청하는 메서드
    init() {
//        setup()
        
        // MARK: - 앱 진입 시, 바로 실행
        service.getWeeklyStairDataAndSave()
        service.fetchAndSaveFlightsClimbedSinceAuthorization()
        
    }
    func setup() {
        service.configure()
    }
}

