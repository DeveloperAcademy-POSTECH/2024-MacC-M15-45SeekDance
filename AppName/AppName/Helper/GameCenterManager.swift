//
//  GameCenterManager.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import Foundation
import GameKit

class GameCenterManager: NSObject {
    let leaderboardID: String = "leaderboard2"
    
    // 게임 센터 계정 인증하기
    func authenticateUser(){
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
        print("game center: authenticated user")
    }
    
    // 리더보드 점수 업데이트 하기
    func submitPoint(point: Int){
        GKLeaderboard.submitScore(point, context: 0, player: GKLocalPlayer.local,
            leaderboardIDs: [leaderboardID]) { error in
            if error != nil {
                print("Error: \(error!.localizedDescription).")
            }
        }
        print("game center: updated leaderboard")
    }
}
