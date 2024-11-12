//
//  MainViewPhase3.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/12/24.
//

import SwiftUI

struct MainViewPhase3: View {
    var body: some View {
        ZStack() {
            Color.backgroundColor

            ScrollView {
                Text("당겨서 계단 정보 불러오기\n계단 업데이트: 방금")
                    .font(.footnote)
                    .foregroundColor(Color(hex: 0x808080))
                    .multilineTextAlignment(.center)
                    .padding(.top, 68)
                    .padding(.bottom, 15)

                VStack() {
                    Spacer()

                    //GetHealthKitView
                    LevelUpView

                    Divider()
                        .padding(.horizontal, 16)
                        .foregroundStyle(Color(hex: 0xCAE5B9))

                    NFCReadingView
                        .padding(.top, 17)
                        .padding(.bottom, 25)
                }
                .frame(width: 321, height: 532)
                .background(Color.white)
                .cornerRadius(16)

                HStack {
                    Button {
                        // MARK: 성취로 이동
                    } label: {
                        Image(systemName: "rectangle.portrait.on.rectangle.portrait.fill")
                        Text("달성 뱃지")

                    }
                    .frame(width: 152, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.primaryColor,
                                in: RoundedRectangle(cornerRadius: 12))

                    Spacer()

                    Button {

                    } label: {
                        Image(systemName: "figure.stairs")
                        Text("나의 순위")
                    }
                    .frame(width: 152, height: 50)
                    .foregroundColor(Color.white)
                    .background(Color.primaryColor,
                                in: RoundedRectangle(cornerRadius: 12))
                }
                .padding(.top, 12)
                .padding(.horizontal, 36)

                Button {
                    // TODO: - 시트 연결
                } label: {
                    Image(systemName: "info.circle")
                        .imageScale(.small)
                    Text("도움이 필요하신가요?")
                        .font(.system(size: 12))
                }
                .foregroundColor(Color(hex: 0x0F5E3D))
                .padding(.top, 16)

            }
            .refreshable {
                // TODO: - refresh 했을 때 필요한 동작 추가
                print("a")
            }
            .scrollIndicators(ScrollIndicatorVisibility.hidden)
        }
        .ignoresSafeArea()
    }

    private var GetHealthKitView: some View {
        VStack(spacing: 0) {
            Text("계단을 오를수록\n몸에 좋은 약재를 얻어요!")
                .font(.system(size: 20, weight: .semibold))
                .multilineTextAlignment(.center)
                .foregroundColor(.black)

            Text("오늘 오른 계단 정보부터\n헬스 데이터에서 가져옵니다.")
                .font(.system(size: 15))
                .multilineTextAlignment(.center)
                .padding(.top, 38)

            Button {
                // TODO: - 헬스 정보 연결
            } label: {
                Text("계단 정보 연결하기")
                    .padding(.vertical, 14)
                    .padding(.horizontal, 20)
                    .foregroundColor(Color.white)
            }
            .background(Color.secondaryColor,
                        in: RoundedRectangle(cornerRadius: 12))
            .padding(.top, 62)
            .padding(.bottom, 55)
        }
    }

    private var LevelUpView: some View {
        VStack(spacing: 0) {
            Image("Easy1")

            HStack(spacing: 0) {
                Text("Easy")
                    .font(.system(size: 12))
                    .foregroundStyle(Color.white)
                    .padding(4)
                    .background(Color(hex: 0x4C6D38), in: RoundedRectangle(cornerRadius: 4))

                Text("레벨 1")
                    .font(.system(size: 12))
                    .foregroundStyle(Color(hex: 0x3A542B))
                    .padding(4)
                    .background(Color(hex: 0xF3F9F0), in: RoundedRectangle(cornerRadius: 4))
            }
            .padding(.top, 50)

            Text("5층 올라가기")
                .font(.system(size: 20, weight: .semibold))
                .padding(.top, 8)
            Text("1층 올라가는 중")
                .font(.system(size: 12))
                .foregroundStyle(Color(hex: 0x3C3C43))
                .padding(.top, 4)

            Button {
                // TODO: - 재료 페이지 연결
            } label: {
                HStack() {
                    Image(systemName: "leaf.fill")
                    Text("획득 재료보기")
                }
                .padding(.vertical, 7)
                .padding(.horizontal, 14)
                .foregroundStyle(Color.white)
                .background(Color.secondaryColor, in: RoundedRectangle(cornerRadius: 30))
            }
            .padding(.top, 16)
            .padding(.bottom, 30)
        }
    }

    private var NFCReadingView: some View {
        HStack(spacing: 0) {
            Circle()
                .foregroundColor(Color(hex: 0xD9D9D9))
                .frame(width: 36, height: 36)
                .padding(.trailing, 9)

            VStack(alignment: .leading, spacing: 0) {
                Text("특별 재료를 찾고 추가 점수 받자!")
                    .font(.system(size: 13))
                    .foregroundStyle(Color(hex: 0x3C3C43))
                Text("NFC 태깅하기")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
            }
            .padding(.trailing, 20)

            Button {
                // TODO: - NFC 태깅
            } label: {
                Text("열기")
                    .font(.system(size: 13))
                    .padding(.horizontal, 12)
                    .padding(.vertical, 8)
                    .foregroundColor(Color(hex: 0x3A542B))
            }
            .background(Color(hex: 0xCAE5B9),
                        in: RoundedRectangle(cornerRadius: 4))
        }
    }
}

#Preview {
    MainViewPhase3()
}
