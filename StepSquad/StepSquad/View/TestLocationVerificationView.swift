//
//  TestLocationVerificationView.swift
//  StepSquad
//
//  Created by Groo on 5/21/25.
//

import SwiftUI

struct TestLocationVerificationView: View {
    let locationManager = LocationManager()
    var body: some View {
        Button("위치 권한 받기") {
            locationManager.requestWhenInUseAuthorization()
        }
    }
}

#Preview {
    TestLocationVerificationView()
}
