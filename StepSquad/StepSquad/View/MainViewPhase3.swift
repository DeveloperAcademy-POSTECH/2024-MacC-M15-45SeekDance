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
    @State var isExplainSheetPresented: Bool = false
    @State private var nfcReader: NFCReader?
    @State private var isButtonEnabled: Bool = true
    @State var isResultViewPresented: Bool = false
    @State var isShowingNFCAlert: Bool = false
    @State var buttonCountMessage: String = ""
    @State var isLaunching: Bool = true
    
    @State private var nfcCount: Int = 0
    @State private var nfcMessage: String = ""
    
    @State private var lastFetchDate: Date = Date()
    @State private var currentTime: Date = Date()
    
    @Environment(\.modelContext) var context
    @Query(sort: [SortDescriptor(\StairStepModel.stairStepDate, order: .forward)]) var stairSteps: [StairStepModel]
    
    @ObservedObject var service = HealthKitService()
    
    @Environment(\.scenePhase) private var scenePhase
    
    let gameCenterManager = GameCenterManager()
    
    var currentStatus: CurrentStatus = CurrentStatus() {
        didSet {
            saveCurrentStatus()
        }
    }
    @State private var completedLevels = CompletedLevels()
    @State private var isShowingNewItem = false
    
    var body: some View {
        if isLaunching {
            SplashView()
                .onAppear {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
                        isLaunching = false
                    }
                }
        } else {
            ZStack() {
                Color.backgroundColor
                
                VStack() {
                    Text("당겨서 계단 정보 불러오기\n계단 업데이트: \(getFormattedFetchTime())")
                        .font(.footnote)
                        .foregroundColor(Color(hex: 0x808080))
                        .multilineTextAlignment(.center)
                        .padding(.top, 68)
                        .padding(.bottom, 15)
                    
                    
                    ScrollView {
                        VStack() {
                            // TODO: - 헬스킷 연결 전엔 GetHealthKitView 이후는 LevelUpView 띄우기
                            //GetHealthKitView
                            LevelUpView
                            
                            Divider()
                                .padding(.horizontal, 16)
                                .foregroundStyle(Color(hex: 0xCAE5B9))
                            
                            NFCReadingView
                                .padding(.top, 17)
                                .padding(.bottom, 25)
                                .fullScreenCover(isPresented: $isResultViewPresented) {
                                    ResultView(isResultViewPresented: $isResultViewPresented, stairName: nfcMessage, stairCount: nfcCount, gameCenterManager: gameCenterManager)
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
                        .frame(width: 321, height: 560)
                        .background(Color.white)
                        .cornerRadius(16)
                        
                        HStack {
                            Button {
                                // MARK: 성취로 이동
                                gameCenterManager.showAchievements()
                            } label: {
                                HStack() {
                                    Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
                                    Text("달성 뱃지")
                                }
                                .frame(width: 152, height: 50)
                                .font(.system(size: 17))
                                .foregroundColor(Color.white)
                                .background(Color.primaryColor,
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
                                .frame(width: 152, height: 50)
                                .font(.system(size: 17))
                                .foregroundColor(Color.white)
                                .background(Color.primaryColor,
                                            in: RoundedRectangle(cornerRadius: 12))
                            }
                        }
                        .padding(.top, 12)
                        .padding(.horizontal, 36)
                        
                        Button {
                            isExplainSheetPresented.toggle()
                        } label: {
                            Image(systemName: "info.circle")
                                .imageScale(.small)
                            Text("도움이 필요하신가요?")
                                .font(.system(size: 12))
                        }
                        .foregroundColor(Color(hex: 0x0F5E3D))
                        .padding(.top, 16)
                        .sheet(isPresented: $isExplainSheetPresented) {
                            ExplainView()
                                .presentationDragIndicator(.visible)
                                .presentationDetents([.large])
                        }
                    }
                    .refreshable {
                        // TODO: - refresh 했을 때 헬스 킷에서 데이터 최신으로 업데이트
                        service.getWeeklyStairDataAndSave()
                        service.fetchAndSaveFlightsClimbedSinceAuthorization()
                        currentStatus.updateStaircase(Int(service.TotalFlightsClimbedSinceAuthorization))
                        saveCurrentStatus()
                        compareCurrentLevelAndUpdate()
                        updateLeaderboard()
                        printAll()
                    }
                    .scrollIndicators(ScrollIndicatorVisibility.hidden)
                }
            }
            .ignoresSafeArea()
            // MARK: - scenePhase 연결
            .onChange(of: scenePhase) {
                if scenePhase == .active {
                    service.getWeeklyStairDataAndSave()
                    service.fetchAndSaveFlightsClimbedSinceAuthorization()
                    currentStatus.updateStaircase(Int(service.TotalFlightsClimbedSinceAuthorization))
                    saveCurrentStatus()
                    compareCurrentLevelAndUpdate()
                    updateLeaderboard()
                    printAll()
                }
            }
        }
    }
    
    
    private var GetHealthKitView: some View {
        VStack(spacing: 0) {
            Text("계단을 오를수록\n몸에 좋은 약재를 얻어요!")
                .font(.system(size: 20, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)
            
            Text("오늘 오른 계단 정보부터\n헬스 데이터에서 가져옵니다.")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.top, 38)
            
            Button {
                // TODO: - 헬스 정보 연결
            } label: {
                Text("계단 정보 연결하기")
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color.white)
            }
            .background(Color.secondaryColor,
                        in: RoundedRectangle(cornerRadius: 12))
            .padding(.top, 62)
            .padding(.bottom, 55)
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
                                .frame(width: 48, height: 60.5)
                            
                            Image(currentStatus.currentLevel.itemImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 30, height: 30)
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
            .frame(width: 220, height: 276)
            .padding(.top, 33)
            
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
            Text("\(service.TotalFlightsClimbedSinceAuthorization, specifier: "%.0f") 층 올라가는 중")
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
                .background(Color.secondaryColor, in: RoundedRectangle(cornerRadius: 30))
            }
            .padding(.top, 16)
            .padding(.bottom, 28)
            .sheet(isPresented: $isMaterialSheetPresented) {
                MaterialsView(isMaterialSheetPresented: $isMaterialSheetPresented, isShowingNewItem: $isShowingNewItem, completedLevels: completedLevels)
            }
        }
    }
    
    private var NFCReadingView: some View {
        HStack(spacing: 0) {
            Circle()
                .foregroundColor(Color(hex: 0xD9D9D9))
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
                            saveGariStairsToUserDefaults()
                            do {
                                try context.save()
                            } catch {
                                print("Data error")
                            }
                            isResultViewPresented.toggle()
                            // MARK: - 순위표, 성취 업데이트 하기
                            gameCenterManager.reportCompletedAchievement(achievementId: serialNumber)
                            updateLeaderboard()
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
        // TODO: - 테스트 이후 정리하기
        // MARK: 사용자 게임 센터 인증
        gameCenterManager.authenticateUser()
        // MARK: 저장된 레벨 정보 불러오고 헬스킷 정보로 업데이트하기
        currentStatus = loadCurrentStatus()
        currentStatus.updateStaircase(Int(service.TotalFlightsClimbedSinceAuthorization))
        saveCurrentStatus()
        compareCurrentLevelAndUpdate()
        printAll()
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
    
    // MARK: - UserDefaults에 데이터를 저장하는 함수
    func saveGariStairsToUserDefaults() {
        if let data = try? JSONEncoder().encode(gariStairs) {
            let defaults = UserDefaults(suiteName: "group.com.stepSquad")
            defaults?.set(data, forKey: "gariStairs")
        }
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
        //        print("이번주 걸은 층계 * 16: \(weeklyStairPoint), nfc 점수: \(weeklyNfcPoint)")
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
                gameCenterManager.reportCompletedAchievement(achievementId: levels[i - 1].achievementId) // 해당 레벨의 성취 달성
            }
        }
    }
    
    // MARK: 난이도 관련 진한 색 반환
    func getDifficultyColor(difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return .easy
        case .normal: return .normal
        case .hard: return .hard
        case .expert: return .expert
        case .impossible: return .impossible
        }
    }
    
    // MARK: 난이도 관련 연한 색 반환
    func getDifficultyPaleColor(difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return .easyPale
        case .normal: return .normalPale
        case .hard: return .hardPale
        case .expert: return .expertPale
        case .impossible: return .impossiblePale
        }
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
    }
    
    // MARK: 시간 포메터
    func getFormattedFetchTime() -> String {
        let appGroupDefaults = UserDefaults(suiteName: "group.macmac.pratice.carot")
        guard let lastFetchTime = appGroupDefaults?.object(forKey: "LastFetchTime") as? Date else {
            return "데이터 없음"
        }
        
        let currentDate = Date()
        let calendar = Calendar.current
        
//         현재 시각과 비교하여 분 단위로 같으면 "방금" 반환
        if calendar.isDate(currentDate, equalTo: lastFetchTime, toGranularity: .minute) {
            return "방금"
        }
        
        // 시각 포맷 설정
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "a hh:mm, yyyy/MM/dd" // "오후 11:29, 2024/11/10" 형식
        
        return formatter.string(from: lastFetchTime)
    }
}







#Preview {
    MainViewPhase3()
}


