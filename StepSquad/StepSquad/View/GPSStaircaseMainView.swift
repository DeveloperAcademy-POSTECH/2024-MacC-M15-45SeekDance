//
//  GPSStaircaseMainView.swift
//  StepSquad
//
//  Created by Groo on 5/6/25.
//

import SwiftUI

struct GPSStaircaseMainView: View {
    // TODO: gameCenterManager 전달받기
    let gameCenterManager = GameCenterManager()
    @State var localPlayerImage: Image?
    @State var selectedGroup: Int = 0
    @State var isGameCenterLoggin: Bool
    var body: some View {
        // TODO: NavigationStack 삭제
        NavigationStack {
            ScrollView {
                VStack(spacing: 0) {
                    ZStack {
                        // TODO: 캐러셀 이미지, 애니메이션 추가
                        Text(isGameCenterLoggin ? "로그인" : "로그아웃")
                            .font(.largeTitle)
                        
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
                    
                    // TODO: 기본 프로필 이미지 전달받기
                    ProfileView(userName: gameCenterManager.loadLocalPlayerName(), userProfile: $localPlayerImage)
                    
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
                    
                    VStack {
                        Image("ribbonWhite")
                            .resizable()
                            .frame(width: 241.5, height: 77.02)
                            .padding(.top, 40)
                        Picker("모든 계단", selection: $selectedGroup){
                            Section {
                                Text("모든 계단").tag(0)
                                HStack {
                                    Text("북마크")
                                    Spacer()
                                    Image(systemName: "bookmark")
                                }.tag(1)
                                HStack {
                                    Text("도전 완료")
                                    Spacer()
                                    Image(systemName: "medal")
                                }.tag(1)
                            }
                            Section("지역 필터") {
                                Text("전국").tag(0)
                                Text("수도권").tag(1)
                                Text("강원도").tag(2)
                                Text("세종·충북").tag(2)
                                Text("대전·충남").tag(2)
                                Text("대구·경북").tag(2)
                                Text("부산·울산·경남").tag(2)
                                Text("전북").tag(2)
                                Text("광주·전남").tag(2)
                                Text("제주").tag(2)
                            }
                        }
                        .tint(.green800)
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
            .onAppear {
                Task {
                    localPlayerImage = await gameCenterManager.loadLocalPlayerImage()
                    print("프로필 이미지 로드")
                }
            }
        }
    }
    
    init() {
        gameCenterManager.authenticateUser()
        print("게임 센터 로그인")
        isGameCenterLoggin = gameCenterManager.isGameCenterLoggedIn
        print("isGameCenterLoggin: \(isGameCenterLoggin)")
    }
}

struct ProfileView: View {
    let userName: String?
    @Binding var userProfile: Image?
    var body: some View {
        HStack {
            if let userProfile = userProfile {
                userProfile
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 12)
            } else {
                Image(systemName: "person.fill")
                    .foregroundStyle(.white)
                    .clipShape(Circle())
                    .frame(width: 60, height: 60)
                    .padding(.trailing, 12)
            }
            VStack(alignment: .leading) {
                Text(userName ?? "계단 오르기를 실천하는 사람")
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
        .onAppear {
            print("프로필 뷰 로드")
        }
    }
}

#Preview {
    GPSStaircaseMainView()
}
