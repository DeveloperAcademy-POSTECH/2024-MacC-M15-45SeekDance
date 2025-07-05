//
//  TestLocationVerificationView.swift
//  StepSquad
//
//  Created by Groo on 5/21/25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

/// 지연된 Continuation 처리를 위한 간단한 코드 스니펫<br>
/// 위치 관리자
class LocationManagerTester: NSObject, ObservableObject, CLLocationManagerDelegate {
    // 위치 값을 내어주는 CheckedContinuation
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Error>?
    // 코어 위치 관리자
    private let manager = CLLocationManager()
    
    override init() {
        super.init()
        manager.delegate = self
    }
    
    func requestLocation() async throws -> CLLocationCoordinate2D? {
        try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            manager.requestLocation()
            // continuation 을 resume 시키지 않는 한, 비동기 블럭을 대기하고 있는다.
        }
    }
    
    //  CLLocationManagerDelegate - 현재 위치 획득
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Continuation 에 위치정보를 전달하면서 멈춰있던 실행을 진행시킨다.
        locationContinuation?.resume(returning: locations.first?.coordinate)
    }
    // CLLocationManagerDelegate - 위치 찾기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Continuation 에 오류를 전달하면서 멈춰있던 실행을 진행시킨다.
        locationContinuation?.resume(throwing: error)
    }
}


struct TestLocationVerificationView: View {
    @State private var manager = LocationManagerTester()
    @State private var currentLocation: CLLocationCoordinate2D?
    var body: some View {
        VStack {
            if let currentLocation = currentLocation {
                Text(currentLocation.latitude.description + ", " + currentLocation.longitude.description)
                    .font(.title)
            } else {
                ProgressView()
            }
            Text(currentLocation?.longitude.description ?? "No location yet.")
            LocationButton {
                Task {
                    currentLocation = nil
                    if let location = try? await manager.requestLocation() {
                        print("Location: \(location)")
                        currentLocation = location
                    } else {
                        print("Location unknown.")
                    }
                }
            }
            .clipShape(Capsule())
            .padding()
        }
    }
}
