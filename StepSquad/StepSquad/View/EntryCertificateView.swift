//
//  EntryCertificateView.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/28/24.
//

import SwiftUI

struct EntryCertificateView: View {
    var isGameCenterLogin: Bool = false
    var nickName: String?
    var userPlayerImage: Image?
    var authorizedDate: Date?

    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("계단사랑단 입단증")
                    .font(Font.custom("ChosunCentennial", size: 15))
                    .foregroundStyle(Color(hex: 0x4C6D38))

                Spacer()

                Text("StepSquad")
                    .font(Font.custom("ChosunCentennial", size: 15))
                    .foregroundStyle(Color(hex: 0x7EB55D))
            }
            .padding(.top, 18)

            ZStack(alignment: .topLeading) {
                Image(isGameCenterLogin ? "entryCertiLog" :"entryCertiNoLog")
                    .resizable()
                    .scaledToFit()

                VStack(alignment: .leading) {
                    Text("계단 오르기 맹세한 지")
                        .font(.system(size: 22))
                        .foregroundStyle(Color(hex: 0x4C6D38))

                    Text("12일 차")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(Color(hex: 0x3A542B))
                }
                .padding(.top, 24)
                .padding(.leading, 20)

            }
            .padding(.top, 12)

            Text(nickName ?? "계단 오르기를 실천하는 사람")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.leading)
                .padding(.top, 8)

            Text("YYYY.MM.DD 입단")
                .font(.system(size: 13))
                .foregroundStyle(Color(hex: 0x4C6D38))

            Spacer()

            HStack(spacing: 0) {
                Text("계단사랑단")
                    .font(Font.custom("ChosunCentennial", size: 15))
                    .foregroundStyle(Color(hex: 0x3A542B))
                    .padding(.trailing, 5)

                Text("StepSquad")
                    .font(Font.custom("ChosunCentennial", size: 15))
                    .foregroundStyle(Color(hex: 0x7EB55D))

                Spacer()

                Button {
                    // TODO: 이미지 익스포팅
                } label: {
                    Label("공유하기", systemImage: "square.and.arrow.up")
                        .font(.system(size: 13))
                        .foregroundStyle(Color(hex: 0x4C6D38))
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                }
                .background(Color(hex: 0xDBEED0), in: RoundedRectangle(cornerRadius: 8))

            }

            .padding(.bottom, 23)

        }
        .padding(.horizontal, 20)
        .frame(width: 321, height: 560)
        .background(Color(red: 0.69, green: 0.85, blue: 0.6),
                    in: RoundedRectangle(cornerRadius: 12))
    }
}

#Preview {
    EntryCertificateView()
}
