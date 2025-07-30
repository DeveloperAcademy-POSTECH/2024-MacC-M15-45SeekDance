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
    @AppStorage("isVerificationActive") var isVerificationActive: Bool = true
    
    @AppStorage("lastVerificationTime") var lastVerificationTime: Date = dateFormatter.date(from: "2000-01-01")!
    let timer = Timer.publish(every: 1, on: .main, in: .common).autoconnect()
    @State var timeDifference: Int = 0
    let timeLimit: Int = 60 * 5
    
    let gameCenterManager: GameCenterManager
    
    @Binding var isShowingNewItem: Bool
    
    @ObservedObject var healthkitService: HealthKitService
    
    @Environment(\.scenePhase) var scenePhase
    
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
                
                Button(action: {
                    if (locationManager.getAuthorizationStatus() == .authorizedAlways || locationManager.getAuthorizationStatus() == .authorizedWhenInUse) { // 위치 권한 사용을 허가했을 경우
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
                                print("Error: 위치 인증 불가")
                            }
                        }
                    } else if (locationManager.getAuthorizationStatus() == .denied) { // 위치 권한을 거절한 경우
                        if let url = URL(string: UIApplication.openSettingsURLString) {
                            UIApplication.shared.open(url)
                        }
                    } else { // 위치 권한을 결정하지 않은 경우
                        locationManager.requestAlwaysAuthorization()
                    }
                }) {
                    HStack {
                        Spacer()
                        if (locationManager.getAuthorizationStatus() == .authorizedAlways || locationManager.getAuthorizationStatus() == .authorizedWhenInUse) {
                            Text(isVerificationActive ? "계단 도전 인증하기" : "\((timeLimit -  timeDifference) / 60)분 \((timeLimit -  timeDifference) % 60)초 후에 인증하기")
                                .font(.body)
                                .foregroundColor(.white)
                        } else {
                            Text("위치 권한 허용하기")
                                .font(.body)
                                .foregroundColor(.white)
                        }
                        Spacer()
                    }
                    .padding(.horizontal, 20)
                    .padding(.vertical, 14)
                }
                .disabled(!isVerificationActive)
                .onReceive(timer) {_ in
                    if (!isVerificationActive) {
                        // MARK: 마지막 인증 시간과 현재 시간을 차이를 계산하여 인증 허용하기
                        timeDifference = Int(lastVerificationTime.distance(to: Date.now))
                        if (timeDifference > timeLimit) {
                            isVerificationActive = true
                        }
                    }
                }
                .background(isVerificationActive ? Color.Green800: .secondary)
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
                        if (isAtLocation) { // 위치 인증을 성공했을 때
                            VerifiedLocationView(gpsStaircase: gpsStaircase, isShowingMissionSheet: $isShowingMissionSheet, gameCenterManager: gameCenterManager, collectedItems: $collectedItems, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, isShowingNewItem: $isShowingNewItem, isVerificationActive: $isVerificationActive, healthKitService: healthkitService, lastVerificationTime: $lastVerificationTime)
                        } else { // 위치 인증을 성공하지 못 했을 때
                            FailedLocationView(locationManager: locationManager, currentLocation: $currentLocation, isAtLocation: $isAtLocation, isShowingMissionSheet: $isShowingMissionSheet, gpsStaircase: gpsStaircase)
                        }
                    }
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
}

struct VerifiedLocationView: View {
    let gpsStaircase: GPSStaircase
    @Binding var isShowingMissionSheet: Bool
    
    let gameCenterManager: GameCenterManager
    
    @Binding var collectedItems: CollectedItems
    @Binding var gpsStaircaseWeeklyScore: GPSStaircaseWeeklyScore
    
    @Binding var isShowingNewItem: Bool
    @Binding var isVerificationActive: Bool
    
    @ObservedObject var healthKitService: HealthKitService
    
    @Binding var lastVerificationTime: Date
    
