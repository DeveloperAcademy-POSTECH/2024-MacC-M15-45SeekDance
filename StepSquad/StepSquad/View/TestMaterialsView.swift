//
//  MaterialsView.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/12/24.
//

import SwiftUI

struct TestMaterialsView: View {
    @Binding var isMaterialSheetPresented: Bool
    @Binding var isShowingNewItem: Bool
    @State private var isEmpty = false
    var body: some View {
        NavigationView {
            ZStack() {
                Color.backgroundColor.ignoresSafeArea()
                
                VStack {
                    if isEmpty {
                        EmptyItemView()
                    } else {
                        List {
                            Section(header: Text("일반 재료").bold(), footer: Text("일반 재료는 계단 오르기만을 통해서만 얻을 수 있습니다.")) {
                                ForEach((1...19).reversed(), id: \.self) { level in
                                    HStack(spacing: 0) {
                                        Image(levels[level]!.itemImage) // 약재 이미지
                                            .resizable()
                                            .aspectRatio(1, contentMode: .fit)
                                            .frame(width: 42, height: 42)
                                            .padding(.trailing, 0)
                                        
                                        Text("레벨 \(level)") // 레벨 표시
                                            .font(.system(size: 12))
                                            .foregroundStyle(getDifficultyColor(difficulty: levels[level]!.difficulty))
                                            .padding(4)
                                            .background(getDifficultyPaleColor(difficulty: levels[level]!.difficulty), in: RoundedRectangle(cornerRadius: 4))
                                            .padding(.horizontal, 8)
                                        
                                        Text(" \(levels[level]!.item)") // 약재 이름
                                            .font(.system(size: 17))
                                        
                                        Spacer()
                                        
                                        Text("12/34/5678") // 레벨 달성 날짜
                                            .font(.system(size: 15))
                                            .foregroundStyle(Color(hex: 0x3C3C43))
                                            .opacity(0.6)
                                    }
                                    .padding(.horizontal, 4)
                                }
                            }
                        }
                        .scrollContentBackground(.hidden)
                        .background(.clear)
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
                
                VStack {
                    Spacer()
                    HStack {
                        Text("주의: 계단사랑단 앱은 게임입니다. 실제 의학적 참고, 권고, 진단등을 위해 앱을 활용하면 안 됩니다.")
                            .font(.system(size: 15))
                            .foregroundStyle(Color(hex: 0x8F8F8F))
                            .padding(.vertical)
                    }
                    .background(Color.backgroundColor)
                }
                
                Button("reverse empty") {
                    isEmpty.toggle()
                }
                .buttonStyle(.borderedProminent)
                
            }
        }
        .onAppear {
            isShowingNewItem = false
        }
    }
}

#Preview {
    TestMaterialsView(isMaterialSheetPresented: .constant(true), isShowingNewItem: .constant(false))
}
