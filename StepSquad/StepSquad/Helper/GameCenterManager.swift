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
    
    // MARK: 기존 순위표의 점수 가져오기
    // TODO: 로컬 정보 이용할 경우 submitPoint와 분리하기
    func loadFormerPoint() async -> Int {
        do {
            let leaderboards = try await GKLeaderboard.loadLeaderboards(IDs: [leaderboardID])
            guard let leaderboard = leaderboards.first else { return -1 }
            let entries = try await leaderboard.loadEntries(for: [GKLocalPlayer.local],
                                                            timeScope: GKLeaderboard.TimeScope.today)
//            print("entries: \(entries)")
            if entries.1.isEmpty { // 순위표 초기화 이후 불러올 점수가 없는 경우
                print("There is no former point in the leaderboard.")
                return 0
            } else { // 순위표에 기존 점수가 있는 경우
                guard let entry = entries.1.first else { return -1 }
                print("former point: \(entry.score)")
                return entry.score
            }
        } catch { // 점수를 불러오는 과정에서 에러가 발생하는 경우
            print(error.localizedDescription)
            return -1
        }
    }
    
    // MARK: 리더보드에서 모든 사용자의 entry 읽기
    func loadAllPoint() async {
        let leaderboards = try? await GKLeaderboard.loadLeaderboards(IDs: [leaderboardID])
        guard let leaderboard = leaderboards?.first else { return }
        let entries = try? await leaderboard.loadEntries(for: GKLeaderboard.PlayerScope.global,
                                                         timeScope: GKLeaderboard.TimeScope.week, range: NSMakeRange(1, 100))
        for i in 0..<entries!.1.endIndex {
            print(entries!.1[i])
            print("")
        }
    }
    
    // MARK: 순위표 점수를 이전 점수에 더해 업데이트 하기
    func submitPointWithFormerPoint(point: Int) async {
        let formerPoint = await loadFormerPoint()
        if formerPoint == -1 {
            return
        } else {
            GKLeaderboard.submitScore(formerPoint + Int(point), context: 0, player: GKLocalPlayer.local,
                                      leaderboardIDs: [leaderboardID]) { error in
                if error != nil {
                    print("Error: \(error!.localizedDescription).")
                }
            }
        }
        print("game center: updated leaderboard")
    }
    
    // MARK: 특정 값으로 순위표 점수 업데이트 하기
    func submitPoint(point: Int) async {
        GKLeaderboard.submitScore(Int(point), context: 0, player: GKLocalPlayer.local,
                                  leaderboardIDs: [leaderboardID]) { error in
            if error != nil {
                print("Error: \(error!.localizedDescription).")
            }
        }
        print("game center: updated leaderboard")
    }
    
    // MARK: 수명 연장 성취 업데이트하기
    func reportLifeAchievement(stairCount: Int) {
        if stairCount >= 5 {
            reportCompletedAchievement(achievement: GKAchievement(identifier: "min5"))
        }
        if stairCount >= 10 {
            reportCompletedAchievement(achievement: GKAchievement(identifier: "min10"))
        }
        if stairCount >= 15 {
            reportCompletedAchievement(achievement: GKAchievement(identifier: "min15"))
        }
        if stairCount >= 30 {
            reportCompletedAchievement(achievement: GKAchievement(identifier: "min30"))
        }
        if stairCount >= 60 {
            reportCompletedAchievement(achievement: GKAchievement(identifier: "hr1"))
        }
        if stairCount >= 90 {
            reportCompletedAchievement(achievement: GKAchievement(identifier: "hr1min30"))
        }
        if stairCount >= 120 {
            reportCompletedAchievement(achievement: GKAchievement(identifier: "hr2"))
        }
    }
    
    // MARK: 성취 달성 여부 확인 후 성취 업데이트하기
    func reportCompletedAchievement(achievement: GKAchievement) {
        if !achievement.isCompleted {
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement], withCompletionHandler: {(error: Error?) in
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
            })
            print("game center: \(achievement.identifier) achievement completed.")
        }
    }
    
    // MARK: NFC 태깅 성취 업데이트하기
    func reportNfcAchievement(serialNumber: String) {
        let achievement = GKAchievement(identifier: serialNumber)
        if !achievement.isCompleted {
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement], withCompletionHandler: {(error: Error?) in
                if error != nil {
                    print("Error: \(String(describing: error))")
                }
            })
            print("game center: updated achievement of nfc")
        }
    }
    
    // MARK: 성취 리셋하기
    func resetAchievements() {
        GKAchievement.resetAchievements(completionHandler: {(error: Error?) in
            if error != nil {
                print("Error: \(String(describing: error))")
            }
        })
        print("game center: reset achievements.")
    }
    
    
    // MARK: 순위표 보기
    func showLeaderboard() {
        let viewController = GKGameCenterViewController(leaderboardID: leaderboardID, playerScope: .global, timeScope: .allTime)
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
