//
//  ExplainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//
//  NFC 태깅하기 방법 버튼

import SwiftUI

struct QuestionsView: View {
    var body: some View {
        ZStack(alignment: .topTrailing) {
            // Background
            Color.backgroundColor.ignoresSafeArea()

            VStack {
                List {
                    Section(header: Text("NFC 관련")) {
                        DisclosureGroup("NFC 어떻게 사용하나요?", content: {

                                Text("1. NFC 태깅하기의 ‘열기’ 버튼을 탭합니다.\n2. '스캔 준비 완료' 창이 뜨면 NFC 태깅을 합니다.\n\ta. 휴대폰 상단부를 태그에 둬야합니다.")
                                Text("계단사랑단")
                                    .foregroundStyle(Color.blue)


                        })

                        DisclosureGroup("NFC는 어디에 있나요?", content: {
                            Text("태깅할 수 있는 NFC는 총 세 개로 아래 장소에 부착되어 있습니다.\n◦ 포스텍 78계단의 중간 지점 난간\n◦ C5 1-5층 계단 사이 난간\n◦ C5 5-6층 계단 사이 난간")
                                .listRowInsets(EdgeInsets(top: 11,
                                                          leading: 8,
                                                          bottom: 11,
                                                          trailing: 8))

                        })

                        DisclosureGroup("획득 재료는 무엇인가요?", content: {
                            VStack(spacing: 0) {
                                Text("• 레벨의 난이도에 따라 흔한 것부터 귀한 재료(약재)까지 얻을 수 있습니다.\n• 계단 오르기 획득 재료: 흔함~귀함\n• NFC 태깅 획득 재료: 매우 귀함")
                            }.listRowInsets(EdgeInsets(top: 11,
                                                       leading: 8,
                                                       bottom: 11,
                                                       trailing: 8))
                        })

                        DisclosureGroup("레벨은 어떻게 구성이 되나요?", content: {
                            VStack(spacing: 0) {
                                Text("• 쉬운 레벨부터 어려운 레벨까지 순차적으로 구성이 되어 있습니다.\n• 앱과 ‘오른 계단' 데이터를 연동한 날짜부터 자동으로 측정하여 나의 현재 레벨을 보여줍니다.\n• 레벨업을 위한 계단 경험치는 누적이 됩니다.")
                            }.listRowInsets(EdgeInsets(top: 11,
                                                       leading: 8,
                                                       bottom: 24,
                                                       trailing: 8))
                        })

                        DisclosureGroup("나의 순위는 어떻게 결정되나요?", content: {
                            VStack(spacing: 0) {
                                Text("• 계단의 '칸'을 단위로 사용합니다.\n• 건강(Health)의 권한을 허용한 이후부터 오른 층계(Flights Climbed)의 한 층당 16칸, 그리고 NFC 태깅으로 얻은 특별 점수(칸)을 합산합니다.")
                            }.listRowInsets(EdgeInsets(top: 11,
                                                       leading: 8,
                                                       bottom: 24,
                                                       trailing: 8))
                        })
                    }
                }
                .scrollContentBackground(.hidden)
                .background(.clear)
                .accentColor(Color(hex: 0x3C3C43).opacity(0.3))

                Spacer()

            }
            .padding(.top)
        }

    }
}

#Preview {
    ExplainView()
}
