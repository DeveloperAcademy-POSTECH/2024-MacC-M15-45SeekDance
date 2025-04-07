//
//  NewItemView.swift
//  StepSquad
//
//  Created by Groo on 11/14/24.
//

import SwiftUI

struct NewItemView: View {
    var body: some View {
        Text("N")
            .font(.system(size: 8))
            .foregroundStyle(.white)
            .frame(width: 18, height: 18)
            .background(Color(hex: 0xFC573F))
            .clipShape(.circle)
    }
}

#Preview {
    NewItemView()
}
