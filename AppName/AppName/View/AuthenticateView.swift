//
//  AuthenticateView.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import SwiftUI

struct AuthenticateView: View {
    let gameCenterManager = GameCenterManager()
    @AppStorage("point") var point = 0
    @State private var isShowingGameCenterView = false
    var body: some View {
        VStack {
            Button(action: {
                // 게임 센터로 이동
                isShowingGameCenterView = true
            }, label: {
                Image(systemName: "gamecontroller")
                    .font(.title)
            })
            .buttonStyle(.bordered)
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
        .sheet(isPresented: $isShowingGameCenterView) {
            GameCenterView(format: .default)
                .ignoresSafeArea()
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
