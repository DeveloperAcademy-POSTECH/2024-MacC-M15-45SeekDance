//
//  TestHomeView.swift
//  StepSquad
//
//  Created by Groo on 10/5/25.
//

import SwiftUI

struct HomeView: View {
    // MARK: 뷰 상태 관련 변수
    // TODO: 탭 뷰 위에 꽉 채울 수 있나
    @State private var isResetViewPresented = false
    @State private var isShowNewBirdPresented = false
    @State private var isWifiAlertPresented = false
    var isHighestLevel: Bool { // TODO: 여기에만 있으면 됨
        return currentStatus.currentLevel.level == 20
    }
    
    //    @AppStorage("isShowingNewItem") private var isShowingNewItem = false // TODO: 전달받아야 함
    @Binding var isShowingNewItem: Bool
    //    @Environment(\.scenePhase) private var scenePhase // TODO: 필요없을 듯
    
    // TODO: 다른 탭으로 뺌
    //    @State var isMaterialSheetPresented: Bool = false
    //    @State var isCardFlipped: Bool = true
    //    @State var isLaunching: Bool = true
    
    // MARK: 리셋 관련 변수
    // TODO: 탭 뷰 위에 꽉 채울 수 있나
    //    @State var isResetCompleted: Bool = false // TODO: 전달받아야 함
    @Binding var isResetCompleted: Bool
    
    // MARK: 기록 관련 데이터
    //    @State private var completedLevels = CompletedLevels() // TODO: 필요없을 듯
    @Binding var completedLevels: CompletedLevels
    //    @State private var collectedItems = CollectedItems() // TODO: 필요없을 듯
    @Binding var collectedItems: CollectedItems
    //    @AppStorage("lastElectricAchievementKwh") var lastElectricAchievementKwh = 0 // TODO: 필요없을 듯
    @Binding var lastElectricAchievementKwh: Int
    //    @State private var gpsStaircaseWeeklyScore = GPSStaircaseWeeklyScore() 탭 뷰면 충분할 듯
    @Binding var gpsStaircaseWeeklyScore: GPSStaircaseWeeklyScore
    //    var currentStatus: CurrentStatus = CurrentStatus() // TODO: 전달받아야 함
    var currentStatus: CurrentStatus
    
    // MARK: game center 관련 데이터
    //    let gameCenterManager = GameCenterManager() // TODO: 전달받아야 함
    let gameCenterManager: GameCenterManager
    //    @State var userProfileImage: Image? // TODO: 필요없을 듯
    
    // MARK: healthkit 관련 데이터
    //    @ObservedObject var service = HealthKitService()
    @ObservedObject var healthManager: HealthKitService
    //    @AppStorage("HealthKitAuthorized") var isHealthKitAuthorized: Bool = false // TODO: 전달받아야 함
    @Binding var isHealthKitAuthorized: Bool
    //    @ObservedObject var climbingManager = ClimbingManager()  // TODO: 리셋 위해서 전달받아야 함
    @ObservedObject var climbManager: ClimbingManager
    
