//
//  ExplainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//
//  NFC 태깅하기 방법 버튼

import SwiftUI

struct ExplainView: View {
    @Binding var testFlightsClimbed: Int
    @Binding var isHealthKitAuthorized: Bool
    let gameCenterManager: GameCenterManager
    @Binding var collectedItems: CollectedItems
    @Binding var completedLevels: CompletedLevels
    @Binding var gpsStaircaseWeeklyScore: GPSStaircaseWeeklyScore
    
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                // Background
                Color.backgroundColor.ignoresSafeArea()
                
                VStack {
                    NotiView()
                    List {
                        Section(header: Text("고객 센터")) {
                            NavigationLink {
                                QuestionsView()
                            } label: {
                                Text("자주 묻는 질문")
                            }
                            
                            URLButton(text: String(localized: "오류 문의"),
                                      url: "https://docs.google.com/forms/d/e/1FAIpQLScvUDBnW2y7YfmcOeIzlA9KvzSUcIYix6-wkENPDCiDRaf04Q/viewform")
                            
                            URLButton(text: String(localized: "개발자 기쁘게 하기"),
                                      url: "https://apps.apple.com/app/id6737301392?action=write-review")
                            
                        }
                        
                        Section(header: Text("앱 정보")) {
                            HStack() {
                                Text("버전 정보")
                                
                                Spacer()
                                
                                Text("3.2")
                                    .foregroundStyle(Color(hex: 0x3C3C43))
                                    .opacity(0.6)
                            }
                            
                            URLButton(text: String(localized: "개인정보 처리 방침"),
                                      url: "https://smiling-taxicab-536.notion.site/9e06de4af50e47d584c7c6ed5ccea414")
                        }
                        
                        Section(header: Text("계단사랑단의 이야기")) {
                            URLButton(text: String(localized: "개발 스토리"),
                                      url: "https://github.com/DeveloperAcademy-POSTECH/2024-MacC-M15-45SeekDance")
                            
                            NavigationLink {
                                DeveloperInfoView()
                            } label: {
                                Text("팀 45식단 소개")
                            }
                        }
                    }
                    Button("테스트 버전 리셋하기") {
                        print("🚩 reset")
                        gameCenterManager.resetAchievements()
                        testFlightsClimbed = 0
                        isHealthKitAuthorized = false
                        collectedItems.resetItems()
                        completedLevels.resetLevels()
                        gpsStaircaseWeeklyScore.resetScores()
                        Task {
                            await gameCenterManager.submitPoint(point: 0)
                        }
                    }
                    .buttonStyle(.borderedProminent)
                    .tint(.green100)
                }
                .scrollContentBackground(.hidden)
                .background(.clear)
            }
        }
    }
}

struct URLButton: View {
    let text: String
    let url: String
    
    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Text(text)
                    .foregroundStyle(Color.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(Font.system(.footnote).weight(.semibold))
                    .foregroundStyle(Color(hex: 0x3C3C434D))
                    .opacity(0.3)
            }
        }
    }
}
