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
    @State private var infoButtonClicked: Bool = false
    
    var body: some View {
        VStack() {
            HStack(spacing: 0) {
                Text("계단사랑단 하산 기록")
                    .font(Font.custom("ChosunCentennial", size: 15))
                    .foregroundStyle(.green800)
                
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
                            .foregroundStyle(.green800)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                    }
                    .background(Color(hex: 0xDBEED0),
                                in: RoundedRectangle(cornerRadius: 8))
                }
            }
            
            VStack() {
                HStack() {
                    Image("DescendRecordImage")
                        .resizable()
                        .frame(width: 80, height: 80)
                        .aspectRatio(contentMode: .fit)
                    
                    VStack(alignment: .leading) {
                        HStack(alignment: .bottom) {
                            Text("연장된 건강 수명")
                                .font(.system(size: 15))
                                .foregroundStyle(.green900)
                            
                            Spacer()
                            
                            Button {
                                infoButtonClicked.toggle()
                            } label: {
                                Image(systemName: "info.circle")
                                    .foregroundStyle(.green900)
                            }
                        }
                        Text("1.6시간")
                            .font(.system(size: 28, weight: .medium))
                            .foregroundStyle(.green900)
                    }
                }
                if infoButtonClicked {
                    Text("한 계단 오를 때마다 건강 수명이 4초씩 연장됩니다.")
                        .font(.system(size: 13))
                        .foregroundStyle(.green700)
                }
            }
            .padding(12)
            .background(.green300,
                        in: RoundedRectangle(cornerRadius: 8))
            .padding(.top, 19)
            
            CustomTableView(manager: ClimbingManager())
                .padding(.top, 12)
            
            Spacer()

            Text("입단증 보기")
                .font(Font.custom("SF Pro", size: 13))
                .padding(.vertical, 4)
                .padding(.horizontal, 100)
                .foregroundColor(Color(red: 0.23, green: 0.33, blue: 0.17))
        }
        .padding(.horizontal, 16)
        .padding(.vertical, 16)
        .frame(width: 321, height: 560)
        .background(.green200,
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
