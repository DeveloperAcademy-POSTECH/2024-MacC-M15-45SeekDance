//
//  MainViewPhase3.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/12/24.
//

import SwiftUI
import SwiftData
import CoreNFC

struct MainViewPhase3: View {
    @State var isMaterialSheetPresented: Bool = false
    @State private var nfcReader: NFCReader?
    @State private var isButtonEnabled: Bool = true
    @State var isResultViewPresented: Bool = false
    @State var isShowingNFCAlert: Bool = false
    @State var buttonCountMessage: String = ""
    @State var isLaunching: Bool = true
    @State private var completedLevels = CompletedLevels()
    @State private var collectedItems = CollectedItems()
    
    @State var userProfileImage: Image?
    
    @State private var nfcCount: Int = 0
    @State private var nfcMessage: String = ""
    
    @Environment(\.scenePhase) private var scenePhase
    @Environment(\.modelContext) var context
    
    @Query(sort: [SortDescriptor(\StairStepModel.stairStepDate, order: .forward)]) var stairSteps: [StairStepModel]
    
    @ObservedObject var service = HealthKitService()
    
    @AppStorage("HealthKitAuthorized") var isHealthKitAuthorized: Bool = false
    
    @AppStorage("isShowingNewItem") private var isShowingNewItem = false
    
    let gameCenterManager = GameCenterManager()
    
    var currentStatus: CurrentStatus = CurrentStatus() {
        didSet {
            saveCurrentStatus()
        }
    }
    let electricBirdAchievementCount = UserDefaults.standard.integer(forKey: "electricBirdAchievementCount")
    
    var isHighestLevel: Bool {
        return currentStatus.currentLevel.level == 20
    }
    
