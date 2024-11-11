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
    
    // Healthkit 인증 코드가 있는 객체를 선언해줍니다.
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
            MainView2()
        }
        .modelContainer(stairStepContainer)
    }
    init() {
        setup()
        
    }
    func setup() { // 첫 실행 시 Healthkit 권한 설정이 되도록 호출합니다.
        service.configure()
    }
}

