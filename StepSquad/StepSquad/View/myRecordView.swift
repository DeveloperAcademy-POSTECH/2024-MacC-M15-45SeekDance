//
//  myRecordView.swift
//  StepSquad
//
//  Created by Groo on 10/22/25.
//

import SwiftUI

struct myRecordView: View {
    var body: some View {
        ZStack {
            Color.grey100
            
            ScrollView {
                VStack {
                    Button(action: {
                        
                    }, label: {
                        HStack {
                            Circle()
                                .frame(width: 60, height: 60)
                            
                            
                            VStack {
                                Text("계단 오르기 맹세한 지")
                                    .font(.callout)
                                    .foregroundStyle(Color(hex: 0xB1D998))
                                
                                HStack(spacing: 0) {
                                    Text("8222")
                                        .font(.largeTitle)
                                    
                                    Text("일차") // TODO: 글자 아래 맞춤
                                        .font(.title2)
                                }
                                .bold()
                                .foregroundStyle(.white)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color(hex: 0xB1D998))
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                        .background(Color(hex: 0x4C6D38))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    })
                    .padding(.top, 70)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    
                    Image("bag")
                    
                    VStack {
                        Text("획득 재료")
                            .bold()
                            .padding(.bottom, 8)
                        
                        Text("주의: 계단사랑단 앱을 실제 의학적 참고를 위해 활용하면 안 됩니다.")
                            .frame(width: 194)
                            .font(.caption2)
                            .foregroundStyle(.grey600)
                            .multilineTextAlignment(.center)
                    }
                    .frame(width: 360)
                    .padding(.vertical, 24)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(.white)
                    )
                    .padding(.horizontal, 16)
                    .offset(y: -30)
                    .padding(.bottom, 84)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    myRecordView()
}
