//
//  NotiView.swift
//  StepSquad
//
//  Created by heesohee on 4/15/25.
//


import SwiftUI
import UserNotifications

struct NotiView: View {
    @State private var isAuthorized: Bool = false
    @AppStorage("NotificationToggleOn") private var isToggleOn: Bool = false
    
    var body: some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 0) {
                Text("밥 먹고 계단걷기 잊지말자")
                    .font(.system(size: 13))
                    .foregroundStyle(Color("Green700"))
                Text("평일 오후 2시 계단 알림")
                    .font(.system(size: 15))
                    .fontWeight(.semibold)
                    .foregroundStyle(Color("Green900"))
            }
            
            Spacer()
            
            if isAuthorized {
                Toggle(isOn: $isToggleOn) {
                    EmptyView()
                }
                .toggleStyle(SwitchToggleStyle(tint: Color("Green900")))
                .onChange(of: isToggleOn) { newValue in
                    if newValue {
                        scheduleWeekdayNotifications()
                    } else {
                        cancelWeekdayNotifications()
                    }
                }
                .frame(width: 60)
            } else {
                Button(action: {
                    UNUserNotificationCenter.current().getNotificationSettings { settings in
                        DispatchQueue.main.async {
                            switch settings.authorizationStatus {
                            case .notDetermined:
                                // 권한 요청
                                requestAuthorization { granted in
                                    if granted {
                                        isAuthorized = true
                                        isToggleOn = true
                                        scheduleWeekdayNotifications()
                                    }
                                }
                            case .denied:
                                // 설정 앱으로 이동
                                if let url = URL(string: UIApplication.openSettingsURLString) {
                                    UIApplication.shared.open(url)
                                }
                            default:
                                break
                            }
                        }
                    }
                }) {
                    Text("알림 받기")
                        .font(.system(size: 13))
                        .padding(.horizontal, 12)
                        .padding(.vertical, 8)
                        .foregroundColor(Color("Green900"))
                        .background(Color("Green500"), in: RoundedRectangle(cornerRadius: 4))
                }
            }
        }
        .padding(16)
        .frame(width: 370, height: 70)
        .background(Color("Green200"))
        .cornerRadius(16)
        .onAppear {
            updateAuthorizationStatus()
        }
        .onReceive(NotificationCenter.default.publisher(for: UIApplication.willEnterForegroundNotification)) { _ in
            updateAuthorizationStatus()
        }
    }
    
    // MARK: 설정에서 직접 권한 받고 리다이렉팅 했을 때
    func updateAuthorizationStatus() {
        UNUserNotificationCenter.current().getNotificationSettings { settings in
            DispatchQueue.main.async {
                let isNowAuthorized = settings.authorizationStatus == .authorized
                
                // 상태 변경 감지
                if isNowAuthorized && !isAuthorized {
                    // 권한이 새로 허용되었을 경우
                    isAuthorized = true
                    isToggleOn = true
                    scheduleWeekdayNotifications()
                } else if !isNowAuthorized {
                    isAuthorized = false
                    isToggleOn = false
                    cancelWeekdayNotifications()
                }
            }
        }
    }
    
    
    // MARK: - 권한 요청 함수
    func requestAuthorization(completion: @escaping (Bool) -> Void) {
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound, .badge]) { granted, error in
            if let error = error {
                print("🔴 알림 권한 요청 에러: \(error.localizedDescription)")
                completion(false)
                return
            }
            print(granted ? "🟢 알림 권한 허용됨" : "⚠️ 알림 권한 거부됨")
            completion(granted)
        }
    }
    
    // MARK: - 알림 예약 함수
    func scheduleWeekdayNotifications() {
        let contentsPerWeekday: [Int: (title: String, body: String)] = [
            2: ("월요일의 고통을 잊는 법은?!", "더 큰 고통인 계단 오르기를 하시면 되겠습니다."), // 월
            3: ("계단 오르Go! 혈당 낮추Go!", "혈당 스파이크 왔을 땐 계단 오르기로 잡아보자!"), // 화
            4: ("계단 오르기 전 주의하세요!", "발은 11자, 허리는 세우고, 무릎이 발보다 더 나오지 않게 조심하기!"), // 수
            5: ("걷기보다 빠른 체지방 태우는 법은?", "30분간 계단을 오르면 221kcal를 소비할 수 있어요!"), // 목
            6: ("주말엔… 안 오를 거죠…?", "다 알아요… 주말에는 알람 안 보낼게요. 그렇지만 월요일엔 꼭 다시 만나요!") // 금
        ]
        
        for (weekday, contentTuple) in contentsPerWeekday {
            let content = UNMutableNotificationContent()
            content.title = contentTuple.title
            content.body = contentTuple.body
            content.sound = .default
            
            var dateComponents = DateComponents()
            dateComponents.hour = 14
            dateComponents.minute = 0
            dateComponents.weekday = weekday
            
            let trigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)
            let request = UNNotificationRequest(
                identifier: "stairsReminder_\(weekday)",
                content: content,
                trigger: trigger
            )
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error = error {
                    print("🔴 \(weekday)요일 알림 등록 실패: \(error.localizedDescription)")
                } else {
//                    print("✅ \(weekday)요일 알림 등록 완료")
//                    print("✅ 평일 알림 등록 완료")
                }
            }
        }
    }
    
    // MARK: - 알림 취소 함수
    func cancelWeekdayNotifications() {
        let identifiers = (2...6).map { "stairsReminder_\($0)" }
        UNUserNotificationCenter.current().removePendingNotificationRequests(withIdentifiers: identifiers)
        print("🗑️ 평일 알림 모두 취소 완료")
    }
}

#Preview {
    NotiView()
}
