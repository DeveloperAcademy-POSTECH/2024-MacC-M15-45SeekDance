//
//  GameCenterManager.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import GameKit

class GameCenterManager: NSObject, GKGameCenterControllerDelegate, ObservableObject {
    let leaderboardID: String = "leaderboard2"
    
    // 게임 센터 계정 인증하기
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
        print("game center: authenticated user")
    }
    
    // 순위표 점수 업데이트 하기
    func submitPoint(point: Int) {
        GKLeaderboard.submitScore(point, context: 0, player: GKLocalPlayer.local,
                                  leaderboardIDs: [leaderboardID]) { error in
            if error != nil {
                print("Error: \(error!.localizedDescription).")
            }
        }
        print("game center: updated leaderboard")
        // 78계단만 태깅할 때
        reportAchievement(achievementID: "testfirst78staircase", isFirst: true)
//        reportAchievement(achievementID: "test78staircase")
    }
    
    // 성취 업데이트하기
    func reportAchievement(achievementID: String, isFirst: Bool = false) {
        var achievement: GKAchievement? = nil
        if isFirst {
            achievement = GKAchievement(identifier: achievementID)
            achievement!.percentComplete = 100.0 // 수정 예정
        } else {
//            GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
//                achievement = achievements?.first(where: { $0.identifier == achievementID})
//                achievement?.percentComplete += 4.0
//                print(achievement?.percentComplete)
//            })
        }
        GKAchievement.report([achievement!], withCompletionHandler: {(error: Error?) in
            if error != nil {
                // Handle the error that occurs.
                print("Error: \(String(describing: error))")
            }
        })
        print("game center: updated achievement")
    }
    
    // 순위표 보기
    func showLeaderboard() {
        let viewController = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .friendsOnly, timeScope: .allTime)
        viewController.gameCenterDelegate = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }

    // 성취 보기
    func showAchievements() {
        let viewController = GKGameCenterViewController(state: .achievements)
        viewController.gameCenterDelegate = self

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }

    // Game Center 뷰 컨트롤러 닫기 핸들러
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
