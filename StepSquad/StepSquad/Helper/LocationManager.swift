//
//  LocationManager.swift
//  StepSquad
//
//  Created by Groo on 5/21/25.
//

import Foundation
import CoreLocation

enum VerifyLocationState: String {
    case verifing = "인증 중"
    case verified = "인증 성공"
    case denied = "인증 실패"
}

class LocationManager: NSObject, CLLocationManagerDelegate {
    private var locationManager = CLLocationManager()
    var latitude: Double = 0.0
    var longitude: Double = 0.0
    
    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
    }
    
    func requestAlwaysAuthorization() {
        locationManager.requestAlwaysAuthorization()
    }
    
    func requestWhenInUseAuthorization() {
        locationManager.requestWhenInUseAuthorization()
    }
    
    //    func locationManager(_ manager: CLLocationManager, didChangeAuthorization status: CLAuthorizationStatus) {
    //        print("didChangeAuthorization")
    //        switch status {
    //        case .authorizedAlways, .authorizedWhenInUse:
    //            startUpdatingLocation()
    //        default:
    //            // 필요한 처리를 여기에 추가
    //            break
    //        }
    //    }
    
    func startUpdatingLocation() {
        locationManager.startUpdatingLocation()
    }
    
    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }
    
    func requestLocation() {
        locationManager.requestLocation()
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last {
            print("Latitude: \(location.coordinate.latitude), Longitude: \(location.coordinate.longitude)")
            latitude = location.coordinate.latitude
            longitude = location.coordinate.longitude
        }
    }
    
    func testLocation() -> String {
        startUpdatingLocation()
        return "현재 latitude: \(latitude), longitude: \(longitude)"
    }
    
    func verificateLocation(gpsStaircaseLatitude: Double, gpsStaircaseLongitude: Double) async -> Bool {
        requestLocation()
        let gpsStaircaseLocation = (editDouble(number: gpsStaircaseLatitude), editDouble(number: gpsStaircaseLongitude))
        let currentLocation = (editDouble(number: latitude), editDouble(number: longitude))
        print("계단 위치: ", gpsStaircaseLocation)
        print("현재 위치: ", currentLocation)
        if gpsStaircaseLocation == currentLocation {
            return true
        } else {
            return false
        }
    }
    
    func verifyLocation(gpsStaircaseLatitude: Double, gpsStaircaseLongitude: Double) async -> VerifyLocationState {
        startUpdatingLocation()
        let gpsStaircaseLocation = (editDouble(number: gpsStaircaseLatitude), editDouble(number: gpsStaircaseLongitude))
        let currentLocation = (editDouble(number: latitude), editDouble(number: longitude))
        print("계단 위치: ", gpsStaircaseLocation)
        print("현재 위치: ", currentLocation)
        stopUpdatingLocation()
        if gpsStaircaseLocation == currentLocation {
            print("return verified")
            return .verified
        } else {
            print("return denied")
            return .denied
        }
        
    }
    
    func editDouble(number: Double) -> Double { // Double의 5째 자리에서 반올림한 수를 리턴
        let digit: Double = pow(10, 4) // 10의 4제곱
        return round(number * digit) / digit
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        //에러를 확인하려면 NSError타입으로 캐스팅해야함.
        let error = error as NSError
        guard error.code != CLError.Code.locationUnknown.rawValue else {return}
        
        print(error)
    }
}
