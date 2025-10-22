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
                    
                    ZStack {
                        RoundedRectangle(cornerRadius: 100)
                            .frame(height: 1000)
                            .foregroundStyle(.white)
                    }
                    .padding(.horizontal, 16)
                    .offset(y: -30)
                }
            }
        }
        .ignoresSafeArea()
    }
}

#Preview {
    myRecordView()
}
