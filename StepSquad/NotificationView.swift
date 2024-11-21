//
//  NotificationView.swift
//  StepSquad
//
//  Created by heesohee on 11/21/24.
//

import SwiftUI

struct NotificationView: View {
    var body: some View {
        VStack(spacing: 20) {
            // 권한 요청 버튼
            Button("노티피케이션 권한 요청") {
                NotificationManager.instance.requestAuthorization()
            }
            .padding()
            .background(Color.green)
            .foregroundColor(.white)
            .cornerRadius(10)

            // 특정 시간 노티 설정 버튼
            Button("특정 시간에 노티피케이션 설정") {
                NotificationManager.instance.scheduleNotification()
            }
            .padding()
            .background(Color.blue)
            .foregroundColor(.white)
            .cornerRadius(10)

            // 노티피케이션 취소 버튼
            Button("노티피케이션 취소하기") {
                NotificationManager.instance.cancelNotification()
            }
            .padding()
            .background(Color.red)
            .foregroundColor(.white)
            .cornerRadius(10)
        }
        .padding()
    }
}


#Preview {
    NotificationView()
}
