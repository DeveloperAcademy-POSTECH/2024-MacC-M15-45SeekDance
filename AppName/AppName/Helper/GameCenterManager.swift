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
        return
    }
}
