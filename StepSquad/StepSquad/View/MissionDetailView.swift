//
//  SwiftUIView.swift
//  StepSquad
//
//  Created by heesohee on 5/15/25.
//


import SwiftUI

struct MissionDetailView: View {
    @Binding var bookmarks: Bookmarks
    @Binding var collectedItems: CollectedItems
    let gpsStaircase: GPSStaircase
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                Image(gpsStaircase.imageName)
                    .resizable()
                    .aspectRatio(contentMode: .fill)
                    .frame(width: 394, height: 368)
                    .clipped()
                Spacer()
            }
            
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .clear, location: 0.2),
                    .init(color: Color(hex: 0x0C1806), location: 0.5)
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea()
            
            ScrollView {
                VStack {
                    Spacer(minLength: 207)
                    
                    HStack {
                        Text(gpsStaircase.province.rawValue)
                            .foregroundStyle(Color.white)
                            .font(.caption)
                            .padding(4)
                            .background(Color.Green600)
                            .cornerRadius(4)
                        Text("\(gpsStaircase.steps)칸")
                            .foregroundStyle(Color.Green800)
                            .font(.caption)
                            .padding(4)
                            .background(Color.Green50)
                            .cornerRadius(4)
                    }
                    
                    VStack(spacing: 10) {
                        Text(gpsStaircase.title)
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(Color.Grey100)
                            .padding(.bottom, -8)
                        
                        Text(gpsStaircase.name)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(.white)
                        
                        Text(gpsStaircase.description)
                            .font(.footnote)
                            .foregroundColor(Color.Grey100)
                    }
                    .padding(.bottom, 42)
                    
                    // 뱃지
                    if collectedItems.isCollected(item: gpsStaircase.id) {
                        VStack(alignment: .leading) {
                            HStack(spacing: 8) {
                                Image(systemName: "medal")
                                    .font(.title)
                                    .foregroundColor(Color.Green700)
                                
                                VStack(alignment: .leading) {
                                    Text("도전 완료된 계단")
                                        .font(.subheadline)
                                        .fontWeight(.bold)
                                        .foregroundColor(Color.Green900)
                                    
                                    Text("추가 점수는 계속 받을 수 있어요!")
                                        .font(.footnote)
                                        .foregroundColor(Color.Green800)
                                }
                            }
                            .padding(.leading, 16)
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
                    }
                    
                    // 인증 위치 & 획득 자료
                    HStack(spacing: 16) {
                        VStack(spacing: 12) {
                            Label {
                                Text("인증 위치")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(Color.Green700)
                            } icon: {
                                Image(systemName: "pin.fill")
                                    .font(.footnote)
                                    .foregroundColor(Color.Green700)
                            }
                            
                            Image(gpsStaircase.verificationLocationImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 124, height: 108)
                            
                            VStack(spacing: 4) {
                                Text(gpsStaircase.verificationLocation)
                                    .font(.caption)
                                    .bold()
                                VStack {
                                    Text("해당 위치 주변에서")
                                    Text("인증이 됩니다.")
                                }
                                .font(.caption2)
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
                                    .font(.footnote)
                                    .bold()
                                    .foregroundColor(Color.Green700)
                            } icon: {
                                Image(systemName: "leaf.fill")
                                    .font(.footnote)
                                    .foregroundColor(Color.Green700)
                            }
                            
                            Image(gpsStaircase.reweardImageName)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 124, height: 108)
                            
                            VStack(spacing: 4) {
                                Text(gpsStaircase.reward)
                                    .font(.caption)
                                    .bold()
                                VStack {
                                    Text("실제로 채취하진")
                                    Text("마세요.")
                                }
                                .font(.caption2)
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
            
            // 하단 버튼
            Button(action: {
            }) {
                HStack {
                    Spacer()
                    Text("계단 도전 인증하기")
                        .font(.body)
                        .foregroundColor(.white)
                    Spacer()
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 14)
            }
            .background(Color.Green800)
            .cornerRadius(12)
            .padding(.horizontal, 36)
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
                    if bookmarks.contains(gpsStaircase.id) {
                        bookmarks.remove(gpsStaircase.id)
                    } else {
                        bookmarks.add(gpsStaircase.id)
                    }
                }) {
                    Image(systemName: bookmarks.contains(gpsStaircase.id) ? "bookmark.fill" : "bookmark")
                        .foregroundStyle(.green500)
                }
            }
        }
        .navigationBarTitleDisplayMode(.inline)
    }
}

//#Preview {
//    MissionDetailView()
//}
