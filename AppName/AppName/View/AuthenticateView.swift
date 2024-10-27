//
//  AuthenticateView.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import SwiftUI
import GameKit

struct AuthenticateView: View {
    let gameCenterManager = GameCenterManager()
    @AppStorage("point") var point = 0
    @AppStorage("GKGameCenterViewControllerState") var gameCenterViewControllerState: GKGameCenterViewControllerState = .default
    @AppStorage("IsGameCenterActive") var isGKActive: Bool = false
    var body: some View {
//        if isGKActive {
//            GameCenterView(format: gameCenterViewControllerState)
//        } else {
            VStack {
                HStack {
                    Button(action: {
                        // 성취로 이동
                        gameCenterViewControllerState = .achievements
                        isGKActive = true
                    }, label: {
                        Text("Achievements")
                            .font(.title3)
                    })
                    .buttonStyle(.bordered)
                    Spacer()
                    Button(action: {
                        // 순위표로 이동
                        gameCenterViewControllerState = .leaderboards
                        isGKActive = true
                    }, label: {
                        Text("Leaderboards")
                            .font(.title3)
                    })
                    .buttonStyle(.bordered)
                }
                Spacer()
                Text("your point: \(point)")
                Spacer()
                Button("Temporary tagging") {
                    // 포인트 부여 후 리더보드 수정
                    point += 78
                    gameCenterManager.submitPoint(point: point)
                }
                .buttonStyle(.borderedProminent)
            }
            .sheet(isPresented: $isGKActive) {
                GameCenterView(format: gameCenterViewControllerState)
                    .ignoresSafeArea()
            }
        }
//    }
    
    init() {
        // 사용자 게임 센터 인증
        gameCenterManager.authenticateUser()
    }
}

#Preview {
    AuthenticateView()
}
