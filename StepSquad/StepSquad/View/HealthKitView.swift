//
//  MainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//

import SwiftUI

struct HealthKitView: View {
    
    // ObservableObject의 인스턴스 구독, 앞으로 헬스킷에서 다루는 정보를 앱 스토리지에서 호출 할 때, 해당 뷰에 선언하세요.
    @ObservedObject var service = HealthKitService()
    
    var body: some View {
        ZStack {
            // Background
            Color.back.ignoresSafeArea()
            
            VStack(alignment: .center) {
                VStack(alignment: .center) {
                    let score = service.weeklyFlightsClimbed * 16
                    Text("이번 주 점수: \(Int(score))")
                    Text("오늘 오른 계단 수: \(service.TodayFlightsClimbed, specifier: "%.0f") 층")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.top, 10)
                    
                    Text("이번 주 (토-금) 계단 수: \(service.weeklyFlightsClimbed, specifier: "%.0f") 층")
                        .font(.title3)
                        .fontWeight(.medium)
                        .padding(.top, 10)
                    
                    HStack {
                        Button {
                            service.getTodayStairDataAndSave()
                            service.getWeeklyStairDataAndSave()
                        } label: {
                            Image(systemName: "figure.stairs")
                            Text("헬스킷에서 계단 오르기 정보 가져오기")
                        }
                        .padding(10)
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
    }
}

