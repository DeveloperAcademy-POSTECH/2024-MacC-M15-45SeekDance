//
//  RiveExampleView.swift
//  StepSquad
//
//  Created by Groo on 1/23/25.
//

import SwiftUI
import RiveRuntime

struct RiveExampleView: View {
    var body: some View {
        VStack {
            RiveViewModel(
                webURL: "https://cdn.rive.app/animations/off_road_car_v7.riv"
            ).view()
        }
    }
}

#Preview {
    RiveExampleView()
}