    var body: some View {
        ZStack() {
            Color.backgroundColor
            
            VStack(spacing: 0) {
                HStack(spacing: 0) {
                    Text(healthManager.LastFetchTime.isEmpty == false
                         ? "당겨서 계단 정보 불러오기\n계단 업데이트: \(healthManager.LastFetchTime)"
                         : "아직 계단을 안 오르셨군요!\n계단을 오르고 10분 뒤 다시 당겨보세요!")
                    .font(.footnote)
                    .foregroundColor(Color(hex: 0x808080))
                    .multilineTextAlignment(.center)
                }
                .padding(.top, 72)
                .padding(.bottom, 4)
                .padding(.horizontal, 36)
                
                ScrollView {
                    VStack(spacing: 0) {
                        if isHealthKitAuthorized {
                            LevelUpView
                        } else {
                            GetHealthKitView
                        }
                    }
                    .frame(width: 321, height: 467)
                    .background(Color.white)
                    .cornerRadius(16)
                    .padding(.top, 12)
                    .onAppear() {
                        healthManager.fetchAllFlightsClimbedData()
                        healthManager.migrateAuthorizationDataToSharedDefaults()
                    }
                    
                    HStack {
                        Button {
                            // MARK: 성취로 이동
                            gameCenterManager.showAchievements()
                            reportMissedAchievement()
                        } label: {
                            HStack() {
                                Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
                                Text("달성 뱃지")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .frame(width: 156)
                            .font(.system(size: 17))
                            .foregroundColor(Color.white)
                            .background(.green800,
                                        in: RoundedRectangle(cornerRadius: 12))
                        }
                        
                        Spacer()
                        
                        Button {
                            // MARK: 순위표로 이동
                            gameCenterManager.showLeaderboard()
                        } label: {
                            HStack() {
                                Image(systemName: "figure.stairs")
                                Text("나의 순위")
                            }
                            .padding(.horizontal, 20)
                            .padding(.vertical, 14)
                            .frame(width: 156)
                            .font(.system(size: 17))
                            .foregroundColor(Color.white)
                            .background(.green800,
                                        in: RoundedRectangle(cornerRadius: 12))
                        }
                    }
                    .padding(.top, 8)
                    .padding(.horizontal, 36)
                }
                .refreshable {
                    healthManager.getWeeklyStairDataAndSave()
                    healthManager.fetchAndSaveFlightsClimbedSinceAuthorization()
                    updateLevelsAndGameCenter()
                }
                .scrollIndicators(ScrollIndicatorVisibility.hidden)
                .onChange(of: isHealthKitAuthorized) {
                    if isHealthKitAuthorized { // 헬스킷 권한 허용 후 입단 뱃지 받기
                        gameCenterManager.reportCompletedAchievement(achievementId: "memberOfStepSquad")
                    }
                }
            }
        }
        .ignoresSafeArea()
    }
    
    private var GetHealthKitView: some View {
        VStack(spacing: 0) {
            Image("GetHealthKitImage")
                .resizable()
                .scaledToFit()
                .frame(width: 133, height: 133)
                .padding(.top, 82)
            
            Text("계단사랑단에 입단하세요!")
                .font(.system(size: 20, weight: .bold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
                .padding(.top, 20)
            
            Text("오늘부터 오른 층수 데이터를 추가하면\n진정한 계단사랑단원이 될 수 있어요!")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(red: 0.44, green: 0.44, blue: 0.44))
                .padding(.top, 8)
            
            Button {
                healthManager.configure()
            } label: {
                Label("오른 층수 추가하기",
                      image: "custom.figure.stairs.badge.plus")
                //Text("오른 층수 추가하기")
                .padding(.vertical, 12)
                .padding(.horizontal, 16)
                .foregroundColor(Color.white)
            }
            .background(Color.secondaryColor,
                        in: RoundedRectangle(cornerRadius: 12))
            .padding(.top, 40)
            Spacer()
        }
        
    }
    
    private var LevelUpView: some View {
        VStack(spacing: 0) {
            if isHighestLevel {
                Image("Ultimate")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256, height: 256)
                    .padding(.top, 16)
                
                VStack(spacing: 0) {
                    Text("최고 레벨")
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white)
                        .padding(4)
                        .background(getDifficultyColor(difficulty: .easy), in: RoundedRectangle(cornerRadius: 4))
                    
                    Text("이제 틈새를 속세로!")
                        .font(.system(size: 20, weight: .semibold))
                        .padding(.top, 8)
                    
                    Text("\(currentStatus.getTotalStaircase())층 올라가는 중")
                        .font(.system(size: 12))
                        .foregroundStyle(Color(hex: 0x3C3C43))
                        .padding(.top, 4)
                }
                .padding(.top, 12)
                
                // MARK: 만렙일 때 보여주는 리셋 버튼
                Button {
                    if gameCenterManager.isGameCenterLoggedIn {
                        isResetViewPresented = true
                    } else {
                        isWifiAlertPresented = true
                    }
                } label: {
                    HStack() {
                        
                        Image(systemName: "mountain.2.fill")
                        Text("하산하기")
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal, 14)
                    .foregroundStyle(Color.white)
                    .background(.brown500, in: RoundedRectangle(cornerRadius: 30))
                }
                .padding(.top, 10)
                .alert("네트워크 연결 상태를 확인한 후 앱에 다시 접속해주세요.", isPresented: $isWifiAlertPresented) {
                    Button("확인") {
                        isWifiAlertPresented = false
                    }
                } message: {
                    Text("틈새는 온라인 환경에서만 하산을 할 수 있어요!")
                }
                
                Spacer()
            } else {
                ZStack() {
                    VStack(spacing: 0) {
                        HStack() {
                            Spacer()
                            
                            ZStack() {
                                Image("Union")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 48, height: 60)
                                
                                VStack() {
                                    Image(currentStatus.currentLevel.itemImage + "_TextImage")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(width: 20, height: 20)
                                    
                                    Spacer().frame(maxHeight: 13)
                                }
                            }
                        }
                        
                        Spacer()
                    }
                    
                    VStack() {
                        Spacer()
                        
                        Image(currentStatus.progressImage)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 220, height: 256)
                    }
                }
                .frame(width: 220, height: 256)
                .padding(.top, 32)
                
                HStack(spacing: 4) {
                    Text(currentStatus.currentLevel.difficulty.rawValue)
                        .font(.system(size: 12))
                        .foregroundStyle(Color.white)
                        .padding(4)
                        .background(getDifficultyColor(difficulty: currentStatus.currentLevel.difficulty), in: RoundedRectangle(cornerRadius: 4))
                    
                    Text("레벨 \(currentStatus.currentLevel.level)")
                        .font(.system(size: 12))
                        .foregroundStyle(getDifficultyColor(difficulty: currentStatus.currentLevel.difficulty))
                        .padding(4)
                        .background(getDifficultyPaleColor(difficulty: currentStatus.currentLevel.difficulty), in: RoundedRectangle(cornerRadius: 4))
                }
                .padding(.top, 32)
                
                Text("\(currentStatus.currentLevel.maxStaircase + 1)층 올라가기")
                    .font(.system(size: 20, weight: .semibold))
                    .padding(.top, 8)
                
                Text("\(currentStatus.getTotalStaircase())층 올라가는 중")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: 0x3C3C43))
                    .padding(.top, 4)
                
                Spacer()
                
            }
        }
        .fullScreenCover(isPresented: $isResetViewPresented) {
            ResetNavigationView(isResetViewPresented: $isResetViewPresented, isResetCompleted: $isResetCompleted, manager: ClimbingManager())
        }
        .onAppear {
            // MARK: 일단 임시로 onAppear 사용해서 권한 받자마자 뷰를 그릴 수 있도록 임시 조치함.
            updateLevelsAndGameCenter()
        }
        .onChange(of: isResetViewPresented, {
            // MARK: 리셋 조건 달성 확인 후, 데이터 리셋 시작
            if(!isResetViewPresented && isResetCompleted) {
                resetLevel()
                isResetCompleted = false
                // 완료 후 새로 고침
                healthManager.getWeeklyStairDataAndSave()
                healthManager.fetchAndSaveFlightsClimbedSinceAuthorization()
                updateLevelsAndGameCenter()
            }
        })
    }
    
    // MARK: UserDefaults에 currentStatus 저장하기
    func saveCurrentStatus() {
        if let encodedData = try? JSONEncoder().encode(currentStatus) {
            UserDefaults.standard.setValue(encodedData, forKey: "currentStatus") // TODO: 다른 뷰에서 저장해도 되는지
        }
    }
    
    // MARK: 오프라인 환경에서 받지 못한 레벨, 입단증, 환경 관련 성취 다시 주기
    func reportMissedAchievement() {
        if isHealthKitAuthorized {
            gameCenterManager.reportCompletedAchievement(achievementId: "memberOfStepSquad")
        }
        if completedLevels.lastUpdatedLevel >= 1 {
            for level in 1...completedLevels.lastUpdatedLevel {
                gameCenterManager.reportCompletedAchievement(achievementId: levels[level]!.achievementId)
            }
        }
        for i in [1, 10, 20, 36] {
            if lastElectricAchievementKwh >= i {
                gameCenterManager.reportCompletedAchievement(achievementId: "electricBird\(i)")
            }
        }
        for item in collectedItems.getSortedItemsNameList() {
            if let gpsStaircase = gpsStaircasesDictionary[item] {
                gameCenterManager.reportCompletedAchievement(achievementId: gpsStaircase.achievementId)
            } else if let hiddenItem = hiddenItemsDictionary[item] {
                gameCenterManager.reportCompletedAchievement(achievementId: hiddenItem.achievementId)
            }
        }
    }
    
    // MARK: 헬스킷 업데이트 주기마다 레벨 관련 변경하고, 게임센터 업데이트하는 것 모두 모은 함수
    func updateLevelsAndGameCenter() {
        currentStatus.updateStaircase(Int(healthManager.TotalFlightsClimbedSinceAuthorization))
        saveCurrentStatus()
        compareCurrentLevelAndUpdate()
        updateLeaderboard()
    }
    
    // MARK: 뷰에 접근했을 때 현재 레벨과 lastCompletedLevels와 비교해서 완료한 레벨 날짜를 기록하고 성취 전달
    func compareCurrentLevelAndUpdate() {
        if currentStatus.currentLevel.level - (completedLevels.lastUpdatedLevel) > 1 { // 만약 업데이트 되지 않은 레벨이 있다면,
            isShowingNewItem = true
            for i in (completedLevels.lastUpdatedLevel + 1)..<currentStatus.currentLevel.level { // 업데이트 되지 않은 레벨부터 현재 전의 레벨까지 업데이트
                completedLevels.upgradeLevel(level: i, completedDate: Date.now)
                gameCenterManager.reportCompletedAchievement(achievementId: levels[i]!.achievementId) // 해당 레벨의 성취 달성
            }
        }
        for i in [1, 10, 20, 36] { // 40, 400, 800, 1440층에서 환경 성취 달성
            if (currentStatus.getTotalStaircase() / 40) >= i { // 특정 층 이상으로 계단을 걸었다면,
                if i > lastElectricAchievementKwh { // 특정 층을 달성하고 성취를 아직 받지 않았다면,
                    //                    print("\(i)kWh 틈새 전기 절약 성취 달성")
                    gameCenterManager.reportCompletedAchievement(achievementId: "electricBird\(i)")
                    lastElectricAchievementKwh = i
                }
            }
        }
    }
    
    // MARK: - 이번주 총 점수(전국의 계단 점수 + 오른 계단 칸) 계산 후 순위표 업데이트하기
    func updateLeaderboard() {
        healthManager.getWeeklyStairDataAndSave()
        let weeklyStairPoint = healthManager.weeklyFlightsClimbed * 16
        let weeklyGpsStaircaseScore = gpsStaircaseWeeklyScore.getWeeklyScore()
        Task {
            await gameCenterManager.submitPoint(point: Int(weeklyGpsStaircaseScore) + Int(weeklyStairPoint))
        }
    }
    
    // MARK: 만렙 이후 리셋하기
    func resetLevel() {
        currentStatus.updateStaircase(0)
        saveCurrentStatus()
        lastElectricAchievementKwh = 0
        gameCenterManager.resetAchievements()
        completedLevels.resetLevels()
        collectedItems.resetItems()
    }
    
    // MARK: Level 관련 테스트 프린트문
    func printAll() {
        print("🛠️ printAll")
        print("누적 층계: \(currentStatus.getTotalStaircase())")
        print("현재 레벨: \(currentStatus.currentLevel.level)")
        print("현재 레벨 난이도: \(currentStatus.currentLevel.difficulty.rawValue)")
        print("목적지 약재: \(currentStatus.currentLevel.item)")
        print("목적지 약재 이미지: \(currentStatus.currentLevel.itemImage)")
        print("현재 단계: \(currentStatus.currentProgress)")
        print("현재 단계 이미지: \(currentStatus.progressImage)")
        print("사용자에게 보여준 마지막 달성 레벨: \(completedLevels.lastUpdatedLevel)")
        print("마지막으로 달성한 환경 성취: \(lastElectricAchievementKwh)kWh")
        print("collected items: \(collectedItems.getSortedItemsNameList())")
    }
}
