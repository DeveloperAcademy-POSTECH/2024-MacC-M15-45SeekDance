//
//  ResetNavigationView.swift
//  StepSquad
//
//  Created by hanseoyoung on 2/16/25.
//

import SwiftUI

// MARK: - 1번 째 뷰
struct ResetNavigationView: View {
    @Binding var isResetViewPresented: Bool // FullScreen 상태를 상위 뷰와 공유
    @Binding var isResetCompleted: Bool
    
    // 최근 기록 표시위한 @ObservedObject 선언
    @ObservedObject var manager: ClimbingManager
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 16) {
                Text("최고 레벨 달성!")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(4)
                    .background(
                        Color.primaryColor
                            .cornerRadius(4)
                    )
                
                Text("틈새를 속세로!\n이제는 하산할 시간")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                
                Text("하산하기를 완료하면\n틈새와 함께 모은 기록들은 초기화가 됩니다.")
                    .multilineTextAlignment(.center)
                    .font(.body)
                
            }
            .padding(.top, 36)
            
            Image("Ultimate")
                .resizable()
                .scaledToFit()
                .frame(width: 256)
                .padding(.top, 32)
            
            Spacer()
            
            NavigationLink(destination: DetailView(isResetViewPresented: $isResetViewPresented, isResetCompleted: $isResetCompleted)) {
                Text("설명보기")
                    .padding()
                    .frame(width: 352, height: 50)
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: {
                        isResetViewPresented = false // 닫기 버튼으로 Sheet 해제
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
        }
    }
}

// MARK: - 2번 째 뷰
struct DetailView: View {
    @Binding var isResetViewPresented: Bool
    @Binding var isResetCompleted: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Text("")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(4)
                
                VStack {
                    Text("그 동안 모은 건\n") +
                    Text("틈새 하산 선물")
                        .foregroundColor(Color.primaryColor) +
                    Text("로!")
                    
                }
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                
                Text("틈새와 함께 모은 약재, 뱃지, 점수는\n하산이 완료되면 모두 초기화가 됩니다.")
                    .multilineTextAlignment(.center)
                    .font(.body)
            }
            .padding(.top, 36)
            
            Image("Down2")
                .resizable()
                .scaledToFit()
                .frame(width: 348)
                .padding(.top, 16)
            
            
            Spacer()
            
            NavigationLink(destination: DetailView2(isResetViewPresented: $isResetViewPresented, isResetCompleted: $isResetCompleted)) {
                Text("다음으로")
                    .padding()
                    .frame(width: 352, height: 50)
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        //        .navigationTitle("상세 페이지")
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isResetViewPresented = false // 닫기 버튼으로 Sheet 해제
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}


// MARK: - 3번 째 뷰
struct DetailView2: View {
    @Binding var isResetViewPresented: Bool
    @Binding var isResetCompleted: Bool
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Text("")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(4)
                
                VStack {
                    Text("역대 하산 기록은\n")
                        .foregroundColor(Color.primaryColor) +
                    Text("남아있어요!")
                }
                .multilineTextAlignment(.center)
                .font(.title)
                .fontWeight(.bold)
                
                Text("입단증의 뒤집으면\n역대 하산 기록을 볼 수 있습니다.")
                    .multilineTextAlignment(.center)
                    .font(.body)
            }
            .padding(.top, 36)
            
            Image("Down3")
                .resizable()
                .scaledToFit()
                .frame(width: 348)
                .padding(.top, 10)
            
            Spacer()
            
            NavigationLink(destination: DetailView3(isResetViewPresented: $isResetViewPresented, isResetCompleted: $isResetCompleted)) {
                Text("다음으로")
                    .padding()
                    .frame(width: 352, height: 50)
                    .background(Color.primaryColor)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isResetViewPresented = false // 닫기 버튼으로 Sheet 해제
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
}

// MARK: - 4번 째 뷰 (입력창)
struct DetailView3: View {
    @Environment(\.modelContext) var context
    @StateObject private var manager = ClimbingManager()
    
    @Binding var isResetViewPresented: Bool
    @Binding var isResetCompleted: Bool
    let gameCenterManager = GameCenterManager()
    let service = HealthKitService()
    
    @State private var userInput = ""
    @State private var errorMessage = ""
    
    private let correctText = "건강해라"
    
    var body: some View {
        VStack {
            VStack(spacing: 16) {
                Text("")
                    .font(.system(size: 12))
                    .foregroundColor(.white)
                    .padding(4)
                
                Text("틈새를 하산시킬까요?")
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                
                VStack {
                    Text("진행하려면 ") +
                    Text("‘\(correctText)’")
                        .foregroundColor(Color.primaryColor) +
                    Text("를 입력하세요.")
                }
                .multilineTextAlignment(.center)
                .font(.body)
            }
            .padding(.top, 36)
            
            TextField("건강해라", text: $userInput)
                .padding()
                .frame(width: 322, height: 44)
                .background(Color.secondary.opacity(0.2))
                .cornerRadius(10)
                .foregroundColor(.primary)
                .padding(10)
                .padding(.top, 40)
            
            VStack(spacing: 10) {
                if !errorMessage.isEmpty {
                    Text(errorMessage)
                        .foregroundColor(.red)
                        .font(.caption2)
                }
                Text("달성 뱃지, 약재, 리더보드 점수는 영구적으로 사라집니다.\n하산 기록(날짜, 횟수)는 입단증을 통해 확인할 수 있습니다.")
                    .font(.caption2)
                    .multilineTextAlignment(.center)
                    .foregroundColor(.secondary)
            }
            
            Spacer()
            
            NavigationLink(
                destination: ShowNewBirdView(
                    isShowNewBirdPresented: $isResetViewPresented,
                    days: manager.records.last?.dDay ?? 0,
                    stairs: Int(manager.records.last?.floorsClimbed ?? 0)
                )
            ) {
                Text("하산하기")
                    .padding()
                    .frame(width: 352, height: 50)
                    .background(userInput == correctText ? Color.primaryColor : Color.gray)
                    .foregroundColor(.white)
                    .cornerRadius(10)
            }
            .disabled(userInput != correctText)
            .simultaneousGesture(TapGesture().onEnded {
                if userInput == correctText {
                    // 리셋 로직 실행
                    service.fetchAndSaveFlightsClimbedSinceButtonPress()
                    
                    let dDay = loadDDayFromDefaults()
                    let floorsClimbed = service.getSavedFlightsClimbedFromDefaults()
                    
                    manager.addRecord(
                        descentDate: Date(),
                        floorsClimbed: Float(floorsClimbed),
                        dDay: Int(dDay)
                    )
                    
                    do {
                        try context.delete(model: StairStepModel.self)
                    } catch {
                        print("error: Failed to clear all StairStepModel data.")
                    }
                    
                    isResetCompleted = true
                }
            })
        }
        .navigationBarTitleDisplayMode(.inline)
        .toolbar {
            ToolbarItem(placement: .navigationBarTrailing) {
                Button(action: {
                    isResetViewPresented = false
                }) {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.secondary)
                }
            }
        }
    }
    
    // MARK: - dDay 가져오기
    func loadDDayFromDefaults() -> Int {
        let userDefaults = UserDefaults.standard
        let storedDDay = userDefaults.integer(forKey: "DDayValue") // 기본값은 0
        print("UserDefaults에서 가져온 dDay 값: \(storedDDay)")
        return storedDDay
    }
}

