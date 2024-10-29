//
//  MainView.swift
//  Gari
//
//  Created by heesohee on 10/28/24.
//

import SwiftUI

struct MainView: View {
    // property
    @State var showSheet1: Bool = false
    @State var showSheet2: Bool = false
    
    var body: some View {
        ZStack {
            // Background
            Color.back.ignoresSafeArea()
            
            VStack (alignment: .center) { // VStack 전체
                
                VStack { // 당기면 보이는 값 위치
                    Text("7 회")
                        .fontWeight(.semibold)
                        .font(.subheadline)
                }
                .padding(.bottom, 10)
                
                VStack (alignment: .center) { // 흰 카드 안 콘텐츠 (텍스트, 이미지, 서클, 버튼 두개)
                    
                    Text("엘리베이터 대신 \n계단 이용하기!")
                        .multilineTextAlignment(.center)
                        .fontWeight(.regular)
                        .font(.title2)
                        .padding(.top, 20)
                    
                    RoundedRectangle(cornerRadius: 20)
                        .foregroundStyle(.back)
                        .frame(width: 240, height: 240)
                        .padding(.top, 10)
                    
                    HStack (spacing: 16){ // 서클
                        Circle()
                            .frame(width: 52, height: 52)
                            .foregroundColor(.gray)
                        Circle()
                            .frame(width: 52, height: 52)
                            .foregroundColor(.gray)
                        Circle()
                            .frame(width: 52, height: 52)
                            .foregroundColor(.gray)
                    } //  HStack // 서클 3개
                    .padding(.top, 30)
                    
                    VStack {
                        Button {
                            showSheet1.toggle()
                        } label: {
                            Image(systemName: "")
                            Text("NFC 태깅하기")
                                .foregroundColor(.white)
                                .font(.body)
                                .fontWeight(.regular)
                                .frame(width: 264, height: 50)
                                .background(Color.indigo)
                                .cornerRadius(12)
                        }
                        //                        .sheet(isPresented: $showSheet1) {
                        //                            SheetBasic1()
                        //                                .presentationDragIndicator(.hidden)
                        //                               .presentationDetents([.medium])
                        //                        }
                        
                        Button {
                            showSheet2.toggle()
                        } label: {
                            Image(systemName: "info.square.fill")
                                .foregroundColor(.secondary)
                            Text("NFC 태깅 방법")
                                .foregroundColor(.secondary)
                                .font(.footnote)
                        }
                        .sheet(isPresented: $showSheet2) {
                            SheetBasic2()
                                .presentationDragIndicator(.visible)
                                .presentationDetents([.large])
                        }
                        .padding(.top, 16) // 아래 버튼
                        
                    } // Vstack 버튼 두개 만
                    .padding(.top, 24)
                    .padding(.bottom, 20)
                    
                } // VStack // 흰 카드
                .frame(width: 320, height: 580)
                .background(Color.white)
                .cornerRadius(20)
                
                
                // HStack 버튼
                HStack {
                    Button {
                        // action
                    } label: {
                        Image(systemName: "figure.stairs")
                        Text("달성 뱃지")
                        
                    }
                    .frame(height: 50)
                    .frame(width: 152)
                    .foregroundColor(Color.white)
                    .background(Color.buttons)
                    .cornerRadius(12)
                    
                    Spacer()
                    
                    Button {
                        // action
                    } label: {
                        Image(systemName: "figure.stairs")
                        Text("나의 순위")
                    }
                    .frame(height: 50)
                    .frame(width: 152)
                    .foregroundColor(Color.white)
                    .background(Color.buttons)
                    .cornerRadius(12)
                } // HStack // 아래 두개 버튼
                .padding(.top, 20)
                
                
            } // VStack 전체
            .padding(.horizontal, 40)
            .padding(.top, 90)
            .padding(.bottom, 70)
        } // ZStack // 배경색
    } // View
}

// Sheet Size 더 작게 Custom
// extension PresentationDetent {
//  static let small = Self.height(260)
//  static let medium = Self.height(260)
//}

#Preview {
    MainView()
}
