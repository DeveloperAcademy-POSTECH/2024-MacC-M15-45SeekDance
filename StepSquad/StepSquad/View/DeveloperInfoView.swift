//
//  DeveloperInfoView.swift
//  StepSquad
//
//  Created by hanseoyoung on 12/2/24.
//

import SwiftUI

struct ProfileCard: View {
    var image: String
    var name: String
    var role: String
    var description: String
    var emailLink: String
    var githubLink: String

    var body: some View {
        VStack(spacing: 0) {
            Image(image)
                .resizable()
                .scaledToFit()
                .frame(width: 102, height: 102)

            Text(name)
                .font(.system(size: 18, weight: .bold))
                .foregroundColor(.green800)
                .padding(.top, 7.2)

            Text(role)
                .font(.system(size: 12))
                .foregroundColor(.green600)

            Text(description)
                .font(.system(size: 11.7))
                .multilineTextAlignment(.center)
                .foregroundStyle(Color(hex: 0x3C3C43))
                .lineLimit(2)
                .opacity(0.6)
                .padding(.top, 3.6)

            HStack() {
                Button(action: {
                    openLink("mailto:\(emailLink)")
                }) {

                    Image("mail")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                }
                .padding(4)

                Button(action: {
                    openLink(githubLink)
                }) {

                    Image("github")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 24, height: 24)

                }
                .foregroundColor(.white)
                .padding(4)
            }
        }
        .padding(14.4)
        .frame(width: 180, height: 241)
        .background(Color.white)
        .cornerRadius(7)
    }

    // 링크 열기 함수
    func openLink(_ urlString: String) {
        if let url = URL(string: urlString) {
            UIApplication.shared.open(url)
        }
    }
}

struct DeveloperInfoView: View {
    var body: some View {
        ZStack {
            Color(hex: 0xEDEFEB).ignoresSafeArea()
            VStack {
                HStack {
                    ProfileCard(
                        image: "DevEmoji1",
                        name: "그루",
                        role: "Tech",
                        description: "개인적으로 칡도 삵도 아닌 고등\n어 고양이를 매우 좋아합니다.",
                        emailLink: "himhim2514@gmail.com",
                        githubLink: "https://github.com/grootwo"
                    )

                    ProfileCard(
                        image: "DevEmoji2",
                        name: "레인",
                        role: "Tech",
                        description: "계단사랑단 입단 후 제 삶이 달라졌습니다.",
                        emailLink: "rsoy2918@gmail.com",
                        githubLink: "https://github.com/heexohee"
                    )
                }
                HStack {
                    ProfileCard(
                        image: "DevEmoji3",
                        name: "샘",
                        role: "Design",
                        description: "오른 층수 일일 최고 기록은 178층입니다.",
                        emailLink: "sam.academy.24@gmail.com",
                        githubLink: "https://github.com/samfromsoko"
                    )

                    ProfileCard(
                        image: "DevEmoji4",
                        name: "타냐",
                        role: "Tech",
                        description: "족저근막염이 있는 헬스 전문 개발자.",
                        emailLink: "happyunbd364@naver.com",
                        githubLink: "https://github.com/seoyounghan"
                    )
                }


                Spacer()
            }
            .padding(16)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        DeveloperInfoView()
    }
}
