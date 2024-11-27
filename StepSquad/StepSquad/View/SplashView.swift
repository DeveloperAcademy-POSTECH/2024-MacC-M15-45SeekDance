//
//  SwiftUIView.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/12/24.
//

import SwiftUI

struct SplashView: View {
    @State var randomSplashText: String = ""
    let splashText: [String] = [
        "계단사랑단 심마니가 되어\n‘한약 재료'를 찾자!",
        "친구를 추가하면 친구를 이긴\n뒤 자랑할 수 있어요!",
        "엘리베이터 대신 계단을 사용하면\n전기를 절약할 수 있다는 사실!",
        "계단 한 칸당 건강 수명 4초가\n늘어난다는 소문이 있어요",
        "앱을 쓰면 개발자 한서영이\n행복해진다는 사실을 아시나요?",
        "앱을 쓰면 개발자 박수진이\n춤을 춘다는 사실을 아시나요?",
        "앱을 쓰면 개발자 이그루가\n이얏호를 외친다는 걸 아시나요?",
        "앱을 쓰면 개발자 정소희가\n노래를 부른다는 사실을 아시나요?"
    ]
    
    var body: some View {
        ZStack {
            Color(red: 0.95, green: 0.98, blue: 0.94)

            VStack(spacing: 0) {
                Image("SplashIMG")
                    .resizable()
                    .scaledToFit()
                    .padding(.bottom, 35)

                Text("\(splashText.randomElement() ?? "계단사랑단 심마니가 되어\n‘한약 재료'를 찾자!")")
                    .font(.system(size: 17, weight: .bold))
                    .multilineTextAlignment(.center)
                    .foregroundStyle(Color(red: 0.3, green: 0.43, blue: 0.22))
            }
            .padding(.horizontal, 60)
        }
        .ignoresSafeArea()
    }
}

#Preview {
    SplashView()
}
