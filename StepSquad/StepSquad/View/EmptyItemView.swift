//
//  EmptyItemView.swift
//  StepSquad
//
//  Created by Groo on 11/26/24.
//

import SwiftUI

struct EmptyItemView: View {
    var body: some View {
        VStack {
            Spacer()
            Image("BoredBird")
            VStack(spacing: 8) {
                Text("계단을 올라야 재료를 모을 수 있어요!")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundStyle(Color(hex: 0x7EB55D))
                Text("첫 번째 레벨을 달성하고 재료를 얻어보세요.")
                    .font(.system(size: 15))
                    .foregroundStyle(Color(hex: 0x8F8F8F))
            }
            Spacer()
        }
    }
}

#Preview {
    EmptyItemView()
}
