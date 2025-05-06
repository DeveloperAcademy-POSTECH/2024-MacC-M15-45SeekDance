//
//  GPSStaircaseMainView.swift
//  StepSquad
//
//  Created by Groo on 5/6/25.
//

import SwiftUI

struct GPSStaircaseMainView: View {
    var body: some View {
        VStack {
            ZStack {
                // TODO: 캐러셀 이미지, 애니메이션 추가
                
                VStack {
                    Spacer()
                    LinearGradient(stops: [.init(color: Color(hex: 0x16240E), location: 0), .init(color: .clear, location: 1)], startPoint: .bottom, endPoint: .top)
                        .frame(height: 142)
                }
                
                VStack {
                    Image("ribbon")
                        .resizable()
                        .frame(width: 312, height: 100)
                        .padding(.top, 24)
                    
                    Spacer()
                    
                    Button(action: {
                        // TODO: 전국의 계단 리스트로 이동
                    }, label: {
                        HStack {
                            Text("전국의 계단 리스트 보기")
                                .foregroundStyle(.white)
                                .bold()
                        }
                        .frame(width: 248, height: 50)
                        .background(RoundedRectangle(cornerRadius: 10).fill(.green500))
                    })
                    .padding(.bottom, 40)
                }
            }
            .frame(height: 444)
            .frame(maxWidth: .infinity)
            .background(.green200)
            Spacer()
        }
    }
}

#Preview {
    GPSStaircaseMainView()
}
