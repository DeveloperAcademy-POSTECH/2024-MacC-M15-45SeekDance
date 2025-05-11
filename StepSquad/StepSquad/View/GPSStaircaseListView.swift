//
//  GPSStaircaseListView.swift
//  StepSquad
//
//  Created by Groo on 5/7/25.
//

import SwiftUI

struct GPSStaircaseListView: View {
//    let columns: [GridItem] = Array(repeating: .init(.flexible()), count: 2)
    let columns: [GridItem] = [
        GridItem(.flexible(), spacing: 8),
        GridItem(.flexible(), spacing: 8)
    ]
    var body: some View {
        ScrollView {
            LazyVGrid(columns: columns, spacing: 28) {
                ForEach(gpsStaircases) { staircase in
                    GPSStaircaseThumbnailView(staircase: staircase)
                }
            }
            
//            Grid {
//                ForEach(gpsStaircases) { staircase in
//                    GridRow() {
//                        GPSStaircaseThumbnailView(staircase: staircase)
//                        GPSStaircaseThumbnailView(staircase: staircase)
//                            .padding(.leading, 20)
//                    }
//                    .padding(.bottom, 20)
//                }
//            }
//            .frame(maxWidth: .infinity)
        }
        .background(.grey50)
        .ignoresSafeArea()
    }
}

#Preview {
    GPSStaircaseListView()
}

struct GPSStaircaseThumbnailView: View {
    let staircase: GPSStaircase
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text(staircase.title)
                .font(.footnote)
                .bold()
                .foregroundStyle(.green700)
                .frame(maxWidth: .infinity)
                .multilineTextAlignment(.center)
            
            Image(staircase.imageName)
                .resizable()
                .scaledToFill()
                .frame(width: 124, height: 108)
                .clipShape(Rectangle())
            
            HStack {
                Text(staircase.name)
                    .font(.footnote)
                    .bold()
                Spacer()
                Button(action: {
                    // TODO: 북마크 기능 설정
                }, label: {
                    Image(systemName: "bookmark")
                        .font(.caption)
                        .foregroundStyle(.grey400)
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
        .background(RoundedRectangle(cornerRadius: 4).fill(.white).frame(width: 148, height: 244))
    }
}
