//
//  ExplainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//
//  NFC 태깅하기 방법 버튼

import SwiftUI

struct ExplainView: View {
    var body: some View {
        NavigationStack {
            ZStack(alignment: .topTrailing) {
                // Background
                Color.backgroundColor.ignoresSafeArea()

                VStack {
                    List {
                        Section(header: Text("고객 센터")) {
                            NavigationLink {
                                QuestionsView()
                            } label: {
                                Text("자주 묻는 질문")
                            }

                            URLButton(text: "NFC 설치 문의",
                                      url: "")

                            URLButton(text: "오류 문의",
                                      url: "https://docs.google.com/forms/d/e/1FAIpQLScvUDBnW2y7YfmcOeIzlA9KvzSUcIYix6-wkENPDCiDRaf04Q/viewform")

                            URLButton(text: "개발자 기쁘게 하기",
                                      url: "https://apps.apple.com/app/id6737301392?action=write-review")

                        }

                        Section(header: Text("앱 정보")) {
                            HStack() {
                                Text("버전 정보")

                                Spacer()

                                Text("2.1.0")
                                    .foregroundStyle(Color(hex: 0x3C3C43))
                                    .opacity(0.6)
                            }

                            URLButton(text: "Apple 건강 앱 동기화",
                                      url: "")

                            URLButton(text: "개인정보 처리 방침",
                                      url: "")
                        }

                        Section(header: Text("계단사랑단의 이야기")) {
                            URLButton(text: "개발 스토리",
                                      url: "")

//                            URLButton(text: "팀 45식단 소개",
//                                      url: "")
                            NavigationLink {
                                DeveloperInfoView()
                            } label: {
                                Text("팀 45식단 소개")
                            }


                        }
                    }

                    }
                    .scrollContentBackground(.hidden)
                    .background(.clear)
            }
        }
    }
}

struct URLButton: View {
    let text: String
    let url: String

    var body: some View {
        Button(action: {
            if let url = URL(string: url) {
                UIApplication.shared.open(url)
            }
        }) {
            HStack {
                Text(text)
                    .foregroundStyle(Color.black)
                Spacer()
                Image(systemName: "chevron.right")
                    .font(Font.system(.footnote).weight(.semibold))
                    .foregroundStyle(Color(hex: 0x3C3C434D))
                    .opacity(0.3)
            }
        }
    }
}

#Preview {
    ExplainView()
}
