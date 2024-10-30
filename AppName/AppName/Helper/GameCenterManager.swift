//
//  GameCenterManager.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import GameKit

class GameCenterManager: NSObject, GKGameCenterControllerDelegate, ObservableObject {
    let leaderboardID: String = "leaderboardPhase2"
    
    // MARK: 게임 센터 계정 인증하기
    func authenticateUser() {
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
        }
        print("game center: authenticated user")
    }
    
    // MARK: 순위표 점수 업데이트 하기
    func submitPoint(point: Int) {
        GKLeaderboard.submitScore(point, context: 0, player: GKLocalPlayer.local,
                                  leaderboardIDs: [leaderboardID]) { error in
            if error != nil {
                print("Error: \(error!.localizedDescription).")
            }
        }
        print("game center: updated leaderboard")
        // TODO: 78계단 이외 계단이 생길 때 수정하기
        // TODO: SwiftData에서 계단의 처음 이용하는지 여부 확인 후 성취 업데이트
        reportAchievement(achievementID: "first78staircase", isFirst: true)
//        reportAchievement(achievementID: "test78staircase")
    }
    
    // MARK: 성취 업데이트하기
    func reportAchievement(achievementID: String, isFirst: Bool = false) {
        var achievement: GKAchievement? = nil
        if isFirst {
            achievement = GKAchievement(identifier: achievementID)
            guard let achievement else { return }
            achievement.percentComplete = 100.0
        } else {
            // TODO: 마스터 성취 업데이트할 때 수정하기
//            GKAchievement.loadAchievements(completionHandler: { (achievements: [GKAchievement]?, error: Error?) in
//                achievement = achievements?.first(where: { $0.identifier == achievementID})
//                achievement?.percentComplete += 4.0
//                print(achievement?.percentComplete)
//            })
        }
        GKAchievement.report([achievement!], withCompletionHandler: {(error: Error?) in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
        })
        print("game center: updated achievement")
    }
    
    // MARK: 순위표 보기
    func showLeaderboard() {
        let viewController = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .friendsOnly, timeScope: .allTime)
        viewController.gameCenterDelegate = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }

    // MARK: 성취 보기
    func showAchievements() {
        let viewController = GKGameCenterViewController(state: .achievements)
        viewController.gameCenterDelegate = self

        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
    }

    // MARK: Game Center 뷰 컨트롤러 닫기 핸들러
    func gameCenterViewControllerDidFinish(_ gameCenterViewController: GKGameCenterViewController) {
        gameCenterViewController.dismiss(animated: true, completion: nil)
    }
}
