//
//  ViewExtension.swift
//  StepSquad
//
//  Created by Groo on 11/20/24.
//

import Foundation
import SwiftUICore

extension View {
    // MARK: 난이도 관련 진한 색 반환
    func getDifficultyColor(difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return .easy
        case .normal: return .normal
        case .hard: return .hard
        case .expert: return .expert
        case .impossible: return .impossible
        case .nfc: return .nfc
        }
    }
    
    // MARK: 난이도 관련 연한 색 반환
    func getDifficultyPaleColor(difficulty: Difficulty) -> Color {
        switch difficulty {
        case .easy: return .easyPale
        case .normal: return .normalPale
        case .hard: return .hardPale
        case .expert: return .expertPale
        case .impossible: return .impossiblePale
        case .nfc: return .nfc
        }
    }
}
