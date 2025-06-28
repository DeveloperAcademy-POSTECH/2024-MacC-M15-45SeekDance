//
//  TestLocationVerificationView.swift
//  StepSquad
//
//  Created by Groo on 5/21/25.
//

import SwiftUI

struct TestLocationVerificationView: View {
    @State var location = ""
    let locationManager = LocationManager()
    var body: some View {
        VStack(spacing: 30) {
            Button("위치 권한 받기") {
                print("위치 권한 버튼")
                locationManager.requestAlwaysAuthorization()
            }
            .buttonStyle(.borderedProminent)
            Button("위치 확인") {
                print("위치 권한 버튼")
                location = locationManager.verifyLocation()
            }
            .buttonStyle(.bordered)
            Text(location)
                .multilineTextAlignment(.center)
                .font(.title2)
        }
        .onAppear() {
            print("onAppear")
        }
    }
}

#Preview {
    TestLocationVerificationView()
}
