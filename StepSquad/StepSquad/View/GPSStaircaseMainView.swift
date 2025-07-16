//
//  GPSStaircaseMainView.swift
//  StepSquad
//
//  Created by Groo on 5/6/25.
//

import SwiftUI
import RiveRuntime

struct GPSStaircaseMainView: View {
    var localPlayerImage: Image?
    var localPlayerName: String?
    
    @Binding var collectedItems: CollectedItems
    @Binding var gpsStaircaseWeeklyScore: GPSStaircaseWeeklyScore
    
    // TODO: gameCenterManager 전달받기
    @State var selectedGroup: Int = 2
    @State var bookmarks = Bookmarks()
    @State var filteredGPSStaircases = gpsStaircases
    
    let locationManager = LocationManager()
    
    let gameCenterManager: GameCenterManager
    
    @Binding var isShowingNewItem: Bool
    
    var body: some View {
        ScrollViewReader { proxy in
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        // TODO: 캐러셀 이미지, 애니메이션 추가
                        RiveViewModel(fileName: "carousel_v1.0").view()
                            .padding(.top, 222)
                        
                        VStack {
                            Spacer()
                            LinearGradient(stops: [.init(color: Color(hex: 0x16240E), location: 0), .init(color: .clear, location: 1)], startPoint: .bottom, endPoint: .top)
                                .frame(height: 142)
                        }
                        
                        VStack {
                            Image("ribbonDarkGreen")
                                .resizable()
                                .frame(width: 312, height: 100)
                                .padding(.top, 122)
                            
                            Spacer()
                            
                            Button(action: {
                                proxy.scrollTo("GPSStaircaseListView", anchor: .top)
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
                    
                    ProfileView(localPlayerImage: localPlayerImage, localPlayerName: localPlayerName, collectedItems: $collectedItems)
                    
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
                                Text("인증 장소를 확인한 후 직접 방문한다")
                                    .font(.footnote)
                                    .frame(width: 120)
                            }
                            
                            VStack {
                                Image("authenticationExample2")
                                Text("해당 계단 하단의 인증하기를 탭!")
                                    .font(.footnote)
                                    .frame(width: 120)
                                    .id("GPSStaircaseListView")
                            }
                        }
                        .padding(.top, 26)
                        .multilineTextAlignment(.center)
                        
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .frame(height: 289)
                    .background(.white)
                    .padding(.top, 40)
                    
                    VStack {
                        Image("ribbonGreen")
                            .resizable()
                            .frame(width: 241.5, height: 77.02)
                            .padding(.top, 40)
                        
                        Picker("전국", selection: $selectedGroup){
                            Section {
                                HStack {
                                    Text("북마크")
                                    Spacer()
                                    Image(systemName: "bookmark.fill")
                                }.tag(0)
                                HStack {
                                    Text("도전 완료")
                                    Spacer()
                                    Image(systemName: "medal.fill")
                                }.tag(1)
                            }
                            
                            Section("지역 필터") {
                                Text("전국").tag(2)
                                Text("수도권").tag(3)
                                Text("강원도").tag(4)
                                Text("세종·충북").tag(5)
                                Text("대전·충남").tag(6)
                                Text("대구·경북").tag(7)
                                Text("부산·울산·경남").tag(8)
                                Text("전북").tag(9)
                                Text("광주·전남").tag(10)
                                Text("제주").tag(11)
                            }
                        }
                        .tint(.green800)
                        .onChange(of: selectedGroup) {
                            filterStaircases()
                        }
                        
                        GPSStaircaseListView(filteredStaircases: $filteredGPSStaircases, bookmarks: $bookmarks, collectedItems: $collectedItems, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, locationManager: locationManager, gameCenterManager: gameCenterManager, isShowingNewItem: $isShowingNewItem)
                    }
                    
                    Spacer()
                }
            }
            .toolbar {
                ToolbarItem(placement: .topBarTrailing) {
                    Button("안내") {
                        // TODO: 안내 기능 추가
                    }
                    .tint(.green700)
                }
            }
            .ignoresSafeArea()
            .background(.green50)
            .navigationTitle("미션")
            .navigationBarTitleDisplayMode(.inline)
            .scrollBounceBehavior(.basedOnSize)
            .frame(maxHeight: .infinity)
        }
    }
    
    func filterStaircases() {
        if(selectedGroup == 0) { // 북마크한 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return bookmarks.contains(stair.id)
            }
        } else if(selectedGroup == 1) { // 도전 완료한 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return collectedItems.isCollected(item: stair.id)
            }
        } else if(selectedGroup == 3) { // 수도권 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .gyeonggi
            }
        } else if(selectedGroup == 4) { // 강원도 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .gangwon
            }
        } else if(selectedGroup == 5) { // 세종·충북 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .chungbuk
            }
        } else if(selectedGroup == 6) { // 대전·충남 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .chungnam
            }
        } else if(selectedGroup == 7) { // 대구·경북 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .gyeongbuk
            }
        } else if(selectedGroup == 8) { // 부산·울산·경남 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .gyeongnam
            }
        } else if(selectedGroup == 9) { // 전북 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .jeonbuk
            }
        } else if(selectedGroup == 10) { // 광주·전남 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .jeonnam
            }
        } else if(selectedGroup == 11) { // 제주 계단 리스트
            filteredGPSStaircases = gpsStaircases.filter { stair in
                return stair.province == .jeju
            }
        } else { // 전국 계단 리스트
            filteredGPSStaircases = gpsStaircases
        }
    }
}

struct ProfileView: View {
    var localPlayerImage: Image?
    var localPlayerName: String?
    
    @Binding var collectedItems: CollectedItems
    var completedStaircasesCount: Int {
        let completedStaircases = gpsStaircases.filter {
            return collectedItems.isCollected(item: $0.id)
        }
        return completedStaircases.count
    }
    
    var body: some View {
        HStack {
            if let localPlayerImage = localPlayerImage {
                localPlayerImage
                    .resizable()
                    .foregroundStyle(.white)
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 12)
            } else {
                Image("defaultProfile")
                    .resizable()
                    .foregroundStyle(.white)
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 12)
            }
            
            VStack(alignment: .leading) {
                Text(localPlayerName ?? "계단 오르기를 실천하는 사람")
                    .font(.headline)
                    .padding(.bottom, 4)
                HStack(spacing: 0) {
                    Text("방문한 계단 ")
                        .font(.footnote)
                    Text("\(completedStaircasesCount)개 / \(gpsStaircases.count)개")
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
