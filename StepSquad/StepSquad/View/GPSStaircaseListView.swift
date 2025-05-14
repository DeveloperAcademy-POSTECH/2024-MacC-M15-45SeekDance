//
//  GPSStaircaseListView.swift
//  StepSquad
//
//  Created by Groo on 5/7/25.
//

import SwiftUI

struct GPSStaircaseListView: View {
    @Binding var filteredStaircases: [GPSStaircase]
    @Binding var bookmarks: Bookmarks
    @Binding var collectedItems: CollectedItems
    
    let columns: [GridItem] = [
        GridItem(.fixed(148)),
        GridItem(.fixed(148))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 8) {
                ForEach(filteredStaircases) { staircase in
                    VStack(alignment: .leading, spacing: 12) {
                        // TODO: 인증 과정 구현 후 삭제
//                        Button("임시 인증/해제") {
//                            if collectedItems.isCollected(item: staircase.id) {
//                                collectedItems.deleteItem(item: staircase.id)
//                            } else {
//                                collectedItems.collectItem(item: staircase.id, collectedDate: Date.now)
//                            }
//                        }
                        
                        Text(staircase.title)
                            .font(.footnote)
                            .bold()
                            .foregroundStyle(.green700)
                            .frame(maxWidth: .infinity)
                            .multilineTextAlignment(.center)
                        
                        ZStack {
                            Image(staircase.imageName)
                                .resizable()
                                .scaledToFill()
                                .frame(width: 124, height: 108)
                                .clipShape(Rectangle())
                            
                            if collectedItems.isCollected(item: staircase.id) {
                                Rectangle()
                                    .foregroundStyle(.black)
                                    .opacity(0.4)
                                    .frame(width: 124, height: 108)
                                
                                Text("방문 완료")
                                    .font(.footnote)
                                    .bold()
                                    .foregroundStyle(.white)
                            }
                        }
                        
                        HStack {
                            Text(staircase.name)
                                .font(.footnote)
                                .bold()
                            Spacer()
                            Button(action: {
                                if bookmarks.contains(staircase.id) {
                                    bookmarks.remove(staircase.id)
                                } else {
                                    bookmarks.add(staircase.id)
                                }
                            }, label: {
                                Image(systemName: bookmarks.contains(staircase.id) ? "bookmark.fill" : "bookmark")
                                    .font(.caption)
                                    .foregroundStyle(bookmarks.contains(staircase.id) ? .brown500 : .grey400)
                            })
                        }
                        
                        HStack {
                            Text(staircase.province.rawValue)
                                .font(.caption)
                                .foregroundStyle(.white)
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 4).fill(.green600))
                            
                            Text("\(staircase.steps)칸")
                                .font(.caption)
                                .foregroundStyle(.green800)
                                .padding(4)
                                .background(RoundedRectangle(cornerRadius: 4).fill(.green50))
                        }
                    }
                    .frame(width: 124, height: 220)
                    .padding(12)
                    .background(RoundedRectangle(cornerRadius: 4).fill(.white))
                }
            }
        }
        .ignoresSafeArea()
    }
}

//#Preview {
//    GPSStaircaseListView()
//}
