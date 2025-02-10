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
            Image("BlankInMaterialsView")
            Image("LazyBird")
                .resizable()
                .frame(width: 222, height: 222)
            VStack(spacing: 8) {
                Text("계단을 올라야 재료를 모을 수 있어요!")
                    .font(.system(size: 20))
                    .bold()
                    .foregroundStyle(.green700)
                Text("첫 번째 레벨을 달성하고 재료를 얻어보세요.")
                    .font(.system(size: 15))
                    .foregroundStyle(.grey600)
            }
            Spacer()
        }
    }
}

#Preview {
    EmptyItemView()
}
