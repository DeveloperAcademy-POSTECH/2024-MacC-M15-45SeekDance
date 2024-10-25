//
//  NotificationManager.swift
//  Gari
//
//  Created by heesohee on 10/25/24.
//

import Foundation
import UserNotifications
import CoreLocation



class NotificationManager {
    
    static let shared = NotificationManager()
    
    // 사용자에게 노티피케이션 권한 요청 // .provisional는
    func requestAuthorization() {
        let options:UNAuthorizationOptions = [.alert,.sound,.badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { sucess, error in
            if let error = error{
                print("Error: - \(error.localizedDescription)")
            } else {
                print("사용자에게서 알림 권한을 받는데 성공했습니다.")
            }
        }
        
    }
    
    
    // 노티피케이션 콘텐츠
    func scheduleNotification(trigger:TriggerType){
        let content = UNMutableNotificationContent()
        content.title = "78계단"
        content.body = "식후 계단 사용은 어때요?"
        content.sound = .default
        content.badge = 1
        
        let request = UNNotificationRequest(identifier: UUID().uuidString, content: content, trigger: trigger.trigger)
        UNUserNotificationCenter.current().add(request)
    }
    
    // 노티피케이션 취소 함수
    func cancelNotification(){
        UNUserNotificationCenter.current().removeAllDeliveredNotifications()
        UNUserNotificationCenter.current().removeAllPendingNotificationRequests()
    }
}

// 노티피케이션 트리거 종류 3개
enum TriggerType: String{
    case time = "time"
    case calender = "calender"
    case location = "location"
    
    var trigger:UNNotificationTrigger{
        switch self {
        case .time: // 특정 시간 지난 후에
            return UNTimeIntervalNotificationTrigger(timeInterval: 5, repeats: false)
        case .calender: // 특정 시간에 (월2, 화3, 수4, 목5, 금6, 토7)
            let dateComponent = DateComponents(hour: 20, minute: 22, weekday: 1)
            print("특정 시간에 노티")
            return UNCalendarNotificationTrigger(dateMatching: dateComponent, repeats: false)
        case .location:
            let coordinate = CLLocationCoordinate2D(latitude: 40.0, longitude: 50.0)
            let region = CLCircularRegion(center: coordinate, radius: 100, identifier: UUID().uuidString)
            return UNLocationNotificationTrigger(region: region, repeats: true)
        }
    }
}
