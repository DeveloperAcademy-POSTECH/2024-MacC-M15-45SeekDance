//
//  GPSStaircaseMainView.swift
//  StepSquad
//
//  Created by Groo on 5/6/25.
//

import SwiftUI

struct GPSStaircaseMainView: View {
    var body: some View {
        ScrollView {
            VStack(spacing: 0) {
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
                            .padding(.top, 122)
                        
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
                            .background(RoundedRectangle(cornerRadius: 12).fill(.green500))
                        })
                        .padding(.bottom, 40)
                    }
                }
                .frame(height: 444)
                .frame(maxWidth: .infinity)
                .background(.green200)
                
                ProfileView()
                
                VStack {
                    Text("미션")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.green700))
                    VStack(spacing: 4) {
                        Text("전국의 계단 오르고 인증하자!")
                            .font(.title3)
                            .bold()
                        Text("특별 재료에 점수 2배 이벤트")
                            .font(.footnote)
                        Text("(계단 오르기 점수 + 특별 계단 점수)")
                            .font(.caption2)
                            .foregroundStyle(.grey600)
                    }
                    .padding(.top, 12)
                }
                .padding(.top, 26)
                
                VStack {
                    Text("참여 방법")
                        .font(.subheadline)
                        .bold()
                        .foregroundStyle(.white)
                        .padding(10)
                        .background(RoundedRectangle(cornerRadius: 20).fill(.green700))
                        .padding(.top, 16)
                    
                    HStack(spacing: 32) {
                        VStack {
                            Image("authenticationExample1")
                            Text("인증 장소를 확인한 gn 직접 방문한다")
                                .font(.footnote)
                                .frame(width: 120)
                        }
                        
                        VStack {
                            Image("authenticationExample2")
                            Text("해당 계단 하단의 인증하기를 탭!")
                                .font(.footnote)
                                .frame(width: 120)
                        }
                    }
                    .padding(.top, 26)
                    .multilineTextAlignment(.center)
                    
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .frame(height: 289)
                .background(RoundedRectangle(cornerRadius: 12).fill(.white))
                .padding(.top, 40)
                
                Spacer()
            }
        }
        .ignoresSafeArea()
        .background(.green50)
    }
}

struct ProfileView: View {
    var body: some View {
        HStack {
            Circle()
                .foregroundStyle(.blue200)
                .frame(width: 60, height: 60)
                .padding(.trailing, 12)
            VStack(alignment: .leading) {
                Text("🍎저속노화처돌이")
                    .font(.headline)
                    .padding(.bottom, 4)
                HStack(spacing: 0) {
                    Text("방문한 계단 ")
                        .font(.footnote)
                    Text("2개 / 24개")
                        .font(.footnote)
                        .bold()
                }
            }
            .foregroundStyle(.white)
            Spacer()
        }
        .frame(height: 84)
        .padding(.horizontal, 16)
        .background(.green900)
    }
}

#Preview {
    GPSStaircaseMainView()
}
