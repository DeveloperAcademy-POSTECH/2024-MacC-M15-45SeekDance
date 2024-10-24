//
//  GameCenterManager.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import Foundation
import GameKit

class GameCenterManager: NSObject {
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
            leaderboardIDs: ["leaderboard1"]) { error in
            if error != nil {
                print("Error: \(error!.localizedDescription).")
            }
        }
        print("game center: updated leaderboard")
    }
    
    // 리더보드 가져오기
    // 그러나 리더보드 전체를 가져와서 특정 값을 가져올 수 있을지는 모르겠다
//    func fetchLeaderboard(){
//        GKLeaderboard.loadLeaderboards(IDs: ["leaderboard1"], completionHandler: { leaderboards, error in
//            if error != nil {
//                print("Error: \(error!.localizedDescription).")
//            } else {                print("game center: fetched leaderboard")
//            }
//        })
//    }
}
