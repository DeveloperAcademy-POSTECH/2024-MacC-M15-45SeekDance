//
//  ExplainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//
//  NFC 태깅하기 방법 버튼

import SwiftUI

struct ExplainView: View {
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                // Background
                Color.backgroundColor.ignoresSafeArea()

                VStack {
                    List {
                        DisclosureGroup("NFC 어떻게 사용하나요?", content: {
                                Text("1. NFC 태깅하기의 ‘열기’ 버튼을 탭합니다.\n2. '스캔 준비 완료' 창이 뜨면 NFC 태깅을 합니다.\n\ta. 휴대폰 상단부를 태그에 둬야합니다.")
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
                                Text("• 나의 순위 (칸) = 헬스킷의 권한을 허용한 이후부터 오른 층계(Flights Climbed) x 16 + NFC 태깅으로 얻은 특별 점수\n• 태깅할 수 있는 NFC는 총 세 개로 포스텍 78계단의 가운데, C5 1-5층 계단의 사이에, 5-6층 계단 사이 난간에 부착되어 있습니다.")
                            }.listRowInsets(EdgeInsets(top: 11,
                                                       leading: 8,
                                                       bottom: 24,
                                                       trailing: 8))
                        })
                    }
                    .scrollContentBackground(.hidden)
                    .background(.clear)
                    .accentColor(Color(hex: 0x638D48))

                    Spacer()

                    // 오류 문의 버튼
                    Button(action: {
                        if let url = URL(string: "https://docs.google.com/forms/d/e/1FAIpQLScvUDBnW2y7YfmcOeIzlA9KvzSUcIYix6-wkENPDCiDRaf04Q/viewform") {
                            UIApplication.shared.open(url)
                        }
                    }) {
                        Text("오류 문의")
                            .font(.body)
                            .foregroundColor(Color(hex: 0x638D48))
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 88)
                }
                .padding(.top)
                .navigationTitle("도움이 필요하신가요?")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 30)
                    }
                )
            }
        }
    }
}

#Preview {
    ExplainView()
}
