//
//  MaterialsView.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/12/24.
//

import SwiftUI

struct MaterialsView: View {
    @Binding var isMaterialSheetPresented: Bool

    let materials = ["황기", "도라지", "생강", "대추", "감초"]
    var body: some View {
        NavigationView {
            List {
                ForEach(materials, id: \.self) { material in
                    HStack(spacing: 0) {
                        Rectangle()
                            .frame(width: 42, height: 42)
                            .padding(.trailing, 8)
                        
                        Text(material)
                            .font(.system(size: 17))
                        
                        Spacer()
                        
                        Text("24/11/11")
                            .font(.system(size: 15))
                            .foregroundStyle(Color(hex: 0x3C3C43))
                            .opacity(0.6)
                    }
                    .padding(.horizontal, 16)
                }
            }
            .navigationTitle("획득 재료보기")
            .navigationBarTitleDisplayMode(.inline)
            .navigationBarItems(
                leading: Button(action: {
                    isMaterialSheetPresented.toggle()
                }) {
                    Image(systemName: "chevron.backward")
                        .foregroundColor(.gray)
                        .frame(width: 30, height: 30)
                }
            )
        }
    }
}
