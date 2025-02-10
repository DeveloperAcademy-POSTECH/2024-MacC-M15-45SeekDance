//
//  ResultView.swift
//  Gari
//
//  Created by heesohee on 10/29/24.
//


import SwiftUI

struct ResultView: View {
    @Binding var isResultViewPresented: Bool
    
    var stairName: String = "포스텍 78 계단"
    var stairCount: Int = 78
    var materialName: String = "불로초"

    var body: some View {
        ZStack {
            Color.backgroundColor

            VStack(alignment: .center) {
                Text("재료 획득")
                    .font(.system(size: 28, weight: .bold))
                    .foregroundStyle(.green600)

                Image("ResultIMG")
                    .resizable()
                    .scaledToFit()
                    .frame(maxHeight: 223)

                Text("\(materialName)")
                    .font(.chosunFont)
                    .foregroundStyle(.green900)

                Text("\(stairName)의 \(stairCount)칸을 걸었어요!")
                    .font(.system(size: 17))
                    .foregroundStyle(.green700)

                VStack(spacing: 8) {
                    Text("특별 점수")
                        .font(.system(size: 20))
                        .foregroundStyle(.green600)

                    HStack() {
                        Image(systemName: "figure.stairs")
                        Text("\(stairCount)칸")
                    }
                    .font(.system(size: 22))
                    .foregroundStyle(.green900)
                }
                .padding(16)
                .background(Color.white,
                            in: RoundedRectangle(cornerRadius: 12))
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .inset(by: 1)
                        .stroke(
                            LinearGradient(
                                gradient: Gradient(colors: [.green600, .green900]),
                                startPoint: .topLeading,
                                endPoint: .bottomTrailing
                            ),
                            lineWidth: 2
                        ))
                .padding(.top, 40)

                Spacer()

                Button(action: {
                    isResultViewPresented.toggle()
                }) {
                    Text("확인")
                        .foregroundColor(.white)
                        .font(.body)
                        .fontWeight(.regular)
                        .frame(width: 320, height: 50)
                        .background(.brown600)
                        .cornerRadius(12)
                }
                .padding(.top, 4)
            }
            .padding(.horizontal, 40)
            .padding(.top, 104)
            .padding(.bottom, 70)
        }
        .ignoresSafeArea()
    }
}
