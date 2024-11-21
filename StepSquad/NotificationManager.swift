//
//  Notification.swift
//  StepSquad
//
//  Created by heesohee on 11/21/24.
//


//import Foundation
//import UserNotifications
//import CoreLocation
//
//
//class NotificationManager {
//
//    static let shared = NotificationManager()
//
//    // 사용자에게 노티피케이션 권한 요청 // .provisional는
//    func requestAuthorization() {
//        let options:UNAuthorizationOptions = [.alert,.sound,.badge]
//        UNUserNotificationCenter.current().requestAuthorization(options: options) { sucess, error in
//            if let error = error{
//                print("Error: - \(error.localizedDescription)")
//            } else {
//                print("사용자에게서 알림 권한을 받는데 성공했습니다.")
//            }
//        }
//
//    }
//
//
//    // 노티피케이션 콘텐츠
//    func scheduleNotification(trigger:TriggerType){
//        let content = UNMutableNotificationContent()
//        content.title = "78계단"
//        content.body = "식후 계단 사용은 어때요?"
//        content.sound = .default
//        content.badge = 1
//
//        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger.trigger)
//        UNUserNotificationCenter.current().add(request)
//    }
//
//    // 노티피케이션 취소 함수
//    func cancelNotification(){
//        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
//        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
//    }
//}
//
//// 노티피케이션 트리거 종류 3개
//enum TriggerType: String{
//    case time = "time"
//    case calender = "calender"
//    case location = "location"
//
//    var trigger:UNNotificationTrigger{
//        switch self {
//        case .time: // 특정 시간 지난 후에
//            return UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
//        case .calender: // 특정 시간에 (월2, 화3, 수4, 목5, 금6, 토7)
//            let dateComponent = DateComponents(hour: 20, minute: 22, weekday: 1)
//            print("특정 시간에 노티")
//            return UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
//        case .location:
//            let coordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: 50.0)
//            let region = CLCircularRegion(center: coordinate, radius: 100, identifier: UUID().uuidString)
//            return UNLocationNotificationTrigger(region: region, repeats: true)
//        }
//    }
//}
import SwiftUI
import UserNotifications

class NotificationManager {

    static let instance = NotificationManager() // 인스턴스 생성

    // MARK: - 사용자에게 노티피케이션 권한 요청
    func requestAuthorization() {

        // 노티피케이션 옵션들
        // To request provisional authorization, add the provisional option when requesting permission to send notifications.
        let option: UNAuthorizationOptions = [.alert, .sound, .badge, .provisional]

        // UserNotification 접근
        UNUserNotificationCenter.current().requestAuthorization(options: option) { (success, error) in
            if let error = error {
                print("Error: - \(error.localizedDescription)")
            } else {
                print("사용자에게서 알림 권한을 받는데 성공했습니다.")
            }
        }
    }

    // MARK: - 특정 시간에 노티를 주는 함수
    func scheduleNotification() {

        // notification 내용 설정
        let content = UNMutableNotificationContent()
        content.title = "78계단"
        content.subtitle = "앱 알람 테스트 중 입니다"
        content.sound = .default


        // 배지 값 증가 설정
        //          UNUserNotificationCenter.current().getNotificationSettings { settings in
        //              if settings.authorizationStatus == .authorized {
        //                  // 배지 값 가져와 증가
        //                  let currentBadgeCount = UIApplication.shared.applicationIconBadgeNumber
        //                  UNUserNotificationCenter.current().setBadgeCount(currentBadgeCount + 1) { error in
        //                      if let error = error {
        //                          print("배지 설정 중 에러 발생: \(error.localizedDescription)")
        //                      }
        //                  }
        //              }
        //          }
        //
        content.badge = NSNumber(value: UIApplication.shared.applicationIconBadgeNumber + 1)
        //        content.badge = 1

        // MARK: - 시간 기준 : Interval - 몇 초 뒤에 울릴것인지 딜레이 설정 repeats 반복 여부 설정 (최소 1분이여지 반복이 돔)
        let timeTrigger = UNTimeIntervalNotificationTrigger(timeInterval: 60.0, repeats: false)


        // MARK: - 특정 시간에 노티를 주는 함수, 날짜 기준 : DateMating 은 DateComponent 기준맞는 알림
        var dateComponents = DateComponents()
        dateComponents.hour = 2 // hour 를 24시간 기준
        dateComponents.minute = 00
        dateComponents.weekday = 2 // 1은 일요일이 되고, 6은 금요일이 됨

        let calendarTigger = UNCalendarNotificationTrigger(dateMatching: dateComponents, repeats: true)


        // 설정한 값을 NotificationCenter 에 요청하기
        let request = UNNotificationRequest(
            identifier: UUID().uuidString, // 각각의 request ID 값 String 을 uuid 값으로 설정
            content: content,
            trigger: timeTrigger)
        UNUserNotificationCenter.current().add(request)

        print("노티 설정 완료")
    }

    // MARK: - 생성된 Notification Cancel 하는 함수
    func cancelNotification() {

        // peding notification 은 tigger 상에서 만족된 조건이 되어도 더이상 notification 되지 않게 하기
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
        print("노티 취소.")

        // 아이폰 상태바를 내렸을때 남아있는 notification 없애기
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        print("노티 취소.")
    }


}


// MARK: - 예시 뷰
struct LocalNotificationInter: View {

    @Environment(\.scenePhase) var scenePhase

    var body: some View {
        VStack (spacing: 40) {

            // MARK: - 사용자에게 노티피케이션 권한 요청
            Button {
                NotificationManager.instance.requestAuthorization()
            } label: {
                Text("권한 요청하기")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

            // MARK: - 특정 시간에 노티를 주는 함수(구간 반복)
            Button {
                NotificationManager.instance.scheduleNotification()
            } label: {
                Text("Time Notification")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

            // MARK: - 특정 시간에 노티를 주는 함수
            Button {
                NotificationManager.instance.scheduleNotification()
            } label: {
                Text("Calendar Notification")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

            // MARK: - 노티 취소 함수
            Button {
                NotificationManager.instance.cancelNotification()
            } label: {
                Text("Notification 취소하기")
                    .font(.title2)
                    .fontWeight(.semibold)
                    .foregroundColor(.black)
                    .padding()
                    .background(Color.green)
                    .cornerRadius(10)
            }

        } //: VSTACK
        // schne 이 나타 날때 Badge 0 으로 초기화 하기
        // Badge 초기화

                .onChange(of: scenePhase) { newValue in
                    if newValue == .active {
                        UIApplication.shared.applicationIconBadgeNumber = 0
                    }
                }
            }
        }

//        .onChange(of: scenePhase) { _, _ in
//            if scenePhase == .active {
//                UNUserNotificationCenter.current().setBadgeCount(0) { error in
//                    if let error = error {
//                        print("Badge 초기화 중 에러 발생: \(error.localizedDescription)")
//                    }
//                }
//            }
//        }
//    }
//}

struct LocalNotificationInter_Previews: PreviewProvider {
    static var previews: some View {
        LocalNotificationInter()
    }
}

