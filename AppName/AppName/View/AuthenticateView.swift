//
//  AuthenticateView.swift
//  Gari
//
//  Created by Groo on 10/24/24.
//

import SwiftUI

struct AuthenticateView: View {
    @State private var point = 0
    var body: some View {
        Text("your point: \(point)")
        Button("Temporary tagging") {
            point += 78
        }
        .buttonStyle(.borderedProminent)
    }
}

#Preview {
    AuthenticateView()
}
