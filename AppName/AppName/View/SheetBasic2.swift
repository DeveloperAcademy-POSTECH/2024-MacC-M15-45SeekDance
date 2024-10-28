//
//  SheetBasic2.swift
//  SwiftUIBasic
//
//  Created by Jacob Ko on 2022/08/18.
//  NFC 태깅하기 방법 버튼

import SwiftUI

struct SheetBasic2: View {
    // property
    @Environment(\.presentationMode) var presentationMode

    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                // background
                Color.white.ignoresSafeArea()

                // 닫기 버튼
                Button {
                    // Sheet 닫기 action
                    presentationMode.wrappedValue.dismiss()
                } label: {
                    Image(systemName: "x.circle.fill")
                        .foregroundColor(.secondary)
                        .font(.title)
                        .padding(.top, 20)
                        .padding(.trailing, 20)
                }

                // NFC 태깅 방법 리스트
                List {
                    Text("1. 78 계단을 오른다.")
                    Text("2. 앱의 NFC 태깅하기 버튼을 누른다.")
                    Text("3. 계단 중간에 위치한 [ㅇㅇㅇ]를 스캔해 주세요.")
                }
            }
            .navigationTitle("NFC 태깅 방법")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

#Preview {
    SheetBasic2()
}

