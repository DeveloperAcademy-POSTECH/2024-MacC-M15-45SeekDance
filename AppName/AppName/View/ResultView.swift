//
//  ResultView.swift
//  Gari
//
//  Created by heesohee on 10/29/24.
//


import SwiftUI

struct ResultView: View {
    @Binding var isResultViewPresented: Bool
    var thisMonthStairCount: Int

    var body: some View {
        ZStack {
            // Background
            Color.white.ignoresSafeArea()
            
            VStack(alignment: .center) { // 전체 VStack
                
                // 칭찬 관련 이미지 들어갈 자리
                RoundedRectangle(cornerRadius: 20)
                    .foregroundStyle(.secondary)
                    .frame(width: 240, height: 240)
                    .padding(.top, 10)
                
                Text("당신을 응원합니다!")
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(.top, 20)
                
                Text("이번 달에 이만큼 아꼈어요!")
                    .multilineTextAlignment(.center)
                    .fontWeight(.regular)
                    .font(.title3)
                    .padding(.top, 20)
                
                // HStack 카드
                HStack {
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // 카드 텍스트
                        Text("전기 소비량")
                            .font(.headline)
                            .foregroundColor(.primary)
                        HStack {
                            Text("\(thisMonthStairCount*30)")
                                .font(.headline)
                            Text("Wh")
                                .font(.headline)
                        }
                        .foregroundColor(.orange)
                        
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                    .frame(width: 150, height: 120) // 카드 크기
                    
                    VStack(alignment: .leading, spacing: 10) {
                        
                        // 카드 텍스트
                        Text("탄소 발자국")
                            .font(.headline)
                            .foregroundColor(.primary)
                        
                        HStack {
                            Text(String(format: "%.1f", Double(thisMonthStairCount)*12.7))
                                .font(.headline)
                            Text("g")
                                .font(.headline)
                        }
                        .foregroundColor(.green)
                    }
                    .padding()
                    .background(Color.white)
                    .cornerRadius(15)
                    .shadow(color: .gray.opacity(0.3), radius: 5, x: 0, y: 5)
                    .frame(width: 150, height: 120) // 카드 크기
                    
                } // HStack 카드
                
                Text("출처: 탄소중립포인트 에너지")
                    .fontWeight(.regular)
                    .font(.footnote)
                    .foregroundColor(Color.secondary)
                
                Button(action: {
                    isResultViewPresented.toggle()
                }) {
                    Text("확인")
                        .foregroundColor(.white)
                        .font(.body)
                        .fontWeight(.regular)
                        .frame(width: 320, height: 50)
                        .background(Color.indigo)
                        .cornerRadius(12)
                }
                .padding(.top, 40)
                
            } // 전체 VStack
            .padding(.horizontal, 40)
            .padding(.top, 90)
            .padding(.bottom, 70)
        } // ZStack // 배경색
    }
}

