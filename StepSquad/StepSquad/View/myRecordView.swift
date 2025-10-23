//
//  myRecordView.swift
//  StepSquad
//
//  Created by Groo on 10/22/25.
//

import SwiftUI

struct myRecordView: View {
    var userPlayerImage: Image?
    var nickName: String?
    
    @Binding var isRecordSheetPresented: Bool
    
    var completedLevels: CompletedLevels
    var collectedItems: CollectedItems
    
    let columns: [GridItem] = [
        GridItem(.fixed(112)),
        GridItem(.fixed(112)),
        GridItem(.fixed(112))
    ]
    
    var body: some View {
        ZStack {
            Color.grey100
            
            ScrollView {
                VStack {
                    Button(action: {
                        isRecordSheetPresented = true
                    }, label: {
                        HStack {
                            if userPlayerImage != nil {
                                userPlayerImage!
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(.circle)
                            } else {
                                Image("defaultProfile")
                                    .resizable()
                                    .frame(width: 60, height: 60)
                                    .clipShape(.circle)
                            }
                            
                            
                            VStack {
                                Text("계단 오르기 맹세한 지")
                                    .font(.callout)
                                    .foregroundStyle(Color(hex: 0xB1D998))
                                
                                HStack(spacing: 0) {
                                    Text("8222")
                                        .font(.largeTitle)
                                    
                                    Text("일차") // TODO: 글자 아래 맞춤
                                        .font(.title2)
                                }
                                .bold()
                                .foregroundStyle(.white)
                            }
                            
                            Spacer()
                            
                            Image(systemName: "chevron.right")
                                .foregroundStyle(Color(hex: 0xB1D998))
                            
                        }
                        .padding(.horizontal, 16)
                        .padding(.vertical, 24)
                        .background(Color(hex: 0x4C6D38))
                        .clipShape(RoundedRectangle(cornerRadius: 12))
                    })
                    .padding(.top, 70)
                    .padding(.bottom, 20)
                    .padding(.horizontal, 20)
                    
                    Image("bag")
                    
                    VStack {
                        Text("획득 재료")
                            .bold()
                            .padding(.bottom, 8)
                        
                        Text("주의: 계단사랑단 앱을 실제 의학적 참고를 위해 활용하면 안 됩니다.")
                            .frame(width: 194)
                            .font(.caption2)
                            .foregroundStyle(.grey600)
                            .multilineTextAlignment(.center)
                        
                        LazyVGrid(columns: columns, spacing: 0) {
                            ForEach(collectedItems.getSortedItemsNameList(), id: \.self) { item in
                                if Array(gpsStaircasesDictionary.keys).contains(item) { // 전국의 계단 관련 보상
                                    itemView(keyword: "미션", imageName: "\(gpsStaircasesDictionary[item]!.id)_reward", itemName: "\(gpsStaircasesDictionary[item]!.reward)", keywordForegroundColor: .white, keywordBackgroundColor: .green600)
                                } else {
                                    itemView(keyword: hiddenItemsDictionary[item]!.keyword, imageName: hiddenItemsDictionary[item]!.itemImage, itemName: "\(hiddenItemsDictionary[item]!.item)", keywordForegroundColor: .white, keywordBackgroundColor: Color(hex: hiddenItemsDictionary[item]!.itemColor))
                                }
                            }
                            if completedLevels.lastUpdatedLevel >= 1 { // 획득한 약재가 있을 때
                                ForEach((1...completedLevels.lastUpdatedLevel).reversed(), id: \.self) { level in
                                    itemView(keyword: "레벨 \(level)", imageName: levels[level]!.itemImage, itemName: "\(levels[level]!.item)", keywordForegroundColor: getDifficultyColor(difficulty: levels[level]!.difficulty), keywordBackgroundColor: getDifficultyPaleColor(difficulty: levels[level]!.difficulty))
                                }
                            }
                        }
                    }
                    .padding(.vertical, 24)
                    .frame(width: 360)
                    .background(
                        RoundedRectangle(cornerRadius: 100)
                            .foregroundStyle(.white)
                    )
                    .offset(y: -30)
                    .padding(.bottom, 84)
                }
                .padding(.horizontal, 16)
            }
        }
        .ignoresSafeArea()
    }
}

struct itemView: View {
    let keyword: String
    let imageName: String
    let itemName: String
    let keywordForegroundColor: Color
    let keywordBackgroundColor: Color
    
    var body: some View {
        VStack {
            Text(keyword)
                .font(.body)
                .padding(4)
                .foregroundStyle(keywordForegroundColor)
                .background(keywordBackgroundColor)
                .clipShape(RoundedRectangle(cornerRadius: 4))
                .padding(.bottom, 8)
            
            Image(imageName)
                .resizable()
                .scaledToFit()
                .frame(width: 78, height: 78)
            
            Text(itemName)
                .font(.body)
                .padding(.bottom, 8)
                .multilineTextAlignment(.center)
            
            Spacer()
        }
        .frame(width: 78) // TODO: height 설정
        .padding(.horizontal, 17)
        .padding(.vertical, 12)
//        .background(.yellow)
    }
}
