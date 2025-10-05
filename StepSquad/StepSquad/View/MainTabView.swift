//
//  MainTabView.swift
//  StepSquad
//
//  Created by Groo on 10/5/25.
//

import SwiftUI
import SwiftData

@available(iOS 18.0, *)
struct MainTabView: View {
    @State private var isResetViewPresented = false
    @State private var isShowNewBirdPresented = false
    @State private var isWifiAlertPresented = false
    @State var isResultViewPresented: Bool = false
    @State var isShowingNFCAlert: Bool = false
    @State var isMaterialSheetPresented: Bool = false
    @State var isCardFlipped: Bool = true
    @State var isLaunching: Bool = true
    @State private var isButtonEnabled: Bool = true
    @AppStorage("isShowingNewItem") private var isShowingNewItem = false
    
    @State var isResetCompleted: Bool = false
    
    @State private var completedLevels = CompletedLevels()
    @State private var collectedItems = CollectedItems()
    @AppStorage("lastElectricAchievementKwh") var lastElectricAchievementKwh = 0
    @State var userProfileImage: Image?
    @State private var gpsStaircaseWeeklyScore = GPSStaircaseWeeklyScore()
    
    var currentStatus: CurrentStatus = CurrentStatus() {
        didSet {
            saveCurrentStatus()
        }
    }
    var isHighestLevel: Bool {
        return currentStatus.currentLevel.level == 20
    }
    
    let gameCenterManager = GameCenterManager()
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context
    
    @Query(sort: [SortDescriptor(\StairStepModel.stairStepDate, order: .forward)]) var stairSteps: [StairStepModel]
    
    @ObservedObject var service = HealthKitService()
    @AppStorage("HealthKitAuthorized") var isHealthKitAuthorized: Bool = false
    @ObservedObject var climbingManager = ClimbingManager()
    
    var body: some View {
        TabView {
            TabView {
                Tab("home", systemImage: "house.fill") {
                    Text("home")
                }
                
                Tab("k-stairs", systemImage: "stairs") {
                    GPSStaircaseMainView(localPlayerImage: userProfileImage, localPlayerName: gameCenterManager.loadLocalPlayerName(), collectedItems: $collectedItems, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, gameCenterManager: gameCenterManager, isShowingNewItem: $isShowingNewItem)
                }
                
                Tab("my record", systemImage: "person.crop.rectangle.stack.fill") {
                    Text("records")
                }
                .badge("N")
                
                Tab("setting", systemImage: "gear") {
                    ExplainView()
                }
            }
        }
        .tint(.primaryColor)
    }
    
    // MARK: UserDefaults에 currentStatus 저장하기
    func saveCurrentStatus() {
        if let encodedData = try? JSONEncoder().encode(currentStatus) {
            UserDefaults.standard.setValue(encodedData, forKey: "currentStatus")
        }
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        MainTabView()
    } else {
        // Fallback on earlier versions
    }
}
