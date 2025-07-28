//
//  XCircleButtonView.swift
//  StepSquad
//
//  Created by Groo on 6/27/25.
//

import SwiftUI

struct XCircleButtonView: View {
    var body: some View {
        ZStack {
            Circle()
                .foregroundStyle(Color(hex: 0x3D3D3D).opacity(0.3))
                .frame(width: 30, height: 30)
            Image(systemName: "xmark")
                .font(.system(size: 16))
                .bold()
                .foregroundStyle(Color(hex: 0x3D3D3D))
        }
    }
}

#Preview {
    XCircleButtonView()
}
