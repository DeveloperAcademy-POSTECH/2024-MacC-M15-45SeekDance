//
//  NewBirdView.swift
//  StepSquad
//
//  Created by Groo on 1/21/25.
//

import SwiftUI
import EffectsLibrary
import RiveRuntime

struct ShowNewBirdView: View {
    @Binding var isShowNewBirdPresented: Bool
    let days: Int
    let stairs: Int
    
    @State var timeCount = 0
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var opacity1 = 1.0
    @State var opacity2 = 0.0
    @State var opacity3 = 0.0
    @State var opacity4 = 0.0
    @State var opacity5 = 0.0
    @State var opacity6 = 1.0
    let viewChangeTime = 4
    
    var body: some View {
        ZStack {
            ItemsConfettiView(days: days, stairs: stairs)
                .opacity(opacity1)
                .animation(.linear(duration: 1), value: opacity1)
            NewBirdView(isShowNewBirdPresented: $isShowNewBirdPresented, viewChangeTime: viewChangeTime, opacityFirstText: $opacity3, opacitySecondText: $opacity4, opacityThirdText: $opacity5)
                .opacity(opacity2)
                .animation(.linear(duration: 1), value: opacity2)
            VStack {
                HStack {
                    Spacer()
                    Button(action: {
                        isShowNewBirdPresented = false
                    }) {
                        Image(systemName: "x.circle.fill")
                            .resizable()
                            .frame(width: 30, height: 30)
                            .foregroundColor(.secondary)
                    }
                    .padding(.horizontal, 35)
                    .opacity(opacity6)
                }
                .padding(.top, 42)
                Spacer()
            }
        }
        .ignoresSafeArea()
        .onReceive(timer) { _ in
            timeCount += 1
            if timeCount == viewChangeTime {
                opacity1 = 0.0
            } else if timeCount == viewChangeTime + 1 {
                opacity2 = 1.0
                opacity3 = 1.0
            } else if timeCount == viewChangeTime + 3 {
                opacity3 = 0.0
                opacity4 = 1.0
            } else if timeCount == viewChangeTime + 6 {
                opacity4 = 0.0
                opacity5 = 1.0
                opacity6 = 0.0
            }
        }
    }
}

#Preview {
    ShowNewBirdView(isShowNewBirdPresented: .constant(true), days: 263, stairs: 1456)
}

struct ItemsConfettiView: View {
    let days: Int
    let stairs: Int
    
    var body: some View {
        ZStack {
            ConfettiView(config:
                            ConfettiConfig(
                                content: [
                                    .image(Image("1_Gamcho").asUIImage(), .white, 0.02),
                                    .image(Image("2_Daechu").asUIImage(), .white, 0.02),
                                    .image(Image("3_Saenggang").asUIImage(), .white, 0.02),
                                    .image(Image("4_Doraji").asUIImage(), .white, 0.02),
                                    .image(Image("8_Chik").asUIImage(), .white, 0.02),
                                    .image(Image("9_Oksususuyeom").asUIImage(), .white, 0.02),
                                    .image(Image("10_Insam").asUIImage(), .white, 0.02),
                                    .image(Image("12_Gugija").asUIImage(), .white, 0.02),
                                    .image(Image("13_Sansuyu").asUIImage(), .white, 0.02),
                                ],
                                intensity: .low
                            )
            )
            LinearGradient(colors: [.white, .white,  .clear], startPoint: .top, endPoint: .center)
            VStack {
                VStack {
                    HStack(spacing: 0) {
                        Text("\(days)")
                            .foregroundStyle(Color(hex: 0x7EB55D))
                        Text("일 동안")
                        Text(" \(stairs)")
                            .foregroundStyle(Color(hex: 0x7EB55D))
                        Text("층을")
                    }
                    Text("함께 오른 틈새가")
                    Text("하산을 했어요!")
                }
                .font(.title)
                .fontWeight(.bold)
                .padding(.top, 158)
                Image("Down1")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 256)
                    .padding(.top, 66)
                Spacer()
            }
        }
    }
}

struct NewBirdView: View {
    @Binding var isShowNewBirdPresented: Bool
    let viewChangeTime: Int
    @Binding var opacityFirstText: Double
    @Binding var opacitySecondText: Double
    @Binding var opacityThirdText: Double
    var body: some View {
        ZStack {
            VStack {
                ZStack(alignment: .top) {
                    FirstText()
                        .opacity(opacityFirstText)
                    SecondText()
                        .opacity(opacitySecondText)
                    ThirdText()
                        .opacity(opacityThirdText)
                }
                .padding(.top, 158)
                Spacer()
            }
            VStack {
                RiveViewModel(fileName: "reset").view()
                    .frame(width: 256, height: 256)
                    .padding(.top, 326)
                Spacer()
            }
            VStack {
                Spacer()
                Button(action: {
                    isShowNewBirdPresented = false
                }, label: {
                    HStack {
                        Text("새 틈새와 함께하기")
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(.white)
                            .padding()
                    }
                    .background(.green600)
                    .cornerRadius(12)
                })
                .padding(.bottom, 38)
                .padding(.horizontal, 28)
                .opacity(opacityThirdText)
            }
        }
        .animation(.easeInOut(duration: 0.5))
    }
}

struct FirstText: View {
    var body: some View {
        VStack {
            Text("틈새가 떠나")
            Text("빈 둥지가 되었어요")
        }
        .font(.title)
        .fontWeight(.bold)
    }
}

struct SecondText: View {
    var body: some View {
        Text("앗 뭐지??")
            .font(.title)
            .fontWeight(.bold)
            .foregroundStyle(.green700)
    }
}

struct ThirdText: View {
    var body: some View {
        VStack {
            VStack {
                Text("하산한 틈새가 떠나고")
                HStack(spacing: 0) {
                    Text("새로운 틈새")
                        .foregroundStyle(.green600)
                    Text("가 왔어요!")
                }
            }
            .font(.title)
            .fontWeight(.bold)
            Text("같은 틈새 아닌가 하는 마음이 든다면 그건 착각이에요")
                .frame(width: 256)
                .multilineTextAlignment(.center)
                .padding(.top, 16)
        }
    }
}
