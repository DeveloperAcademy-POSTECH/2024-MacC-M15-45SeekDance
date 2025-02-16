//
//  EntryCertificateView.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/28/24.
//

import SwiftUI

struct EntryCertificateView: View {
    @State private var formattedDate: String = "입단하세요"
    @State private var dDay: Int = 0
    @State private var isSharing: Bool = false
    @State private var sharedImage: UIImage?
    @State private var isButtonClicked: Bool = false
    
    var userPlayerImage: Image?
    var nickName: String?
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack(spacing: 0) {
                Text("계단사랑단 입단증")
                    .font(Font.custom("ChosunCentennial", size: 15))
                    .foregroundStyle(.green800)
                
                Spacer()
                
                if !isButtonClicked {
                    Button {
                        isButtonClicked = true
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                            captureAndShare()
                            isButtonClicked = false
                        }
                    } label: {
                        Label("공유하기", systemImage: "square.and.arrow.up")
                            .font(.system(size: 13))
                            .foregroundStyle(.green800)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                    }
                    .background(Color(hex: 0xDBEED0),
                                in: RoundedRectangle(cornerRadius: 8))
                }
            }
            .padding(.top, 18)
            
            ZStack(alignment: .topLeading) {
                if nickName == nil {
                    Image("entryCertiNoLog")
                        .resizable()
                        .scaledToFit()
                } else {
                    Image("entryCertiLog")
                        .resizable()
                        .scaledToFit()
                }
                
                VStack(alignment: .leading, spacing: 0) {
                    Text("계단 오르기 맹세한 지")
                        .font(.system(size: 22))
                        .foregroundStyle(.green800)
                    
                    Text("\(dDay)일 차")
                        .font(.system(size: 34, weight: .bold))
                        .foregroundStyle(.green900)
                    
                    Text("1회차")
                        .font(.system(size: 17, weight: .semibold))
                        .foregroundStyle(Color(hex: 0x638D48))
                    
                    if let userIMG = userPlayerImage {
                        userIMG
                            .resizable()
                            .scaledToFit()
                            .frame(width: 60, height: 60)
                            .clipShape(Circle())
                            .padding(.leading, 124)
                            .padding(.top, 5)
                    }
                }
                .padding(.top, 24)
                .padding(.leading, 20)
            }
            .padding(.top, 12)
            
            Text(nickName ?? "계단 오르기를 실천하는 사람")
                .font(.system(size: 22, weight: .bold))
                .multilineTextAlignment(.leading)
                .padding(.top, 8)
            
            Text("\(formattedDate) 입단 1회차")
                .font(.system(size: 13))
                .foregroundStyle(.green800)
            
            Spacer()
            
            if !isButtonClicked {
                Text("입단증 눌러서 하산 기록 보기")
                    .font(Font.custom("SF Pro", size: 13))
                    .padding(.horizontal, 101)
                    .padding(.vertical, 7)
                    .foregroundStyle(.green900)
                    .padding(.bottom, 20)
            }
        }
        .padding(.horizontal, 20)
        .frame(width: 321, height: 560)
        .background(Color(red: 0.69, green: 0.85, blue: 0.6),
                    in: RoundedRectangle(cornerRadius: 12))
        .onAppear {
            loadHealthKitAuthorizationDate()
        }
        .sheet(isPresented: $isSharing) {
            if let sharedImage = sharedImage {
                ShareSheet(activityItems: [sharedImage])
            }
        }
    }
    
    // MARK: - 유저디폴트에 저장된 날짜 가져오기
    func loadHealthKitAuthorizationDate() {
        let userDefaults = UserDefaults.standard
        
        if let storedDate = userDefaults.object(forKey: "HealthKitAuthorizationDate") as? Date {
            let formatter = DateFormatter()
            
            formatter.dateFormat = "yyyy년 MM월 dd일"
            formatter.locale = Locale(identifier: "ko_KR")
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
            
            formattedDate = formatter.string(from: storedDate)
            
            calculateDDay(from: storedDate)
            saveDDayToDefaults()
        } else {
            formattedDate = "날짜 없음"
            dDay = 0
        }
    }
    
    // MARK: - 디데이 계산
    func calculateDDay(from date: Date) {
        let calendar = Calendar.current
        let today = calendar.startOfDay(for: Date())
        let targetDate = calendar.startOfDay(for: date)
        
        let components = calendar.dateComponents([.day], from: targetDate, to: today)
        
        if let daysPassed = components.day {
            dDay = daysPassed + 1
        } else {
            dDay = 0
        }
    }
    
    // MARK: - dDay 저장
    func saveDDayToDefaults() {
        let userDefaults = UserDefaults.standard
        userDefaults.set(dDay, forKey: "DDayValue")
        print("dDay (\(dDay))가 UserDefaults에 저장되었습니다.")
    }

    func captureAndShare() {
        let renderer = ImageRenderer(content: self)
        
        // 원하는 해상도로 크기 조정
        _ = CGSize(width: 321 * 3, height: 560 * 3) // 3배 스케일
        renderer.scale = 3.0 // 디스플레이의 배율에 따라 조정
        
        if let uiImage = renderer.uiImage {
            sharedImage = uiImage
            isSharing = true
        }
    }
}

#Preview {
    EntryCertificateView()
}
