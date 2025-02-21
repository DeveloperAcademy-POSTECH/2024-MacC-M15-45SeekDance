//
//  TestLocalStaircaseVerification.swift
//  StepSquad
//
//  Created by Groo on 2/21/25.
//

import SwiftUI

struct TestLocalStaircaseVerification: View {
    @Binding var collectedItems: CollectedItems
    var body: some View {
        List {
            ForEach(localStaircases) { localStaircase in
                Button(action: {
                    // TODO: 인증 완료 후 획득 재료에 추가하고, 게임센터 성취로 전달, 리스트에서 뷰 변경 필요
                    if collectedItems.isCollected(item: localStaircase.id) {
                        collectedItems.deleteItem(item: localStaircase.id)
                    } else {
                        collectedItems.collectItem(item: localStaircase.id, collectedDate: Date.now)
                    }
                }, label: {
                    HStack {
                        Text(localStaircase.name)
                        Spacer()
                        Text(collectedItems.isCollected(item: localStaircase.id) ? "정복 완료" : "정복 대기")
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(collectedItems.isCollected(item: localStaircase.id) ? .green : .yellow)
            }
        }
    }
}
