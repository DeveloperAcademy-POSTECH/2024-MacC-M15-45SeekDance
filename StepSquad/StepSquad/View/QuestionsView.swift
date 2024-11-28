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
                            QuestionText("앱에서 NFC 태깅을 통해 특별 재료와 추가 점수를 제공합니다. 공식 NFC 설치 장소에서만 이용 가능합니다.")

                            QuestionURLButton(text: "계단사랑단 NFC 더 알아보기", url: "")
                        })

                        DisclosureGroup("NFC는 어떻게 사용하나요?", content: {
                            QuestionText("1. 앱에서 NFC 태깅하기의 '열기' 버튼을 탭하세요.\n2. '스캔 준비 완료' 창이 뜨면 휴대폰 상단부를 NFC 태그에 가까이 대주세요.")
                        })

                        DisclosureGroup("NFC는 어디에 있나요?", content: {
                            QuestionText("NFC 설치 위치는 이벤트마다 달라집니다.")

                            QuestionURLButton(text: "위치 확인", url: "")
                            QuestionURLButton(text: "설치 문의", url: "")
                        })
                    }

                    Section(header: Text("게임 레벨")) {
                        DisclosureGroup("레벨업은 어떻게 하나요?", content: {
                            QuestionText("오른 층수에 따라 점수를 획득하고, 점수가 누적되면 레벨업됩니다. 최고 레벨은 19입니다. 이후 레벨 초기화를 할 수 있습니다.")
                        })

                        DisclosureGroup("레벨은 어떻게 구성이 되나요?", content: {
                            QuestionText("Easy → Normal → Hard → Expert → Impossible로 구성됩니다.")
                            QuestionText("앱과 연동된 날짜부터 오른 층수가 누적되어 현재 레벨을 표시합니다.")
                        })

                        DisclosureGroup("획득 재료는 무엇인가요?", content: {
                            QuestionText("레벨에 따라 다양한 재료를 얻을 수 있습니다.")
                            QuestionText("- 낮은 레벨: 흔한 재료")
                            QuestionText("- 높은 레벨: 귀한 재료")
                            QuestionText("- NFC 이벤트나 히든 퀘스트: 깜짝 재료")
                        })
                    }

                    Section(header: Text("나의 순위")) {
                        DisclosureGroup("'나의 순위'의 얼마나 유지되나요?", content: {
                            QuestionText("한 주 동안 모은 점수로 순위가 매겨지며, 매주 금요일 자정에 리셋됩니다.")
                        })

                        DisclosureGroup("‘나의 순위’는 어떻게 계산되나요?", content: {
                            QuestionText("계단 한 층(약 16계단)을 기준으로 16칸(점)을 드립니다.")

                            QuestionText("NFC를 태깅하면 실제 계단 수에 맞춰 점수를 드립니다.(예: 78계단 → 78칸(점))")
                        })
                    }

                    Section(header: Text("데이터 관련")) {
                        DisclosureGroup("앱을 지우면 데이터가 유지되나요?", content: {
                            QuestionText("앱 데이터를 삭제하면 점수와 기록은 사라지지만, 게임 센터 내 뱃지는 유지됩니다. 처음부터 다시 시작하는 마음으로 도전해보세요! 개발자에게 응원을 보내면 업데이트 가능할지도?")
                        })

                        DisclosureGroup("계단 데이터가 연동되지 않아요!", content: {
                            QuestionText("Apple 건강 앱 → 둘러보기 → 오른 층수 → 데이터 소스 및 접근에서 '계단사랑단'의 데이터 읽기 권한이 활성화되어 있는지 확인하세요.")
                        })
                    }

                    Section(header: Text("기타")) {
                        DisclosureGroup("계단을 걷기 싫을 때는 어떻게 하나요?", content: {
                            QuestionText("살면서 쉬운 일만 할 수는 없답니다! 작은 습관이 큰 변화를 만들죠. 오늘은 5층만 도전해보세요! ")
                        })

                        DisclosureGroup("캐릭터 이름은 무엇인가요?", content: {
                            QuestionText("여러분의 틈새 운동을 돕는다는 의미로 틈새라고 지었습니다! (아이메시지에서 스티커로 활용할 수 있어요! )")
                        })

                        URLButton(text: "개발자를 춤추게 하고 싶어요!",
                                  url: "https://apps.apple.com/app/id6737301392?action=write-review")

                        DisclosureGroup("기타를 배우고 싶어요", content: {
                            QuestionText("저두요")
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

    func QuestionText(_ text: String) -> some View {
        return Text("\(text)")
            .foregroundStyle(Color(hex: 0x3C3C43)
                .opacity(0.6))
            .listRowInsets(EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8))
    }

    func QuestionURLButton(text: String, url: String) -> some View {
        return  Text(text)
            .underline(true)
            .foregroundStyle(Color(hex: 0x32ADE6))
            .listRowInsets(EdgeInsets(top: 11, leading: 8, bottom: 11, trailing: 8))
            .onTapGesture {
                if let url = URL(string: url) {
                    UIApplication.shared.open(url)
                }
            }
    }
}

#Preview {
    ExplainView()
}