    @State private var animationAmount = 0.0
    var body: some View {
        VStack {
            Text("전국의 계단 성공!")
                .font(.title3)
                .bold()
                .foregroundStyle(.green600)
                .frame(height: 50)
            
            Spacer()
            
            ZStack {
                Image("Effect")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .rotationEffect(.degrees(animationAmount))
                    .animation(
                        .linear(duration: 3)
                        .repeatForever(autoreverses: true),
                        value: animationAmount
                    )
                
                Image(gpsStaircase.reweardImageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 120, height: 120)
                    .padding(.bottom, 12)
            }
            
            Text("\(gpsStaircase.name) 정복 성공!")
                .font(.callout)
                .foregroundStyle(.grey700)
                .padding(.bottom, 12)
            
            HStack(spacing: 12) {
                GradientSquareView(type: "획득 재료", text: gpsStaircase.reward, isWithSymbol: false)
                GradientSquareView(type: "추가 점수", text: "\(gpsStaircase.steps)칸", isWithSymbol: true)
            }
            
            Spacer()
            
            Button(action: {
                isShowingMissionSheet = false
            }, label: {
                HStack {
                    Spacer()
                    Text("확인하기")
                        .foregroundStyle(.white)
                        .padding(.vertical, 14)
                    Spacer()
                }
            })
            .frame(width: 316)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .foregroundStyle(.green800)
            )
        }
        .onAppear { // MARK: 위치 인증에 성공했을 때
            animationAmount = 360.0
            isVerificationActive = false
            lastVerificationTime = Date.now
            healthKitService.getWeeklyStairDataAndSave()
            // TODO: 성취 현지화 설정
            Task {
                gpsStaircaseWeeklyScore.addScore(score: gpsStaircase.steps)
                let weeklyScore = gpsStaircaseWeeklyScore.getWeeklyScore() + Int(healthKitService.weeklyFlightsClimbed) * 16
                await gameCenterManager.submitPoint(point: weeklyScore)
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
    @Binding var isShowingMissionSheet: Bool
    
    let gpsStaircase: GPSStaircase
    
    @State private var isReVerifing = false
    var body: some View {
        VStack {
            Spacer()
            
            Image("ShakeBird")
                .resizable()
                .scaledToFit()
                .frame(width: 160, height: 160)
                .padding(.bottom, 24)
            
            Text("인증 위치를 다시 확인해주세요.")
                .font(.title3)
                .bold()
                .padding(.bottom, 8)
            
            Text("정해진 위치에서만 미션을 깰 수 있어요.")
                .font(.callout)
                .foregroundStyle(.grey700)
            
            Spacer()
            
            if (isReVerifing) {
                HStack {
                    ProgressView()
                    
                    Text("확인하는 중")
                        .foregroundStyle(.secondary)
                }
                .frame(height: 50)
            } else {
                HStack {
                    Button(action: {
                        isReVerifing = true
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
                                print("Error: 위치 인증 불가")
                            }
                            isReVerifing = false
                        }
                    }, label: {
                        HStack {
                            Spacer()
                            Text("다시 시도하기")
                                .foregroundStyle(.green800)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 20)
                            Spacer()
                        }
                    })
                    .background(.green200)
                    .cornerRadius(12)
                    .frame(width: 152, height: 50)
                    
                    Spacer()
                    
                    Button(action: {
                        isShowingMissionSheet = false
                    }, label: {
                        HStack {
                            Spacer()
                            Text("위치 확인하기")
                                .foregroundStyle(.white)
                                .padding(.vertical, 14)
                                .padding(.horizontal, 20)
                            Spacer()
                        }
                    })
                    .background(.green700)
                    .cornerRadius(12)
                    .frame(width: 152, height: 50)
                }
                .padding(.horizontal, 40)
            }
        }
    }
}

struct GradientSquareView: View {
    let type: String
    let text: String
    let isWithSymbol: Bool
    var body: some View {
        VStack(spacing: 16) {
            Text(type)
                .font(.headline)
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
            .bold()
            .foregroundStyle(.green900)
        }
        .frame(width: 152, height: 95)
        .background(Color.white,
                    in: RoundedRectangle(cornerRadius: 12))
        .overlay(
            RoundedRectangle(cornerRadius: 12)
                .inset(by: 1)
                .stroke(
                    LinearGradient(
                        gradient: Gradient(colors: [Color(hex: 0xA4DA81), Color(hex: 0x638D48)]),
                        startPoint: .top,
                        endPoint: .bottom
                    ),
                    lineWidth: 2
                ))
    }
}

//#Preview {
//    MissionDetailView()
//}
