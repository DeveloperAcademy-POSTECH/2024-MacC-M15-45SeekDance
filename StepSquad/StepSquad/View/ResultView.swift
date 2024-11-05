//
//  ResultView.swift
//  Gari
//
//  Created by heesohee on 10/29/24.
//


import SwiftUI

struct ResultView: View {
    @Binding var isResultViewPresented: Bool
    var stairName: String
    var stairCount: Int
    var thisMonthStairCount: Int

    var body: some View {
        ZStack {
            Color.back.ignoresSafeArea()

            VStack(alignment: .center) {
                Image("ResultIMG")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 240)
                    .cornerRadius(12)

                Text("\(stairCount)개 계단!")
                    .multilineTextAlignment(.center)
                    .fontWeight(.bold)
                    .font(.largeTitle)
                    .padding(.top, 32)
                    .foregroundColor(Color(red: 0.35, green: 0.34, blue: 0.84))

                Text("\(stairName)")
                    .font(Font.custom("SF Pro", size: 20))
                    .multilineTextAlignment(.center)
                    .padding(.top, 5)
                    .foregroundColor(Color(red: 0.61, green: 0.61, blue: 0.61))

                Text("이번 달에 이만큼 아꼈어요!")
                    .font(Font.custom("SF Pro", size: 16))
                    .padding(.top, 28)

                HStack {
                    VStack(alignment: .center, spacing: 0) {
                        Text("전기 소비량")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.bottom, 16)

                        Text("\(thisMonthStairCount*30)Wh")
                            .font(.headline)
                            .foregroundColor(.orange)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(15)
                    .frame(width: 150, height: 120)

                    VStack(alignment: .center, spacing: 0) {
                        Text("탄소 발자국")
                            .font(.headline)
                            .foregroundColor(.primary)
                            .padding(.bottom, 16)

                        Text(String(format: "%.1f", Double(thisMonthStairCount)*12.7) + "g")
                            .font(.headline)
                            .foregroundColor(.green)
                    }
                    .padding(12)
                    .background(Color.white)
                    .cornerRadius(15)
                    .frame(width: 150, height: 120)
                }

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

            }
            .padding(.horizontal, 40)
            .padding(.top, 80)
            .padding(.bottom, 70)
        }
    }
}

