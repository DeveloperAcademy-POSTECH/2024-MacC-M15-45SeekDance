//
//  LocationManager.swift
//  StepSquad
//
//  Created by Groo on 5/21/25.
//

import Foundation
import CoreLocation

enum VerifyLocationState: String {
    case verified = "인증 성공"
    case denied = "인증 실패"
}

class LocationManager: NSObject, ObservableObject, CLLocationManagerDelegate {
    private var locationContinuation: CheckedContinuation<CLLocationCoordinate2D?, Error>?
    private var locationManager = CLLocationManager()
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func getAuthorizationStatus() -> CLAuthorizationStatus {
        return locationManager.authorizationStatus
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    func requestLocation() async throws -> CLLocationCoordinate2D? {
        try await withCheckedThrowingContinuation { continuation in
            locationContinuation = continuation
            locationManager.requestLocation()
            // continuation 을 resume 시키지 않는 한, 비동기 블럭을 대기하고 있는다.
        }
    }
    
    //  MARK: CLLocationManagerDelegate - 현재 위치 획득
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        // Continuation 에 위치정보를 전달하면서 멈춰있던 실행을 진행시킨다.
        locationContinuation?.resume(returning: locations.first?.coordinate)
    }
    
    // MARK: CLLocationManagerDelegate - 위치 찾기 실패
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        // Continuation 에 오류를 전달하면서 멈춰있던 실행을 진행시킨다.
        locationContinuation?.resume(throwing: error)
    }
    
    // MARK: 계단의 경도, 위도와 현재 위치의 경도, 위도 비교
    func compareLocations(staircaseLongitude: Double, staircaseLatitude: Double, currentLongitude: Double, currentLatitude: Double) -> Bool {
        let digit: Double = pow(10, 3) // 10의 3제곱
        if (round(staircaseLongitude * digit) / digit == round(currentLongitude * digit) / digit && round(staircaseLatitude * digit) / digit == round(currentLatitude * digit) / digit) {
            return true
        } else {
            return false
        }
    }
}
