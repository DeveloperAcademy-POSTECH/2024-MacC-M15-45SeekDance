//
//  ExplainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//
//  NFC 태깅하기 방법 버튼

import SwiftUI

struct ExplainView: View {
    @Environment(\.presentationMode) var presentationMode
    
    var body: some View {
        NavigationView {
            ZStack(alignment: .topTrailing) {
                // Background
                Color.back.ignoresSafeArea()
                
                VStack {
                    
                    VStack(alignment: .leading, spacing: 0) {
                        Group {
                            Text("1. 78 계단을 오른다.")
                            Divider()
                            Text("2. 앱의 NFC 태깅하기 버튼을 누른다.")
                            Divider()
                            VStack(alignment: .leading, spacing: 5) {
                                Text("3. 계단 중간에 위치한 [ㅇㅇㅇ]를 스캔해 주세요.")
                                Text("휴대폰 위쪽이 [대상체 이름]을 스캔하고 있는지 확인해주세요.")
                                    .font(.footnote)
                                    .foregroundColor(.gray)
                                
                                HStack {
                                    Spacer()
                                    Image("IMG1")
                                        .resizable()
                                        .scaledToFit()
                                        .frame(maxHeight: 320)
                                        .cornerRadius(12)
                                    Spacer()
                                }
                            }
                            
                        }
                        .padding(.vertical, 10)
                        .padding(.horizontal)
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            .background(RoundedRectangle(cornerRadius: 12).fill(Color.white))
                    )
                    .cornerRadius(10)
                    .padding(.horizontal)
                    
                    Spacer()
                    
                    // 오류 문의 버튼
                    Button(action: {
                        // 오류 신고 action
                    }) {
                        Text("오류 문의")
                            .font(.body)
                            .fontWeight(.regular)
                            .foregroundColor(.indigo)
                    }
                    .padding(.horizontal)
                    .padding(.bottom, 88)
                } // VStack
                .padding(.top)
                
                // 닫기 버튼
                .navigationTitle("도움이 필요하신가요?")
                .navigationBarTitleDisplayMode(.inline)
                .navigationBarItems(
                    trailing: Button(action: {
                        presentationMode.wrappedValue.dismiss()
                    }) {
                        Image(systemName: "x.circle.fill")
                            .foregroundColor(.gray)
                            .frame(width: 30, height: 30)
                    }
                )
            } // ZStack
        }
    }
}

#Preview {
    ExplainView()
}