    var body: some View {
        if isLaunching {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLaunching = false
                    }
                }
        } else {
            NavigationStack {
                ZStack() {
                    Color.backgroundColor
                    
                    VStack(spacing: 0) {
                        HStack(spacing: 0) {
                            Spacer()
                            
                            Text(service.LastFetchTime.isEmpty == false
                                 ? "당겨서 계단 정보 불러오기\n계단 업데이트: \(service.LastFetchTime)"
                                 : "아직 계단을 안 오르셨군요!\n계단을 오르고 10분 뒤 다시 당겨보세요!")
                            .font(.footnote)
                            .foregroundColor(Color(hex: 0x808080))
                            .multilineTextAlignment(.center)
                            
                            Spacer()
                            
                            NavigationLink(destination: ExplainView()) {
                                Image(systemName: "gear")
                                    .resizable()
                                    .frame(width: 22, height: 22)
                                    .foregroundStyle(Color(hex: 0x6F6F6F))
                                    .padding(5)
                                    .background(Color(hex: 0xE1E1E1), in: Circle.circle)
                            }
                            
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
                                
                                Divider()
                                    .background(Color(hex: 0xCAE5B9))
                                    .padding(.horizontal, 16)
                                    .onAppear() {
                                        service.fetchAllFlightsClimbedData()
                                        service.migrateAuthorizationDataToSharedDefaults()
                                    }
                                
                                NFCReadingView
                                    .padding(.top, 17)
                                    .padding(.bottom, 17)
                                    .fullScreenCover(isPresented: $isResultViewPresented) {
                                        ResultView(isResultViewPresented: $isResultViewPresented,
                                                   stairName: nfcMessage,
                                                   stairCount: nfcCount)
                                    }
                                    .onChange(of: isResultViewPresented) {
                                        startTimer()
                                    }
                                    .alert(isPresented: $isShowingNFCAlert) {
                                        Alert(title: Text("지원하지 않는 NFC입니다."),
                                              message: Text("계단에 위치한 NFC를 태그해주세요."),
                                              dismissButton: .default(Text("확인")))
                                    }
                            }
                            .frame(width: 321, height: 524)
                            .background(Color.white)
                            .cornerRadius(16)
                            .padding(.top, 20)
                            
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
                                    .background(Color(hex: 0x4C6D38),
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
                                    .background(Color(hex: 0x4C6D38),
                                                in: RoundedRectangle(cornerRadius: 12))
                                }
                            }
                            .padding(.top, 16)
                            .padding(.horizontal, 36)
                            
                            if isHealthKitAuthorized {
                                Divider()
                                    .background(Color(hex: 0xCDD3C5))
                                    .padding(.horizontal, 35)
                                    .padding(.vertical, 28)
                                
                                EntryCertificateView(userPlayerImage: userProfileImage, nickName: gameCenterManager.loadLocalPlayerName())
                                
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
                                    .padding(.vertical, 14)
                                }
                                .background(Color(hex: 0x4C6D38), in: RoundedRectangle(cornerRadius: 12))
                                .padding(.top, 16)
                                .padding(.bottom, 51)
                                .padding(.horizontal, 36)
                            }
                            
                        }
                        .refreshable {
                            service.getWeeklyStairDataAndSave()
                            service.fetchAndSaveFlightsClimbedSinceAuthorization()
                            updateLevelsAndGameCenter()
                        }
                        .scrollIndicators(ScrollIndicatorVisibility.hidden)
                        .onAppear {
                            Task {
                                userProfileImage = await gameCenterManager.loadLocalPlayerImage()
                            }
                        }
                        .onChange(of: isHealthKitAuthorized) {
                            if isHealthKitAuthorized { // 헬스킷 권한 허용 후 입단 뱃지 받기
                                gameCenterManager.reportCompletedAchievement(achievementId: "memberOfStepSquad")
                            }
                        }
                    }
                }
                .ignoresSafeArea()
                // MARK: - scenePhase 연결
                .onChange(of: scenePhase) {
                    if scenePhase == .active {
                        service.getWeeklyStairDataAndSave()
                        service.fetchAndSaveFlightsClimbedSinceAuthorization()
                        updateLevelsAndGameCenter()
                    }
                }
            }
            .tint(Color(hex: 0x8BC766))
        }
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
                service.configure()
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
            .padding(.bottom, 60)
        }
        
    }
    
    private var LevelUpView: some View {
        VStack(spacing: 0) {
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
            .padding(.top, 16)
            
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
            .padding(.top, 23)
            
            Text("\(currentStatus.currentLevel.maxStaircase + 1)층 올라가기")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 8)
            Text("\(currentStatus.getTotalStaircase())층 올라가는 중")
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: 0x3C3C43))
                .padding(.top, 4)
            
            Button {
                isMaterialSheetPresented.toggle()
            } label: {
                HStack() {
                    Image(systemName: "leaf.fill")
                    Text("획득 재료보기")
                    if isShowingNewItem { // 새로 획득한 약재가 있다면,
                        NewItemView()
                    }
                }
                .padding(.vertical, 7)
                .padding(.horizontal, 14)
                .foregroundStyle(Color.white)
                .background(Color(hex: 0x864035), in: RoundedRectangle(cornerRadius: 30))
            }
            .padding(.top, 16)
            .padding(.bottom, 28)
            .sheet(isPresented: $isMaterialSheetPresented) {
                MaterialsView(isMaterialSheetPresented: $isMaterialSheetPresented, isShowingNewItem: $isShowingNewItem, completedLevels: completedLevels, collectedItems: collectedItems)
            }
            // MARK: 임시 리셋 버튼
            if isHighestLevel {
                Button {
                    resetLevel()
                } label: {
                    HStack() {
                        Image(systemName: "leaf.fill")
                        Text("리셋하기")
                    }
                    .padding(.vertical, 7)
                    .padding(.horizontal, 14)
                    .foregroundStyle(Color.white)
                    .background(Color(hex: 0x864035), in: RoundedRectangle(cornerRadius: 30))
                }
            }
        }
        .onAppear {
            // MARK: 일단 임시로 onAppear 사용해서 권한 받자마자 뷰를 그릴 수 있도록 임시조치함. 단, onAppear를 사용하면 뷰에 접속 할때마다 갱신되므로 사실 상, pulltoRefreash가 의미 없어짐.
            gameCenterManager.authenticateUser()
            service.getWeeklyStairDataAndSave()
            service.fetchAndSaveFlightsClimbedSinceAuthorization()
            updateLevelsAndGameCenter()
            service.fetchAllFlightsClimbedData()
        }
    }
    
    private var NFCReadingView: some View {
        HStack(spacing: 0) {
            Image("NFCButtonImage")
                .resizable()
                .frame(width: 36, height: 36)
                .padding(.leading, 16)
                .padding(.trailing, 9)
            
            VStack(alignment: .leading, spacing: 0) {
                Text("5분마다 획득할 수 있어요!")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: 0x3C3C43))
                Text("NFC로 특별 재료 얻기")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
            }
            
            Spacer()
            
            Button {
                nfcReader = NFCReader { result in
                    switch result {
                    case .success((let message, let serialNumber)):
                        (nfcMessage, nfcCount) = findNFCSerialNuber(serialNumber: serialNumber)
                        print(serialNumber)
                        
                        if nfcCount != 0 {
                            context.insert(StairStepModel(stairType: message, stairStepDate: Date(), stairNum: nfcCount))
                            do {
                                try context.save()
                            } catch {
                                print("SwiftData error")
                            }
                            isResultViewPresented.toggle()
                            // MARK: - 순위표, 성취 업데이트 하기
                            gameCenterManager.reportCompletedAchievement(achievementId: serialNumber)
                            gameCenterManager.reportCompletedAchievement(achievementId: "bullocho")
                            updateLeaderboard()
                            if !collectedItems.isCollected(item: "Bullocho") { // 불로초를 처음 획득한다면
                                collectedItems.collectItem(item: "Bullocho", collectedDate: Date.now)
                                isShowingNewItem = true
                            }
                        } else {
                            isShowingNFCAlert.toggle()
                        }
                        
                    case .failure(let error):
                        print("error 발생")
                    }
                }
                nfcReader?.beginScanning()
            } label: {
                if isButtonEnabled {
                    Text("열기")
                        .font(.system(size: 13))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundColor(Color(hex: 0x3A542B))
                        .background(Color(hex: 0xCAE5B9),
                                    in: RoundedRectangle(cornerRadius: 4))
                } else {
                    Text("\(buttonCountMessage)")
                        .font(.system(size: 13))
                        .foregroundColor(.black)
                        .font(.body)
                        .fontWeight(.regular)
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .background(Color(hex: 0xD9D9D9))
                        .cornerRadius(4)
                }
            }
            .padding(.trailing, 16)
            .disabled(!isButtonEnabled)
            .onAppear {
                startTimer()
            }
        }
    }
    
    // MARK: - 생성자
    init() {
        // MARK: 사용자 게임 센터 인증
        gameCenterManager.authenticateUser()
        // MARK: 저장된 레벨 정보 불러오고 헬스킷 정보로 업데이트하기
        currentStatus = loadCurrentStatus()
    }
    
    // MARK: - 타이머
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateButtonState()
        }
    }
    
    func updateButtonState() {
        if let lastStep = stairSteps.last {
            let elapsedTime = Date().timeIntervalSince(lastStep.stairStepDate)
            let remainingTime = max(0, 300 - elapsedTime)
            
            if remainingTime <= 0 {
                isButtonEnabled = true
            } else {
                isButtonEnabled = false
                let minutes = Int(remainingTime) / 60
                let seconds = Int(remainingTime) % 60
                buttonCountMessage = String(format: "%02d분 %02d초", minutes, seconds)
            }
        } else {
            isButtonEnabled = true
        }
    }
    
    // MARK: - 시리얼 정보를 통해 계단 찾기
    func findNFCSerialNuber(serialNumber: String) -> (String, Int) {
        if gariStairs.contains(where: { $0.serialNumber == serialNumber }) {
            let stair = gariStairs.first(where: { $0.serialNumber == serialNumber })!
            stair.isVisited = true
            return (stair.name, stair.numberOfStairs)
        } else {
            return ("지원되지 않는 NFC입니다", 0)
        }
    }
    
    // MARK: - 오늘 계단 걷기 기록 횟수
    func countTodayStairSteps() -> Int {
        let calendar = Calendar.current
        let today = Date()
        
        return stairSteps.filter { stairStep in
            let isToday = calendar.isDate(stairStep.stairStepDate, inSameDayAs: today)
            return isToday
        }.count
    }
    
    // MARK: - 이번달 계단 걷기 기록 횟수
    func countThisMonthStairSteps() -> Int {
        let calendar = Calendar.current
        let startOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: Date()))!
        let startOfNextMonth = calendar.date(byAdding: .month, value: 1, to: startOfMonth)!
        
        return stairSteps.filter { stairStep in
            stairStep.stairStepDate >= startOfMonth && stairStep.stairStepDate < startOfNextMonth
        }.count
    }
    
    // MARK: - NFC 주간 점수 계산
    func weeklyScore(from data: [StairStepModel], currentDate: Date = Date()) -> Int {
        let calendar = Calendar.current
        var startOfWeek = currentDate
        
        while calendar.component(.weekday, from: startOfWeek) != 7 {
            startOfWeek = calendar.date(byAdding: .day, value: -1, to: startOfWeek)!
        }
        startOfWeek = calendar.startOfDay(for: startOfWeek)
        
        let totalScore = data
            .filter { $0.stairStepDate >= startOfWeek && $0.stairStepDate <= currentDate }
            .reduce(0) { $0 + $1.stairNum }
        
        return totalScore
    }
    
    // MARK: - 이번주 총 점수 계산 후 순위표 업데이트하기
    func updateLeaderboard() {
        let weeklyNfcPoint = weeklyScore(from: stairSteps)
        service.getWeeklyStairDataAndSave()
        let weeklyStairPoint = service.weeklyFlightsClimbed * 16
        print("이번주 걸은 층계 * 16: \(weeklyStairPoint), nfc 점수: \(weeklyNfcPoint)")
        Task {
            await gameCenterManager.submitPoint(point: Int(weeklyNfcPoint) + Int(weeklyStairPoint))
        }
    }
    
    // MARK: UserDefaults에 currentStatus 저장하기
    func saveCurrentStatus() {
        if let encodedData = try? JSONEncoder().encode(currentStatus) {
            UserDefaults.standard.setValue(encodedData, forKey: "currentStatus")
        }
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
    
    // MARK: 뷰에 접근했을 때 현재 레벨과 lastCompletedLevels와 비교해서 완료한 레벨 날짜를 기록하고 성취 전달
    func compareCurrentLevelAndUpdate() {
        if currentStatus.currentLevel.level - (completedLevels.lastUpdatedLevel) > 1 { // 만약 업데이트 되지 않은 레벨이 있다면,
            isShowingNewItem = true
            for i in (completedLevels.lastUpdatedLevel + 1)..<currentStatus.currentLevel.level { // 업데이트 되지 않은 레벨부터 현재 전의 레벨까지 업데이트
                completedLevels.upgradeLevel(level: i, completedDate: Date.now)
                gameCenterManager.reportCompletedAchievement(achievementId: levels[i]!.achievementId) // 해당 레벨의 성취 달성
            }
        }
        if (currentStatus.getTotalStaircase() / 40) > electricBirdAchievementCount { // 누적 오른 층계가 40층의 배수라면,
            print("-----It's \(currentStatus.getTotalStaircase() / 40)번째 틈새 전기 절약 성취")
//            if gameCenterManager.reportCompletedAchievement(achievementId: "electricBird") { // 성취를 정상적으로 받는다면,
//                UserDefaults.standard.setValue(currentStatus.getTotalStaircase() / 40, forKey: "electricBirdAchievementCount")
//                print("저장된 electricBirdAchievementCount: \(UserDefaults.standard.integer(forKey: "electricBirdAchievementCount"))")
//            }
        }
    }
    
    // MARK: 오프라인 환경에서 받지 못한 레벨, 입단증 성취 다시 주기
    func reportMissedAchievement() {
        if isHealthKitAuthorized {
            gameCenterManager.reportCompletedAchievement(achievementId: "memberOfStepSquad")
        }
        if completedLevels.lastUpdatedLevel >= 1 {
            for level in 1...completedLevels.lastUpdatedLevel {
                gameCenterManager.reportCompletedAchievement(achievementId: levels[level]!.achievementId)
            }
        }
    }
    
    // MARK: 헬스킷 업데이트 주기마다 레벨 관련 변경하고, 게임센터 업데이트하는 것 모두 모은 함수
    func updateLevelsAndGameCenter() {
        currentStatus.updateStaircase(Int(service.TotalFlightsClimbedSinceAuthorization))
        saveCurrentStatus()
        compareCurrentLevelAndUpdate()
        updateLeaderboard()
    }
    
    // MARK: 만렙 이후 리셋하기
    func resetLevel() {
        currentStatus.updateStaircase(0)
        saveCurrentStatus()
        do {
            try context.delete(model: StairStepModel.self)
        } catch {
            print("error: Failed to clear all StairStepModel data.")
        }
        gameCenterManager.resetAchievements()
        completedLevels.resetLevels()
        collectedItems.resetItems()
        service.fetchAndSaveFlightsClimbedSinceButtonPress()
    }

    // MARK: Level 관련 테스트 프린트문
    func printAll() {
        print("누적 층계: \(currentStatus.getTotalStaircase())")
        print("현재 레벨: \(currentStatus.currentLevel.level)")
        print("현재 레벨 난이도: \(currentStatus.currentLevel.difficulty.rawValue)")
        print("목적지 약재: \(currentStatus.currentLevel.item)")
        print("목적지 약재 이미지: \(currentStatus.currentLevel.itemImage)")
        print("현재 단계: \(currentStatus.currentProgress)")
        print("현재 단계 이미지: \(currentStatus.progressImage)")
        print("사용자에게 보여준 마지막 달성 레벨: \(completedLevels.lastUpdatedLevel)")
        print("collected items: \(collectedItems.getSortedItemsNameList())")
        print("nfc 태깅 횟수: \(stairSteps.count)")
    }
}


#Preview {
    MainViewPhase3()
}


