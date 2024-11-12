//
//  SwiftUIView.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/12/24.
//

import SwiftUI

struct SplashView: View {
    var body: some View {
        ZStack {
            Color.background
            
            VStack(spacing: 0) {
                Image("SplashIMG")
                    .resizable()
                    .aspectRatio(1, contentMode: .fit)
                    .padding(.bottom, 40)

                Text("심마니가 되어 나와 지구의 수명을 \n연장할 ‘한약 재료'를 찾자!")
                    .font(Font.custom("SF Pro", size: 15))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(hex: 0x3A542B))
            }
            .padding(.horizontal, 82)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}
