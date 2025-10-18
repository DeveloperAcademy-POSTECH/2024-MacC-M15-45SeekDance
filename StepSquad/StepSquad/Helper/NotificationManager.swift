//
//  NotificationManager.swift
//  StepSquad
//
//  Created by Groo on 10/12/25.
//

import Foundation
import UserNotifications
import CoreLocation

class NotificationManager {
    static let instance = NotificationManager()
    
    func requestAuthorization() {
        let options: UNAuthorizationOptions = [.alert, .sound, .badge]
        UNUserNotificationCenter.current().requestAuthorization(options: options) { suceess, error in
            if error != nil {
                print("🚩ERROR: denied notification.")
            } else {
                print("🚩noti center: authorized")
                self.requestLocationTriggerNotification()
            }
        }
    }
    
    func requestLocationTriggerNotification() {
        for gpsStaircase in gpsStaircases {
            let content = UNMutableNotificationContent()
            content.title = "주변에 계단 명소가?!"
            content.subtitle = "근처의 \(gpsStaircase.name)에 방문하여 미션을 달성해보는 건 어떤가요?"
            content.sound = .default
            content.badge = 1
            
            let coordinates = CLLocationCoordinate2D(
                latitude: gpsStaircase.latitude,
                longitude: gpsStaircase.longitude)
            let region = CLCircularRegion(
                center: coordinates,
                radius: 3000,
                identifier: "\(gpsStaircase.verificationLocation)")
            region.notifyOnEntry = true
            region.notifyOnExit = false
            let trigger = UNLocationNotificationTrigger(region: region, repeats: true)
            
            let request = UNNotificationRequest(
                identifier: "\(gpsStaircase.id)",
                content: content,
                trigger: trigger)
            
            UNUserNotificationCenter.current().add(request) { error in
                if let error {
                    print(error.localizedDescription)
                } else {
                    print("noti center: \(gpsStaircase.name) request added")
                }
            }
        }
        print("🚩noti center: completed request")
    }
}
