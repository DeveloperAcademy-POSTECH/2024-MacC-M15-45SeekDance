//
//  ShowMissionRewardView.swift
//  StepSquad
//
//  Created by Groo on 7/6/25.
//

import SwiftUI

struct ShowMissionRewardView: View {
    @Binding var isRewardViewPresented: Bool
    let gpsStaircase: GPSStaircase
    
    var body: some View {
        VStack(alignment: .center) {
            Image("ResultIMG")
                .resizable()
                .scaledToFit()
                .frame(width: 223, height: 223)
                .padding(.top, 164)
            
            Text(gpsStaircase.name)
                .font(.chosunTitleFont)
                .foregroundStyle(.green900)
                .multilineTextAlignment(.center)
                .padding(.bottom, 20)
            
            VStack {
                Text("\(gpsStaircase.province.rawValue)에 위치한")
                Text("전국의 계단을 올랐다!")
            }
            .foregroundStyle(.green700)
            
            HStack(spacing: 20) {
                GradientSquareView(text: gpsStaircase.reward, isWithSymbol: false)
                GradientSquareView(text: "\(gpsStaircase.steps)칸", isWithSymbol: true)
            }
            .padding(.top, 40)
            
            Spacer()
            
            Button(action: {
                isRewardViewPresented.toggle()
            }) {
                Text("계단 도전 인증하기")
                    .foregroundColor(.white)
                    .padding(.vertical, 14)
            }
            .frame(width: 320, height: 50)
            .background(.green800)
            .cornerRadius(12)
            .padding(.bottom, 32)
        }
        .ignoresSafeArea()
        .frame(maxWidth: .infinity)
        .background(Color.backgroundColor)
    }
}

struct GradientSquareView: View {
    let text: String
    let isWithSymbol: Bool
    var body: some View {
        VStack(spacing: 16) {
            Text("특별 점수")
                .font(.title3)
                .foregroundStyle(.green600)
            
            HStack(spacing: 8) {
                if (isWithSymbol) {
                    Image(systemName: "figure.stairs")
                        .resizable()
                        .scaledToFit()
                        .frame(height: 25)
                }
                Text(text)
            }
            .font(.title3)
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
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                ))
    }
}

#Preview {
    ShowMissionRewardView(isRewardViewPresented: .constant(true), gpsStaircase: gpsStaircasesDictionary["Gatbawi"]!)
}
