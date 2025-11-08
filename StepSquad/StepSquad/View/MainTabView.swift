//
//  MainTabView.swift
//  StepSquad
//
//  Created by Groo on 10/5/25.
//

import SwiftUI
import SwiftData
import GameKit

struct MainTabView: View {
    // MARK: 뷰 상태 관련 변수
    @State var isMaterialSheetPresented: Bool = false
    @State var isCardFlipped: Bool = true
    @State var isLaunching: Bool = true
    @AppStorage("isShowingNewItem") private var isShowingNewItem = false
    @State var isRecordSheetPresented: Bool = false
    
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
    @State var userName: String = "계단 오르기를 실천하는 사람"
    
    // MARK: healthkit 관련 데이터
    @ObservedObject var healthManager = HealthKitService()
    @AppStorage("HealthKitAuthorized") var isHealthKitAuthorized: Bool = false
//    @ObservedObject var climbingManager = ClimbingManager()
    
    // TODO: - nfc 관련 콘텐츠 삭제
    @Query(sort: [SortDescriptor(\StairStepModel.stairStepDate, order: .forward)]) var stairSteps: [StairStepModel]
    @Environment(\.modelContext) var context
    
    // MARK: 시연용 오른 층수 데이터
    @State var testFlightsClimbed = 0
    
    var body: some View {
        if isLaunching {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLaunching = false
                    }
                }
        } else {
            TabView {
                HomeView(isShowingNewItem: $isShowingNewItem, isResetCompleted: $isResetCompleted, completedLevels: $completedLevels, collectedItems: $collectedItems, lastElectricAchievementKwh: $lastElectricAchievementKwh, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, currentStatus: currentStatus, gameCenterManager: gameCenterManager, healthManager: healthManager, isHealthKitAuthorized: $isHealthKitAuthorized, testFlightsClimbed: $testFlightsClimbed)
                    .tabItem {
                        Image(systemName: "house.fill")
                        Text("홈")
                    }
                
                GPSStaircaseMainView(localPlayerImage: userProfileImage, localPlayerName: userName, collectedItems: $collectedItems, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, gameCenterManager: gameCenterManager, isShowingNewItem: $isShowingNewItem)
                    .tabItem {
                        Image(systemName: "globe")
                        Text("전국의 계단")
                    }
                
                
                MyRecordView(userPlayerImage: userProfileImage, nickName: userName, isRecordSheetPresented: $isRecordSheetPresented, isShowingNewItem: $isShowingNewItem, completedLevels: completedLevels, collectedItems: collectedItems)
                    .badge(isShowingNewItem ? "N" : nil)
                    .tabItem {
                        Image(systemName: "person.text.rectangle.fill")
                        Text("나의 기록")
                    }
                
                ExplainView()
                    .tabItem {
                        Image(systemName: "gear")
                        Text("설정")
                    }
            }
            .onAppear {
//                healthManager.getWeeklyStairDataAndSave()
//                healthManager.fetchAndSaveFlightsClimbedSinceAuthorization()
//                healthManager.fetchAllFlightsClimbedData()
                if !GKLocalPlayer.local.isAuthenticated {
                    gameCenterManager.authenticateUser()
                } else {
                    Task {
                        userProfileImage = try await gameCenterManager.loadLocalPlayerImage()
                        userName = GKLocalPlayer.local.displayName
                    }
                }
                DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                    withAnimation {
                        if !GKLocalPlayer.local.isAuthenticated {
                            gameCenterManager.authenticateUser()
                        } else if userProfileImage == nil {
                            Task {
                                userProfileImage = try await gameCenterManager.loadLocalPlayerImage()
                                userName = GKLocalPlayer.local.displayName
                            }
                        }
                    }
                }
            }
            .sheet(isPresented: $isRecordSheetPresented) {
                VStack {
                    ZStack {
                        EntryCertificateView(userPlayerImage: userProfileImage, nickName: userName)
                            .rotation3DEffect(.degrees(isCardFlipped ? 0.001 : -90), axis: (x: 0.001, y: 1, z: 0.001))
                            .animation(isCardFlipped ? .linear.delay(0.35) : .linear, value: isCardFlipped)
                        DescendRecordView()
                            .rotation3DEffect(.degrees(isCardFlipped ? 90 : 0.001), axis: (x: 0.001, y: 1, z: 0.001))
                            .animation(isCardFlipped ? .linear : .linear.delay(0.35), value: isCardFlipped)
                    }
                    Button {
                        gameCenterManager.showFriendsList()
                        gameCenterManager.reportCompletedAchievement(achievementId: "clover")
                        if !collectedItems.isCollected(item: "Clover") { // 클로버를 처음 획득한다면
                            collectedItems.collectItem(item: "Clover", collectedDate: Date.now)
                            isShowingNewItem = true
                        }
                    } label: {
                        HStack() {
                            Spacer()
                            Label("계단사랑단인 친구 찾기", systemImage: "figure.socialdance")
                                .font(Font.custom("SF Pro", size: 17))
                                .foregroundColor(Color.white)
                            Spacer()
                        }
                        .padding(.vertical, 16)
                    }
                    .background(.green800, in: RoundedRectangle(cornerRadius: 12))
                    .padding(.top, 20)
                    .padding(.horizontal, 36)
                }
                .navigationTitle("입단증")
                .onTapGesture {
                    isCardFlipped.toggle()
                }
            }
            .tint(.green600)
        }
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
