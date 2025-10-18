//
//  MainTabView.swift
//  StepSquad
//
//  Created by Groo on 10/5/25.
//

import SwiftUI
import SwiftData
import GameKit

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
                Tab("k-stairs", systemImage: "stairs") {
                    GPSStaircaseMainView(localPlayerImage: userProfileImage, localPlayerName: GKLocalPlayer.local.displayName, collectedItems: $collectedItems, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, gameCenterManager: gameCenterManager, isShowingNewItem: $isShowingNewItem)
                }
                
                Tab("home", systemImage: "house.fill") {
                    TestHomeView(isShowingNewItem: $isShowingNewItem, isResetCompleted: $isResetCompleted, completedLevels: $completedLevels, collectedItems: $collectedItems, lastElectricAchievementKwh: $lastElectricAchievementKwh, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, currentStatus: currentStatus, gameCenterManager: gameCenterManager, healthManager: healthManager, isHealthKitAuthorized: $isHealthKitAuthorized, climbManager: climbingManager)
                }
                
                Tab("my record", systemImage: "person.crop.rectangle.stack.fill") {
                    ZStack {
                        EntryCertificateView(manager: climbingManager, userPlayerImage: userProfileImage, nickName: nil)
                            .rotation3DEffect(.degrees(isCardFlipped ? 0.001 : -90), axis: (x: 0.001, y: 1, z: 0.001))
                            .animation(isCardFlipped ? .linear.delay(0.35) : .linear, value: isCardFlipped)
                        DescendRecordView(climbManager: climbingManager)
                            .rotation3DEffect(.degrees(isCardFlipped ? 90 : 0.001), axis: (x: 0.001, y: 1, z: 0.001))
                            .animation(isCardFlipped ? .linear : .linear.delay(0.35), value: isCardFlipped)
                        Button("Show materials") {
                            isMaterialSheetPresented = true
                        }
                    }
                    .onTapGesture {
                        isCardFlipped.toggle()
                    }
                    .sheet(isPresented: $isMaterialSheetPresented) {
                        MaterialsView(isMaterialSheetPresented: $isMaterialSheetPresented, isShowingNewItem: $isShowingNewItem, completedLevels: completedLevels, collectedItems: collectedItems)
                    }
                }
                .badge("N")
                
                Tab("setting", systemImage: "gear") {
                    ExplainView()
                }
            }
        }
        .onAppear {
            healthManager.getWeeklyStairDataAndSave()
            healthManager.fetchAndSaveFlightsClimbedSinceAuthorization()
            healthManager.fetchAllFlightsClimbedData()
            if !GKLocalPlayer.local.isAuthenticated {
                gameCenterManager.authenticateUser()
            } else {
                Task {
                    userProfileImage = try await gameCenterManager.loadLocalPlayerImage()
                }
            }
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                withAnimation {
                    if !GKLocalPlayer.local.isAuthenticated {
                        gameCenterManager.authenticateUser()
                    } else if userProfileImage == nil {
                        Task {
                            userProfileImage = try await gameCenterManager.loadLocalPlayerImage()
                        }
                    }
                }
            }
        }
        .tint(.primaryColor)
    }
    
    // MARK: - 생성자
    init() {        // MARK: 사용자 게임 센터 인증
        gameCenterManager.authenticateUser()
        // MARK: 저장된 레벨 정보 불러오고 헬스킷 정보로 업데이트하기
        currentStatus = loadCurrentStatus()
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
