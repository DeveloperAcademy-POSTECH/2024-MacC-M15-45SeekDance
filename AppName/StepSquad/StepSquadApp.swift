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
            MainView()
        }
        .modelContainer(stairStepContainer)
    }
}
