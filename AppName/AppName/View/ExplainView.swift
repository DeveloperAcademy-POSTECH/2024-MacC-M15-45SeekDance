//
//  ExplainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//
//  NFC 태깅하기 방법 버튼

import SwiftUI

struct ExplainView: View {
    // property
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                // background
                Color.white.ignoresSafeArea()
                
                VStack {
                    Section {
                        List {
                            Text("1. 78 계단을 오른다.")
                            Text("2. 앱의 NFC 태깅하기 버튼을 누른다.")
                            
                            VStack {
                                Text("3. 계단 중간에 위치한 [ㅇㅇㅇ]를 스캔해 주세요.")
                                Text("휴대폰 위쪽이 [대상체 이름]을 스캔하고 있는지 확인해주세요.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                Image("IMG1")
                                    .resizable()
                                    .scaledToFill()
                                    .frame(maxWidth: 220)
                                    .cornerRadius(12)
                            }
                        }
                    }
                    
                    // 오류 신고 버튼
                    Button(action: {
                        // 오류 신고 action
                    }) {
                        Text("오류 신고")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(.indigo)
                            .padding(.top, 10)
                    }
                } // VStack
                // 닫기 버튼
                .navigationTitle("NFC 태깅 방법")
                .navigationBarTitleDisplayMode(.large)
                .navigationBarItems(
                    trailing: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.secondary)
                            .padding(.top, 20)
                    }
                )
            } // ZStack
        }
    }
}


#Preview {
    ExplainView()
}

