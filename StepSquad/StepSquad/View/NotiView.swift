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
            2: ("계단오르고 엉짱된 썰 푼다", "계단 오르기는 누구나 쉽게 할 수 있는 틈새 운동입니다! 오늘부터 계단 오르기를 시작해 보는 것은 어떨까요?"), // 월
            3: ("앗! 계단 안걷는 사람 먼저 살찐다!", "계단은 아주 쉽고 간단하게 할 수 있는 운동인거 아시죠? 식후 1-2시간 안에 계단을 걸으면 유산소 능력과 근력을 향상시켜 혈당 관리에 많은 도움을 줄 수 있습니다."), // 화
            4: ("적절한 계단 운동 강도는?", "한계단씩 천천히 올라가면서 몇 층에서 “약간 힘들다” 정도에 도달하는 지 확인하시고 그 운동 강도를 유지하세요!"), // 수
            5: ("계단오르기의 다이어트 효과!", "계단을 오르면 30분에 221kcal를 소비해요. 같은 시간에 빨리 걷기보다 두 배 정도의 칼로리를 더 소모할 수 있어요."), // 목
            6: ("주말엔 안오르실거죠?", "다 알아요… 주말엔 알람 안보낼게요. 하지만 틈새를 잊지 말아줘… 월요일에 만나요!") // 금
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
