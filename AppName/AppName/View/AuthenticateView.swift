//
//  AuthenticateView.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import SwiftUI

struct AuthenticateView: View {
    let gameCenterManager = GameCenterManager()
    @State private var point = 0
    var body: some View {
        VStack {
            Button(action: {
                // 게임 센터로 이동
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
