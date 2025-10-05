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
    // MARK: 뷰 상태 관련 변수
    @State var isMaterialSheetPresented: Bool = false
    @State var isCardFlipped: Bool = true
    @State var isLaunching: Bool = true
    @AppStorage("isShowingNewItem") private var isShowingNewItem = false
    
    // MARK: 리셋 관련 변수
    @State var isResetCompleted: Bool = false
    
    // MARK: 기록 관련 데이터
    @State private var completedLevels = CompletedLevels()
    @State private var collectedItems = CollectedItems()
    @AppStorage("lastElectricAchievementKwh") var lastElectricAchievementKwh = 0
    @State private var gpsStaircaseWeeklyScore = GPSStaircaseWeeklyScore()
    var currentStatus: CurrentStatus = CurrentStatus()
    
    // MARK: game center 관련 데이터
    let gameCenterManager = GameCenterManager()
    @State var userProfileImage: Image?
    
    // MARK: healthkit 관련 데이터
    @ObservedObject var healthManager = HealthKitService()
    @AppStorage("HealthKitAuthorized") var isHealthKitAuthorized: Bool = false
    @ObservedObject var climbingManager = ClimbingManager()
    
    // TODO: - nfc 관련 콘텐츠 삭제
    @Query(sort: [SortDescriptor(\StairStepModel.stairStepDate, order: .forward)]) var stairSteps: [StairStepModel]
    @Environment(\.modelContext) var context
    
    var body: some View {
        TabView {
            TabView {
                Tab("home", systemImage: "house.fill") {
                    TestHomeView(isShowingNewItem: $isShowingNewItem, isResetCompleted: $isResetCompleted, completedLevels: completedLevels, collectedItems: collectedItems, lastElectricAchievementKwh: $lastElectricAchievementKwh, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, currentStatus: currentStatus, gameCenterManager: gameCenterManager, healthManager: healthManager, isHealthKitAuthorized: $isHealthKitAuthorized, climbManager: climbingManager)
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
        .onAppear {
            gameCenterManager.authenticateUser()
            healthManager.getWeeklyStairDataAndSave()
            healthManager.fetchAndSaveFlightsClimbedSinceAuthorization()
            healthManager.fetchAllFlightsClimbedData()
            Task {
                userProfileImage = await gameCenterManager.loadLocalPlayerImage() // TODO: 디버깅 필요
            }
        }
        .tint(.primaryColor)
    }
    
    // MARK: - 생성자
    init() {
        // MARK: 사용자 게임 센터 인증
        gameCenterManager.authenticateUser()
        // MARK: 저장된 레벨 정보 불러오고 헬스킷 정보로 업데이트하기
        currentStatus = loadCurrentStatus()
            userProfileImage = await gameCenterManager.loadLocalPlayerImage()
        //        printAll()
    }
    
    // MARK: UserDefaults에 저장한 currentStatus 반환하기
    func loadCurrentStatus() -> CurrentStatus {
        if let loadedData = UserDefaults.standard.data(forKey: "currentStatus") {
            if let decodedData = try? JSONDecoder().decode(CurrentStatus.self, from: loadedData) {
                return decodedData
            }
        }
        print("Error: UserDefaults에서 이전 currentStatus 불러오기 실패.")
        return CurrentStatus()
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        MainTabView()
    } else {
        // Fallback on earlier versions
    }
}
