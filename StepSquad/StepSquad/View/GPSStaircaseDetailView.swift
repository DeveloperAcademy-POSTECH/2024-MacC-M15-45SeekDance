//
//  SwiftUIView.swift
//  StepSquad
//
//  Created by heesohee on 5/15/25.
//


import SwiftUI
import CoreLocation
import CoreLocationUI

struct GPSStaircaseDetailView: View {
    @Binding var bookmarks: Bookmarks
    @Binding var collectedItems: CollectedItems
    @Binding var gpsStaircaseWeeklyScore: GPSStaircaseWeeklyScore
    
    let gpsStaircase: GPSStaircase
    
    let locationManager: LocationManager
    @State private var currentLocation: CLLocationCoordinate2D?
    
    @State private var isAtLocation: Bool = false
    @State private var isShowingMissionSheet: Bool = false
    @State private var isShowingRewardSheet: Bool = false
    
    let gameCenterManager: GameCenterManager
    
    @Binding var isShowingNewItem: Bool
    
    var body: some View {
        NavigationStack {
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
                    isShowingMissionSheet = true
                    Task {
                        if let location = try? await locationManager.requestLocation() {
                            currentLocation = location
                            print("Location: \(location)")
                            if (locationManager.compareLocations(staircaseLongitude: gpsStaircase.longitude, staircaseLatitude: gpsStaircase.latitude, currentLongitude: currentLocation!.longitude, currentLatitude: currentLocation!.latitude)) {
                                isAtLocation = true
                            } else {
                                isAtLocation = false
                            }
                        } else {
                            // TODO: location을 못 부를 때, 권한이 없을 때 나타낼 것 고민
                            print("위치 문제")
                        }
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
                    if (currentLocation == nil) {
                        Spacer()
                        
                        ProgressView()
                        
                        Text("나의 위치 확인 중")
                            .foregroundStyle(.secondary)
                        
                        Spacer()
                    } else {
                        HStack {
                            Text("계단 인증 도전하기")
                                .font(.title3)
                                .bold()
                            
                            Spacer()
                        }
                        .frame(height: 56)
                        
                        Spacer()
                        
                        if (isAtLocation) { // 위치 인증을 성공했을 때
                            VerifiedLocationView(gpsStaircase: gpsStaircase, isShowingMissionSheet: $isShowingMissionSheet, isShowingRewardSheet: $isShowingRewardSheet, gameCenterManager: gameCenterManager, collectedItems: $collectedItems, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, isShowingNewItem: $isShowingNewItem)
                        } else { // 위치 인증을 성공하지 못 했을 때
                            FailedLocationView(locationManager: locationManager, currentLocation: $currentLocation, isAtLocation: $isAtLocation, gpsStaircase: gpsStaircase)
                        }
                    }
                }
                .presentationDetents([.medium])
                .padding(.horizontal, 16)
            }
            .onAppear {
                locationManager.requestAlwaysAuthorization()
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
}

struct VerifiedLocationView: View {
    let gpsStaircase: GPSStaircase
    @Binding var isShowingMissionSheet: Bool
    @Binding var isShowingRewardSheet: Bool
    
    let gameCenterManager: GameCenterManager
    
    @Binding var collectedItems: CollectedItems
    @Binding var gpsStaircaseWeeklyScore: GPSStaircaseWeeklyScore
    
    @Binding var isShowingNewItem: Bool
    
    var body: some View {
        VStack {
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
                isShowingRewardSheet = true
            }, label: {
                HStack {
                    Spacer()
                    Text("리워드 얻기")
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                    Spacer()
                }
            })
            .frame(width: 315)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.green800)
            )
            .fullScreenCover(isPresented: $isShowingRewardSheet, content: {
                ShowMissionRewardView(isRewardViewPresented: $isShowingRewardSheet, gpsStaircase: gpsStaircase)
            })
        }
        .onAppear {
            // TODO: 성취 현지화 설정
            Task {
                // TODO: 오른 계단 정보(HealthKit) 합산하기
                gpsStaircaseWeeklyScore.addScore(score: gpsStaircase.steps)
                await gameCenterManager.submitPoint(point: gpsStaircaseWeeklyScore.getWeeklyScore())
            }
            if (!collectedItems.isCollected(item: gpsStaircase.id)) {
                gameCenterManager.reportCompletedAchievement(achievementId: gpsStaircase.achievementId)
                collectedItems.collectItem(item: gpsStaircase.id, collectedDate: Date.now)
                isShowingNewItem = true
            }
        }
    }
}

struct FailedLocationView: View {
    let locationManager: LocationManager
    @Binding var currentLocation: CLLocationCoordinate2D?
    @Binding var isAtLocation: Bool
    let gpsStaircase: GPSStaircase
    var body: some View {
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
                Task {
                    currentLocation = nil
                    if let location = try? await locationManager.requestLocation() {
                        currentLocation = location
                        print("Location: \(location)")
                        if (locationManager.compareLocations(staircaseLongitude: gpsStaircase.longitude, staircaseLatitude: gpsStaircase.latitude, currentLongitude: currentLocation!.longitude, currentLatitude: currentLocation!.latitude)) {
                            isAtLocation = true
                        } else {
                            isAtLocation = false
                        }
                    } else {
                        // TODO: location을 못 부를 때, 권한이 없을 때 나타낼 것 고민
                        print("위치 문제")
                    }
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

//#Preview {
//    MissionDetailView()
//}
