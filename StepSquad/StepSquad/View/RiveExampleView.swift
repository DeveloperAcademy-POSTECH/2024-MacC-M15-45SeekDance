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
            RiveViewModel(fileName: "reset").view()
        }
    }
}

#Preview {
    RiveExampleView()
}
