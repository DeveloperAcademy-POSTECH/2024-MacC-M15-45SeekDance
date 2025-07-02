//
//  SwiftUIView.swift
//  StepSquad
//
//  Created by heesohee on 5/15/25.
//


import SwiftUI

struct GPSStaircaseDetailView: View {
    @Binding var bookmarks: Bookmarks
    @Binding var collectedItems: CollectedItems
    let gpsStaircase: GPSStaircase
    @State private var isShowingMissionSheet: Bool = false
    
    let locationManager: LocationManager
    @State var verificationResult: VerifyLocationState? = nil
    
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
                                    Text("실제로 가져가진")
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
                    
                    Spacer(minLength: 100)
                }
            }
            .scrollIndicators(.hidden)
            
            // 하단 버튼
            Button(action: {
                locationManager.requestAlwaysAuthorization() // TODO: 위치 변경
                Task {
                    verificationResult = await locationManager.verifyLocation(gpsStaircaseLatitude: gpsStaircase.latitude, gpsStaircaseLongitude: gpsStaircase.longitude)
                    print("1 verificationResult 수정")
                    isShowingMissionSheet = true
                    print("2 isShowingMissionSheet ture")
                }
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
        .sheet(isPresented: $isShowingMissionSheet) {
            VStack {
                HStack {
                    Text("계단 인증 도전하기")
                        .font(.title3)
                        .bold()
                    Spacer()
                    Button(action: {
                        isShowingMissionSheet = false
                    }) {
                        XCircleButtonView()
                    }
                }
                if (verificationResult == .verified) { // 위치 인증을 성공했을 때
                    Image("WinBird")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170, height: 170)
                        .padding(.bottom, 19)
                    
                    Text(gpsStaircase.name)
                        .font(.title2)
                        .bold()
                        .foregroundStyle(.green800)
                        .padding(.bottom, 4)
                    
                    Text(gpsStaircase.title)
                        .foregroundStyle(.grey700)
                        .padding(.bottom, 15)
                    
                    Button(action: {
                        // TODO: 리워드 얻기 뷰로 이동
                    }, label: {
                        Text("리워드 얻기")
                            .foregroundStyle(.white)
                            .padding(.vertical, 14)
                    })
                    .frame(width: 315)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .foregroundStyle(.green800)
                    )
                } else { // 위치 인증을 성공하지 못 했을 때
                    Image("ShakeBird")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 170, height: 170)
                        .padding(.bottom, 16)
                    
                    Text("인증 위치에서 인증해주세요.")
                        .font(.title3)
                        .bold()
                        .padding(.bottom, 8)
                    
                    Text("인증 위치에서도 해당 창이 뜬다면 하단의 새로고침을 눌러주세요.")
                        .font(.callout)
                        .foregroundStyle(.grey700)
                        .frame(width: 219)
                        .multilineTextAlignment(.center)
                        .padding(.bottom, 16)
                    
                    Button(
                        action: {
                        // TODO: 위치 정보 새로 불러오기
                            Task {
                                verificationResult = await locationManager.verifyLocation(gpsStaircaseLatitude: gpsStaircase.latitude, gpsStaircaseLongitude: gpsStaircase.longitude)
                            }
                    }, label: {
                        HStack {
                            Spacer()
                            Text("위치 정보 새로고침")
                                .foregroundStyle(.green700)
                                .padding(.vertical, 14)
                            Spacer()
                        }
                    })
                }
            }
            .onAppear {
                print("3 bottom sheet 나타내기, verificationResult: \(verificationResult)")
            }
            .presentationDetents([.medium])
            .padding(.horizontal, 16)
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
