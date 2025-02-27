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
            ForEach(gpsStaircases) { gpsStaircase in
                Button(action: {
                    // TODO: 인증 완료 후 획득 재료에 추가하고, 게임센터 성취로 전달, 리스트에서 뷰 변경 필요
                    if collectedItems.isCollected(item: gpsStaircase.id) {
                        collectedItems.deleteItem(item: gpsStaircase.id)
                    } else {
                        collectedItems.collectItem(item: gpsStaircase.id, collectedDate: Date.now)
                    }
                }, label: {
                    HStack {
                        Text(gpsStaircase.name)
                        Spacer()
                        Text(collectedItems.isCollected(item: gpsStaircase.id) ? "정복 완료" : "정복 대기")
                    }
                })
                .buttonStyle(.borderedProminent)
                .tint(collectedItems.isCollected(item: gpsStaircase.id) ? .green : .yellow)
            }
        }
    }
}
