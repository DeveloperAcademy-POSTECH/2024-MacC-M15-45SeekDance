//
//  CustomTableView.swift
//  StepSquad
//
//  Created by hanseoyoung on 1/22/25.
//

import SwiftUI

struct CustomTableView: View {
    let headers = ["회차", "층수", "일자", "하산날짜"]
    let rows = [
        ["2", "1445", "100일", "25.01.20"],
        ["1", "1480", "102일", "25.01.20"]
    ]

    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                ForEach(headers, id: \.self) { header in
                    Text(header)
                        .font(.system(size: 15))
                        .frame(maxWidth: .infinity)
                        .padding(10)
                        .background(Color(hex: 0xB1D998))
                        .foregroundColor(Color(hex: 0x3A542B))
                }
            }
            .background(RoundedRectangle(cornerRadius: 10).fill(Color(red: 0.85, green: 0.93, blue: 0.80)))
            .roundedCorner(10, corners: [.topLeft, .topRight])

            ForEach(rows, id: \.self) { row in
                HStack(spacing: 0) {
                    ForEach(row, id: \.self) { cell in
                        Text(cell)
                            .font(.system(size: 13))
                            .frame(maxWidth: .infinity)
                            .padding(10)
                            .background(Color(hex: 0xF3F9F0))
                            .foregroundColor(Color(hex: 0x3A542B))

                    }
                }
                .border(Color(hex: 0xDBEED0), width: 0.5)
            }
        }
    }

}

struct CustomTableView_Previews: PreviewProvider {
    static var previews: some View {
        CustomTableView()
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
