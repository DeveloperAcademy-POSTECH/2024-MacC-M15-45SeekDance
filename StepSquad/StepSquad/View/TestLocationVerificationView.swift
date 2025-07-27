//
//  TestLocationVerificationView.swift
//  StepSquad
//
//  Created by Groo on 5/21/25.
//

import SwiftUI
import CoreLocation
import CoreLocationUI

struct TestLocationVerificationView: View {
    @State private var manager = LocationManager()
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
