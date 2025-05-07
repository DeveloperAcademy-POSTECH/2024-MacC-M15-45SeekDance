//
//  GPSStaircaseListView.swift
//  StepSquad
//
//  Created by Groo on 5/7/25.
//

import SwiftUI

struct GPSStaircaseListView: View {
    var body: some View {
        ScrollView {
            Grid {
                ForEach(1..<10) { _ in
                    GridRow() {
                        GPSStaircaseThumbnailView()
                        GPSStaircaseThumbnailView()
                            .padding(.leading, 20)
                    }
                    .padding(.bottom, 20)
                }
            }
            .frame(maxWidth: .infinity)
        }
    }
}

#Preview {
    GPSStaircaseListView()
}

struct GPSStaircaseThumbnailView: View {
    var body: some View {
        VStack(alignment: .leading, spacing: 12) {
            Text("소원을 이뤄주는 계단")
                .font(.footnote)
                .bold()
                .foregroundStyle(.green700)
                .frame(maxWidth: .infinity)
            
            Image("87stairs")
                .resizable()
                .scaledToFill()
                .frame(width: 124, height: 108)
                .clipShape(Rectangle())
            
            HStack {
                Text("팔공산 갓바위")
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
                Text("대구/경북")
                    .font(.caption)
                    .foregroundStyle(.white)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 4).fill(.green600))
                
                Text("1365칸")
                    .font(.caption)
                    .foregroundStyle(.green800)
                    .padding(4)
                    .background(RoundedRectangle(cornerRadius: 4).fill(.green50))
            }
        }
        .frame(width: 124, height: 220)
        .background(RoundedRectangle(cornerRadius: 4).fill(.blue300).frame(width: 148, height: 244))
    }
}
