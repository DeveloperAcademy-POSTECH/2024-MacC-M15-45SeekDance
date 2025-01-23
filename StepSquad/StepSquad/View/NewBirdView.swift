//
//  NewBirdView.swift
//  StepSquad
//
//  Created by Groo on 1/21/25.
//

import SwiftUI

struct NewBirdView: View {
    var body: some View {
        ZStack {
            VStack {
                Spacer()
                VStack {
                    HStack(spacing: 0) {
                        Text("\(123)")
                            .foregroundStyle(Color(hex: 0x7EB55D))
                        Text("일 동안")
                        Text(" \(1449)")
                            .foregroundStyle(Color(hex: 0x7EB55D))
                        Text("층을")
                    }
                    Text("함께 오른 틈새가")
                    Text("하산을 했어요!")
                }
                    .multilineTextAlignment(.center)
                    .font(.title)
                    .fontWeight(.bold)
                Image("Down1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256)
                Spacer()
            }
        }
    }
}

#Preview {
    NewBirdView()
}
