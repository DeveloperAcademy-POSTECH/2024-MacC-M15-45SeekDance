//
//  ProgressView.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/11/24.
//

import SwiftUI

struct ProgressView: View {
    var currentStep: Int = 3
    var body: some View {
        HStack(spacing: 0) {
            ForEach(0 ..< 5, id: \.self) { item in
                Circle()
                    .frame(width: 40, height: 40)
                    .foregroundStyle(item <= currentStep ? Color.green : Color.gray)
                    .overlay(content: {
                        Text("\(item + 1)층")
                            .fixedSize()
                            .offset(x: 3, y: 45)
                            .foregroundStyle(item <= currentStep ? Color.green : Color.gray)
                    })

                if item < 5 - 1 {
                    ZStack(alignment: .leading) {
                        Rectangle()
                            .frame(height: 3)
                            .foregroundStyle(Color.gray)
                        Rectangle()
                            .frame(height: 3)
                            .frame(maxWidth: item >= currentStep ? 0 : .infinity, alignment: .leading)
                            .foregroundStyle(Color.green)
                    }
                }
            }
        }
        .frame(height: 50)
    }
}
