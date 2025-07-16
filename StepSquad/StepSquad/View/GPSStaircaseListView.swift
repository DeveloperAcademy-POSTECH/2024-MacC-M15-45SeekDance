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
    @Binding var gpsStaircaseWeeklyScore: GPSStaircaseWeeklyScore
    
    let locationManager: LocationManager
    
    let gameCenterManager: GameCenterManager
    
    @Binding var isShowingNewItem: Bool
    
    let columns: [GridItem] = [
        GridItem(.fixed(176)),
        GridItem(.fixed(176))
    ]
    
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 12) {
                ForEach(filteredStaircases) { staircase in
                    NavigationLink(destination: GPSStaircaseDetailView(bookmarks: $bookmarks, collectedItems: $collectedItems, gpsStaircaseWeeklyScore: $gpsStaircaseWeeklyScore, gpsStaircase: staircase, locationManager: locationManager, gameCenterManager: gameCenterManager, isShowingNewItem: $isShowingNewItem), label: {
                        VStack(alignment: .leading) {
                            ZStack {
                                Image(staircase.imageName)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 176, height: 152)
                                    .clipShape(.rect)
                                
                                if collectedItems.isCollected(item: staircase.id) {
                                    Rectangle()
                                        .foregroundStyle(.black)
                                        .opacity(0.4)
                                        .frame(width: 176, height: 152)
                                    
                                    Text("방문 완료")
                                        .font(.footnote)
                                        .bold()
                                        .foregroundStyle(.white)
                                }
                                
                                VStack {
                                    HStack {
                                        Button(action: {
                                            if bookmarks.contains(staircase.id) {
                                                bookmarks.remove(staircase.id)
                                            } else {
                                                bookmarks.add(staircase.id)
                                            }
                                        }, label: {
                                            Image(systemName: bookmarks.contains(staircase.id) ? "bookmark.fill" : "bookmark")
                                                .font(.title3)
                                                .foregroundStyle(.white)
                                                .shadow(color: .black.opacity(0.8), radius: 6.15, x: 0, y: 2)
                                        })
                                        .offset(x: 8, y: 10)
                                        
                                        Spacer()
                                    }
                                    
                                    Spacer()
                                    
                                    HStack {
                                        Spacer()
                                        
                                        Image(staircase.reweardImageName)
                                            .resizable()
                                            .scaledToFill()
                                            .frame(width: 72, height: 72)
                                    }
                                }
                                
                            }
                            
                            VStack(alignment: .leading, spacing: 4) {
                                Text(staircase.title)
                                    .font(.subheadline)
                                    .bold()
                                    .foregroundStyle(.green700)
                                    .multilineTextAlignment(.leading)
                                
                                Text(staircase.name)
                                    .font(.caption2)
                                    .foregroundStyle(.grey700)
                                
                                Spacer()
                                
                                HStack {
                                    Text(staircase.province.rawValue)
                                        .font(.caption2)
                                        .bold()
                                        .foregroundStyle(.grey800)
                                        .padding(4)
                                        .background(RoundedRectangle(cornerRadius: 4).fill(.grey50))
                                    
                                    Text("\(staircase.steps)칸")
                                        .font(.caption2)
                                        .bold()
                                        .foregroundStyle(.green800)
                                        .padding(4)
                                        .background(RoundedRectangle(cornerRadius: 4).fill(.green50))
                                }
                            }
                            .padding(.top, 4)
                            .padding(.bottom, 12)
                            .padding(.horizontal, 8)
                        }
                        .frame(width: 176, height: 252)
                        .background(.white)
                        .clipShape(RoundedRectangle(cornerRadius: 4))
                    })
                }
            }
            Spacer(minLength: 120)
        }
        .ignoresSafeArea()
    }
}

//#Preview {
//    GPSStaircaseListView()
//}
