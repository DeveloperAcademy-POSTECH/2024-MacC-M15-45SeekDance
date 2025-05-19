//
//  SwiftUIView.swift
//  StepSquad
//
//  Created by heesohee on 5/15/25.
//


import SwiftUI

struct MissionDetailView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        ZStack(alignment: .bottom) {
            // [1] 배경 그라디언트 (전체 화면에 깔림)
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0.0),
                    .init(color: .DeepGreen.opacity(0.0), location: 0.1),
                    .init(color: .DeepGreen.opacity(0.2), location: 0.28),
                    .init(color: .DeepGreen.opacity(0.34), location: 0.3),
                    .init(color: .DeepGreen.opacity(0.8), location: 0.35),
                    .init(color: .DeepGreen.opacity(1.0), location: 0.4),
                    .init(color: .DeepGreen.opacity(1.0), location: 1.0)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            // [2] 콘텐츠
            VStack(spacing: 0) {
                // 메인 콘텐츠
                ScrollView {
                    VStack(spacing: 0) {
                        // 이미지 + 텍스트
                        ZStack(alignment: .bottom) {
                            Image("Gatbawi")
                                .resizable()
                                .aspectRatio(contentMode: .fill)
                                .frame(width: 394, height: 368)
                                .clipped()
                            
                            LinearGradient(
                                gradient: Gradient(stops: [
                                    .init(color: .clear, location: 0.0),
                                    .init(color: .DeepGreen.opacity(0.0), location: 0.1),
                                    .init(color: .DeepGreen.opacity(0.2), location: 0.4),
                                    .init(color: .DeepGreen.opacity(1.0), location: 1.0)
                                ]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                            .ignoresSafeArea()
                            
                            VStack(spacing: 10) {
                                HStack {
                                    Text("대구/경북")
                                        .foregroundStyle(Color.white)
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.Green600)
                                        .cornerRadius(4)
                                    Text("1365칸")
                                        .foregroundStyle(Color.Green800)
                                        .font(.caption)
                                        .padding(4)
                                        .background(Color.Green50)
                                        .cornerRadius(4)
                                }
                                
                                Text("소원을 이뤄줘요")
                                    .font(.body)
                                    .fontWeight(.regular)
                                    .foregroundColor(Color.Grey100)
                                    .padding(.bottom, -8)
                                
                                Text("팔공산 갓바위")
                                    .font(.title)
                                    .fontWeight(.bold)
                                    .foregroundColor(.white)
                                
                                Text("대구에 위치한 엄청난 높이의 돌계단")
                                    .font(.footnote)
                                    .foregroundColor(Color.Grey100)
                            }
                            .padding(.bottom, 42)
                        }
                        
                        // 뱃지
                        VStack(alignment: .leading) {
                            HStack(spacing: 12) {
                                Image(systemName: "medal")
                                    .font(.system(size: 24, weight: .semibold))
                                    .foregroundColor(Color.Green700)
                                
                                VStack(alignment: .leading, spacing: 4) {
                                    Text("도전 완료된 계단")
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.Green900)
                                    
                                    Text("추가 점수는 계속 받을 수 있어요!")
                                        .font(.footnote)
                                        .foregroundColor(Color.Green800)
                                }
                            }
                            .padding(.leading, 20)
                            .padding(.vertical, 12)
                        }
                        .frame(width: 312, height: 72, alignment: .leading)
                        .background(Color.white)
                        .cornerRadius(12)
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.Green600, lineWidth: 1)
                        )
                        .padding(.bottom, 20)
                        
                        // 인증 위치 & 획득 자료
                        HStack(spacing: 16) {
                            VStack(spacing: 12) {
                                Label {
                                    Text("인증 위치")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(Color.Green700)
                                } icon: {
                                    Image(systemName: "pin.fill")
                                        .foregroundColor(Color.Green700)
                                }
                                
                                Image("Gatbawi_location")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 108)
                                
                                VStack(spacing: 2) {
                                    Text("갓바위 정상 앞")
                                        .font(.subheadline)
                                        .bold()
                                    Text("해당 위치 주변에서 인증이 됩니다.")
                                        .font(.caption)
                                        .foregroundColor(Color.Grey500)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(12)
                            .frame(width: 148, height: 220)
                            .background(Color.white)
                            .cornerRadius(4)
                            
                            VStack(spacing: 12) {
                                Label {
                                    Text("획득 재료")
                                        .font(.subheadline)
                                        .bold()
                                        .foregroundColor(Color.Green700)
                                } icon: {
                                    Image(systemName: "leaf.fill")
                                        .foregroundColor(Color.Green700)
                                }
                                
                                Image("Gatbawi_reward")
                                    .resizable()
                                    .scaledToFit()
                                    .frame(width: 124, height: 108)
                                
                                VStack(spacing: 2) {
                                    Text("갓바위 돌가루")
                                        .font(.subheadline)
                                        .bold()
                                    Text("실제로 채취하진 마세요.")
                                        .font(.caption)
                                        .foregroundColor(Color.Grey500)
                                        .multilineTextAlignment(.center)
                                }
                            }
                            .padding(12)
                            .frame(width: 148, height: 220)
                            .background(Color.white)
                            .cornerRadius(4)
                        }
                    }
                }
            }
            
            // 하단 버튼
            Button(action: {
            }) {
                Text("계단 도전 인증하기")
                    .font(.headline)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(Color.Green800)
                    .cornerRadius(12)
                    .padding(.horizontal)
            }
            .padding(.vertical)
        }
        .toolbar {
            // TODO: 공유 기능 추가
//            ToolbarItem(placement: .topBarTrailing) {
//                Button(action: {}) {
//                    Image(systemName: "square.and.arrow.up")
//                        .font(.system(size: 22))
//                        .foregroundColor(Color.Green700)
//                }
//            }
            ToolbarItem(placement: .topBarTrailing) {
                Button(action: {
                    // TODO: 북마크 기능 추가
                }) {
                    Image(systemName: "bookmark")
                        .font(.system(size: 22))
                        .foregroundColor(Color.Green700)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

#Preview {
    MissionDetailView()
}
