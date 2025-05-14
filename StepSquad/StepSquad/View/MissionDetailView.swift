//
//  SwiftUIView.swift
//  StepSquad
//
//  Created by heesohee on 5/15/25.
//


import SwiftUI

struct MissionDetailView: View {
    var body: some View {
        
        @Environment(\.presentationMode) var presentationMode
        
        VStack(spacing: 0) {
            // MARK: 커스텀 상단 바
            HStack {
                // MARK: 뒤로가기 버튼
                Button(action: {
                    // dismiss()로 뒤로 가기
                    presentationMode.wrappedValue.dismiss()
                }) {
                    Image(systemName: "chevron.left")
                        .font(.system(size: 22))
                        .foregroundColor(Color.Green700)
                        .padding(10)
                }
                
                Spacer()
                
                HStack {
                    // MARK: 공유 버튼
                    Button(action: {
                    }) {
                        Image(systemName: "square.and.arrow.up")
                            .font(.system(size: 22))
                            .foregroundColor(Color.Green700)
                            .padding(10)
                    }
                    
                    // MARK: 즐겨찾기 버튼
                    Button(action: {
                    }) {
                        Image(systemName: "bookmark")
                            .font(.system(size: 22))
                            .foregroundColor(Color.Green700)
                            .padding(10)
                    }
                }
            }
            
            // MARK: 상단바 아래 스크롤 뷰
            ScrollView {
                ZStack(alignment: .bottom) {
                    
                    Image("Gatbawi")
                        .resizable()
                        .aspectRatio(contentMode: .fill)
                        .frame(width: 393,height: 368)
                        .clipped()
                        .overlay(
                            LinearGradient(
                                gradient: Gradient(colors: [.clear, .black.opacity(0.93)]),
                                startPoint: .top,
                                endPoint: .bottom
                            )
                        )
                    
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
                
                
                // MARK: 미션 완료 뱃지
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
                    .padding(.leading, 20) // 왼쪽 여백
                    .padding(.vertical, 12) // 상하 여백
                }
                .frame(width: 312, height: 72, alignment: .leading)
                .background(Color.white)
                .cornerRadius(12)
                .overlay(
                    RoundedRectangle(cornerRadius: 12)
                        .stroke(Color.Green600, lineWidth: 1)
                )
                .padding(12)
                
                
                
                // MARK: 인증 위치 & 획득 자료
                HStack(spacing: 16) {
                    // MARK: 인증 위치 카드
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
                    
                    // MARK: 획득 재료 카드
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
            
            // MARK: 인증 버튼
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
        .background(Color.Green50)
        .navigationBarTitleDisplayMode(.inline)
//        .navigationBarBackButtonHidden(false)
    }
}

#Preview {
    MissionDetailView()
}


