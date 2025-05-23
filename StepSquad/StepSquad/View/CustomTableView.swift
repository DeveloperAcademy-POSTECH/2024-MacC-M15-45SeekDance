//
//  CustomTableView.swift
//  StepSquad
//
//  Created by hanseoyoung on 1/22/25.
//

import SwiftUI

struct CustomTableView: View {
    
    @ObservedObject var manager: ClimbingManager
    
    let headers = ["회차", "층수", "일자", "하산 일"]
    
    var body: some View {
        VStack(spacing: 0) {
            // Header Row
            HStack(spacing: 0) {
                Text("회차")
                    .frame(maxWidth: 48)
                Text("층수")
                    .frame(maxWidth: 60)
                Text("일자")
                    .frame(maxWidth: 60)
                Text("하산 날짜")
                    .frame(maxWidth: .infinity)
            }
            .font(.system(size: 15))
            .padding(10)
            .background(.green300)
            .foregroundColor(.green900)
            .background(RoundedRectangle(cornerRadius: 10)
                .fill(Color(red: 0.85, green: 0.93, blue: 0.80)))
            .roundedCorner(10, corners: [.topLeft, .topRight])
            // Data Rows
            if manager.records.isEmpty {
                
                // 아직 데이터가 없으면 기본 메시지 표시
                HStack(spacing: 0) {
                    Text("0")
                        .frame(maxWidth: 48)
                    
                    Text("없습니다.")
                        .frame(maxWidth: 60)
                    
                    Text("없습니다.")
                        .frame(maxWidth: 60)
                    
                    Text("없습니다.")
                        .frame(maxWidth: .infinity)
                }
                .font(.system(size: 13))
                .padding(10)
                .background(.green50)
                .foregroundColor(.green900)
                .border(.green100, width: 0.5)
            } else {
                // Data Rows
                ForEach(Array(manager.records.reversed()), id: \.id) { record in
                    HStack(spacing: 0) {
                        // 회차
                        Text("\(record.round)")
                            .frame(maxWidth: 48)
                        
                        // 층수
                        Text("\(Int(record.floorsClimbed))")
                            .frame(maxWidth: 60)
                        
                        // 시간
                        Text("\(record.dDay)")
                            .frame(maxWidth: 60)
                        
                        // 날짜
                        Text(record.descentDate.formattedDate)
                            .frame(maxWidth: .infinity)
                    }
                    .font(.system(size: 13))
                    .padding(10)
                    .background(.green50)
                    .foregroundColor(.green900)
                    .border(.green100, width: 0.5)
                }
            }
        }
    }
}

extension Date {
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yy.MM.dd"
        return formatter.string(from: self)
    }
}


struct CustomTableView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTableView(manager: ClimbingManager())
            .padding()
    }
}

struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

extension View {
    func roundedCorner(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners) )
    }
}
