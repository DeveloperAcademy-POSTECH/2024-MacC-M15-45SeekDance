//
//  ResetTestView.swift
//  StepSquad
//
//  Created by Groo on 4/8/25.
//

import SwiftUI

struct ResetTestView: View {
    @Binding var isResetViewPresented: Bool // FullScreen 상태를 상위 뷰와 공유
    
    var body: some View {
        Button("ResetLevel") {
            MainViewPhase3().resetLevel()
            isResetViewPresented = false
        }
    }
}
