//
//  MaterialsView.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/12/24.
//

import SwiftUI

struct MaterialsView: View {
    @Binding var isMaterialSheetPresented: Bool
    @Binding var isShowingNewItem: Bool
    var completedLevels: CompletedLevels

    var body: some View {
        NavigationView {
            ZStack() {
                Color.backgroundColor.ignoresSafeArea()

                VStack() {
                    List {
                        if completedLevels.lastUpdatedLevel > 0 { // 획득한 약재가 있을 때
                            ForEach(1...completedLevels.lastUpdatedLevel, id: \.self) { level in
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

                                    Text(completedLevels.getCompletedDateString(level: level)) // 레벨 달성 날짜
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

                    Text("주의: 계단사랑단 앱은 게임입니다. 실제 의학적 참고, 권고, 진단등을 위해 앱을 활용하면 안 됩니다.")
                        .font(.system(size: 15))
                        .foregroundStyle(Color(hex: 0x8F8F8F))
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
        .onAppear {
            isShowingNewItem = false
        }
    }
}
