//
//  DescendRecordView.swift
//  StepSquad
//
//  Created by hanseoyoung on 1/22/25.
//

import SwiftUI

struct DescendRecordView: View {
    @State private var isSharing: Bool = false
    @State private var sharedImage: UIImage?
    @State private var isButtonClicked: Bool = false
    
    var body: some View {
        VStack() {
            HStack(spacing: 0) {
                Text("계단사랑단 하산 기록")
                    .font(Font.custom("ChosunCentennial", size: 15))
                    .foregroundStyle(Color(hex: 0x4C6D38))

                Spacer()

                if !isButtonClicked {
                    Button {
                        isButtonClicked = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            captureAndShare()
                            isButtonClicked = false
                        }
                    } label: {
                        Label("공유하기", systemImage: "square.and.arrow.up")
                            .font(.system(size: 13))
                            .foregroundStyle(Color(hex: 0x4C6D38))
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                    }
                    .background(Color(hex: 0xDBEED0),
                                in: RoundedRectangle(cornerRadius: 8))
                }
            }

            HStack() {
                Image("DescendRecordImage")
                    .resizable()
                    .aspectRatio(contentMode: .fit)

                VStack(alignment: .leading) {
                    Spacer()

                    HStack() {
                        Text("계단으로 아낀 전력량")
                            .font(.system(size: 15))
                            .foregroundStyle(Color(hex: 0x3A542B))

                        Spacer()

                        Button {
                            // TODO: 정보창 뜨게 하기
                        } label: {
                            Image(systemName: "info.circle")
                                .foregroundStyle(Color(hex: 0x3A542B))
                        }
                    }

                    Text("123kWh")
                        .font(.system(size: 28, weight: .medium))
                        .foregroundStyle(Color(hex: 0x3A542B))
                }
            }
            .padding(12)
            .background(Color(hex: 0xF3F9F0),
                        in: RoundedRectangle(cornerRadius: 8))
            .frame(width: 289, height: 104)
            .padding(.top, 19)

            CustomTableView()
                .padding(.top, 12)

            Spacer()

            Button {

            } label: {
                Text("입단증 보기")
                    .font(Font.custom("SF Pro", size: 13))
                    .padding(.vertical, 4)
                    .padding(.horizontal, 100)
                    .foregroundColor(Color(red: 0.23, green: 0.33, blue: 0.17))
                    .background(Color(red: 0.79, green: 0.9, blue: 0.73), in: RoundedRectangle(cornerRadius: 8))
            }


        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(width: 321, height: 560)
        .background(Color(hex: 0xCAE5B9),
                    in: RoundedRectangle(cornerRadius: 12))
        .sheet(isPresented: $isSharing) {
            if let sharedImage = sharedImage {
                ShareSheet(activityItems: [sharedImage])
            }
        }

    }

    func captureAndShare() {
        let renderer = ImageRenderer(content: self)

        // 원하는 해상도로 크기 조정
        _ = CGSize(width: 321 * 3, height: 560 * 3) // 3배 스케일
        renderer.scale = 3.0 // 디스플레이의 배율에 따라 조정

        if let uiImage = renderer.uiImage {
            sharedImage = uiImage
            isSharing = true
        }
    }

}

#Preview {
    DescendRecordView()
}
