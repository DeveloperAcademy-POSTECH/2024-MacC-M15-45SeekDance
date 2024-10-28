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
    var body: some View {
            VStack {
                HStack {
                    Button(action: {
                        gameCenterManager.showAchievements()
                    }, label: {
                        Text("Achievements")
                            .font(.title3)
                    })
                    .buttonStyle(.bordered)
                    Spacer()
                    Button(action: {
                        gameCenterManager.showLeaderboard()
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
        }
    
    init() {
        // 사용자 게임 센터 인증
        gameCenterManager.authenticateUser()
    }
}

#Preview {
    AuthenticateView()
}
