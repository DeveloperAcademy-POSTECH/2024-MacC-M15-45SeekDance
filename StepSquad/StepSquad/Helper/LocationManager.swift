//
//  LocationManager.swift
//  StepSquad
//
//  Created by Groo on 5/21/25.
//

import Foundation
import CoreLocation

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
    
    func verifyLocation() -> String {
        requestLocation()
        return "현재 latitude: \(latitude), longitude: \(longitude)"
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
            //에러를 확인하려면 NSError타입으로 캐스팅해야함.
            let error = error as NSError
            guard error.code != CLError.Code.locationUnknown.rawValue else {return}
            
            print(error)
        }
}
