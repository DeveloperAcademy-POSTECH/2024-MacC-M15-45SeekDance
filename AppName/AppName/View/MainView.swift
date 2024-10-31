//
//  MainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//

import SwiftUI
import CoreNFC
import SwiftData

struct MainView: View {
    @State var showSheet2: Bool = false
    @State private var nfcReader: NFCReader?
    @State private var isButtonEnabled: Bool = true
    @State var isResultViewPresented: Bool = false
    @State var isShowingNFCAlert: Bool = false
    @State var buttonCountMessage: String = ""
    
    @State private var nfcCount: Int = 0
    @State private var nfcMessage: String = ""
    
    @Environment(\.modelContext) var context
    @Query var stairSteps: [StairStepModel]
    
    let gameCenterManager = GameCenterManager()
    
    var body: some View {
        ZStack {
            // Background
            Color.back.ignoresSafeArea()
            
            VStack (alignment: .center) { // VStack 전체
                
                VStack { // 당기면 보이는 값 위치
                    Text("\(countThisMonthStairSteps()) 회")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                }
                .padding(.bottom, 10)
                
                // 흰 카드 안 콘텐츠 (텍스트, 이미지, 서클, 버튼 두개)
                VStack (alignment: .center) {
                    
                    Text("엘리베이터 대신 \n78계단 이용하기!")
                        .multilineTextAlignment(.center)
                        .fontWeight(.regular)
                        .font(.title2)
                        .padding(.top, 20)
                    
                    Image("MainIMG")
                        .resizable()
                        .scaledToFit()
                        .frame(maxHeight: 240)
                        .cornerRadius(12)
                    
                    HStack (spacing: 16) { // 서클
                        ZStack {
                            Circle()
                                .frame(width: 52, height: 52)
                                .foregroundColor(countTodayStairSteps() >= 1 ? .orange : .gray)
                            Text("1회")
                                .foregroundColor(.white)
                        }
                        
                        ZStack {
                            Circle()
                                .frame(width: 52, height: 52)
                                .foregroundColor(countTodayStairSteps() >= 2 ? .pink : .gray)
                            Text("2회")
                                .foregroundColor(.white)
                        }
                        
                        ZStack {
                            Circle()
                                .frame(width: 52, height: 52)
                                .foregroundColor(countTodayStairSteps() >= 3 ? .purple : .gray)
                            Text("3회")
                                .foregroundColor(.white)
                        }
                    }
                    .padding(.top, 30)
                    
                    VStack (alignment: .center) {
                        Button {
                            // TODO: - success 시에 시리얼 넘버 비교 이후 유효하면 게임센터에 계단 층수 추가 로직 필요.
                            nfcReader = NFCReader { result in
                                switch result {
                                case .success((let message, let serialNumber)):
                                    (nfcMessage, nfcCount) = findNFCSerialNuber(serialNumber: serialNumber)
                                    print(serialNumber)
                                    
                                    if nfcCount != 0 {
                                        context.insert(StairStepModel(stairType: message, stairStepDate: Date(), stairNum: nfcCount))
                                        isResultViewPresented.toggle()
                                        gameCenterManager.submitPoint(point: nfcCount)
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
                                Text("NFC 태깅하기")
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .fontWeight(.regular)
                                    .frame(width: 264, height: 50)
                                    .background(Color.indigo)
                                    .cornerRadius(12)
                            } else {
                                Text("\(buttonCountMessage)")
                                    .foregroundColor(.white)
                                    .font(.body)
                                    .fontWeight(.regular)
                                    .frame(width: 264, height: 50)
                                    .background(Color.gray)
                                    .cornerRadius(12)
                            }
                        }
                        .disabled(!isButtonEnabled)
                        .onAppear {
                            startTimer()
                        }
                        
                        Button {
                            showSheet2.toggle()
                        } label: {
                            Image(systemName: "info.square.fill")
                                .foregroundColor(.secondary)
                            Text("도움이 필요하신가요?")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }
                        .alert(isPresented: $isShowingNFCAlert) {
                            Alert(title: Text("지원하지 않는 NFC입니다."),
                                  message: Text("78계단에 위치한 NFC를 태그해주세요."),
                                  dismissButton: .default(Text("확인")))
                        }
                        .sheet(isPresented: $showSheet2) {
                            ExplainView()
                                .presentationDragIndicator(.visible)
                                .presentationDetents([.large])
                        }
                        .padding(.top, 16)
                        
                    }
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    
                }
                .frame(width: 320, height: 580)
                .background(Color.white)
                .cornerRadius(20)
                .fullScreenCover(isPresented: $isResultViewPresented) {
                    ResultView(isResultViewPresented: $isResultViewPresented)
                }
                .onChange(of: isResultViewPresented) {
                    startTimer()
                }
                
                // HStack 버튼
                HStack {
                    Button {
                        // MARK: 성취로 이동
                        gameCenterManager.showAchievements()
                    } label: {
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
                        Text("달성 뱃지")
                        
                    }
                    .frame(height: 50)
                    .frame(width: 152)
                    .foregroundColor(Color.blue)
                    .background(Color.buttons)
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    Button {
                        // MARK: 순위표로 이동
                        gameCenterManager.showLeaderboard()
                    } label: {
                        Image(systemName: "figure.stairs")
                        Text("나의 순위")
                    }
                    .frame(height: 50)
                    .frame(width: 152)
                    .foregroundColor(Color.blue)
                    .background(Color.buttons)
                    .cornerRadius(12)
                }
                .padding(.top, 20)
            }
            .padding(.horizontal, 40)
            .padding(.top, 90)
            .padding(.bottom, 70)
        }
    }
    
    init() {
        // MARK: 사용자 게임 센터 인증
        gameCenterManager.authenticateUser()
    }
    
    // MARK: - 타이머
    func startTimer() {
        Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { _ in
            updateButtonState()
        }
    }
    
    func updateButtonState() {
        if let lastStep = stairSteps.last {
            // 임의로 10초 설정
            let elapsedTime = Date().timeIntervalSince(lastStep.stairStepDate)
            let remainingTime = max(0, 10 - elapsedTime)
            
            if remainingTime <= 0 {
                isButtonEnabled = true
            } else {
                isButtonEnabled = false
                let minutes = Int(remainingTime) / 60
                let seconds = Int(remainingTime) % 60
                buttonCountMessage = String(format: "%02d분 %02d초 뒤 태깅 가능", minutes, seconds)
            }
        } else {
            isButtonEnabled = true
        }
    }
    
    // MARK: - 시리얼 정보를 통해 계단 찾기
    func findNFCSerialNuber(serialNumber: String) -> (String, Int) {
        if gariStairs.contains(where: { $0.serialNumber == serialNumber }) {
            let stair = gariStairs.first(where: { $0.serialNumber == serialNumber })!
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
}
