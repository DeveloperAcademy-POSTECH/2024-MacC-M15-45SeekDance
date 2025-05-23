//
//  GameCenterManager.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import GameKit
import SwiftUI

class GameCenterManager: NSObject, GKGameCenterControllerDelegate, ObservableObject {
    private let leaderboardID: String = "leaderboardPhase2"
    var isGameCenterLoggedIn: Bool = false
    
    // MARK: 게임 센터 계정 인증하기
    func authenticateUser() {
        var isErrorOccurred = false
        GKLocalPlayer.local.authenticateHandler = { vc, error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                isErrorOccurred = true
                return
            }
            if isErrorOccurred {
                self.isGameCenterLoggedIn = false
                print("game center: not authenticated user")
            } else {
                self.isGameCenterLoggedIn = true
                print("game center: authenticated user")
            }
        }
    }
    
    // MARK: 사용자의 game center 프로필 이미지 가져오기
    func loadLocalPlayerImage() async -> Image? {
        guard isGameCenterLoggedIn else {
            print("Error: user is not logged in to Game Center.")
            return nil
        }
        if let loadedImage = try? await GKLocalPlayer.local.loadPhoto(for: .normal) {
            return Image(uiImage: loadedImage)
        }
        return nil
    }
    
    // MARK: 사용자의 game center 닉네임 가져오기
    func loadLocalPlayerName() -> String? {
        guard isGameCenterLoggedIn else {
            print("Error: user is not logged in to Game Center.")
            return nil
        }
        return GKLocalPlayer.local.displayName
    }
    
    // MARK: 기존 순위표의 점수 가져오기
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
        guard isGameCenterLoggedIn else {
            print("Error: user is not logged in to Game Center.")
            return
        }
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
        guard isGameCenterLoggedIn else {
            print("Error: user is not logged in to Game Center.")
            return
        }
        let formerPoint = await loadFormerPoint()
        if formerPoint == -1 {
            return
        } else {
            GKLeaderboard.submitScore(formerPoint + Int(point), context: 0, player: GKLocalPlayer.local,
                                      leaderboardIDs: [leaderboardID]) { error in
                guard error == nil else {
                    print(error?.localizedDescription ?? "")
                    return
                }
                print("game center: updated leaderboard")
            }
        }
    }
    
    // MARK: 특정 값으로 순위표 점수 업데이트 하기
    func submitPoint(point: Int) async {
        guard isGameCenterLoggedIn else {
            print("Error: user is not logged in to Game Center.")
            return
        }
        GKLeaderboard.submitScore(Int(point), context: 0, player: GKLocalPlayer.local,
                                  leaderboardIDs: [leaderboardID]) { error in
            guard error == nil else {
                print(error?.localizedDescription ?? "")
                return
            }
            print("game center: updated leaderboard")
        }
    }
        
    // MARK: 성취 달성 여부 확인 후 성취 업데이트하기
    func reportCompletedAchievement(achievementId: String) {
        guard isGameCenterLoggedIn else {
            print("Error: user is not logged in to Game Center.")
            return
        }
        let achievement = GKAchievement(identifier: achievementId)
        if !achievement.isCompleted {
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement], withCompletionHandler: {(error: Error?) in
                guard error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                print("game center: \(achievement.identifier) achievement completed.")
            })
        }
    }
    
    // MARK: 성취 달성 여부 확인 후 성취 업데이트하기, 달성 여부 반환
    func reportCompletedAchievementWithReturn(achievementId: String) -> Bool {
        var isReported = false
        guard isGameCenterLoggedIn else {
            print("Error: user is not logged in to Game Center.")
            print("login isReported: \(isReported)")
            return isReported
        }
        let achievement = GKAchievement(identifier: achievementId)
        if !achievement.isCompleted {
            achievement.percentComplete = 100.0
            achievement.showsCompletionBanner = true
            GKAchievement.report([achievement], withCompletionHandler: {(error: Error?) in
                guard error == nil else {
                    print("Error: \(String(describing: error))")
                    return
                }
                print("game center: \(achievement.identifier) achievement completed.")
                isReported = true
            })
            print("after report isReported: \(isReported)")
            return isReported
        }
        print("login isReported: \(isReported)")
        return isReported
    }
    
    // MARK: 성취 리셋하기
    func resetAchievements() {
        GKAchievement.resetAchievements(completionHandler: {(error: Error?) in
            guard error == nil else {
                print("Error: \(String(describing: error))")
                return
            }
            print("game center: reset achievements.")
        })
    }
    
    // MARK: 친구 목록 보기
    func showFriendsList() {
        let viewController = GKGameCenterViewController(state: .localPlayerFriendsList)
        viewController.gameCenterDelegate = self
        
        if let windowScene = UIApplication.shared.connectedScenes.first as? UIWindowScene {
            if let window = windowScene.windows.first {
                window.rootViewController?.present(viewController, animated: true, completion: nil)
            }
        }
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
