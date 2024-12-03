//
//  StairModel.swift
//  Gari
//
//  Created by hanseoyoung on 10/27/24.
//

import Foundation

class StairModel: Codable {
    var id: UUID
    var name: String
    var numberOfStairs: Int
    var serialNumber: String
    var isVisited: Bool
    var stickerName: String

    init(id: UUID = UUID(), name: String, numberOfStairs: Int, serialNumber: String, isVisited: Bool = false, stickerName: String = "") {
        self.id = id
        self.name = name
        self.numberOfStairs = numberOfStairs
        self.serialNumber = serialNumber
        self.isVisited = isVisited
        self.stickerName = stickerName
    }
}

// MARK: - NFC 태그를 설치한 계단들

let gariStairs: [StairModel] = [
    StairModel(name: "포스텍 78계단", numberOfStairs: 78, serialNumber: "04d1c489230289", stickerName: ""),
    StairModel(name: "포스텍 C5 5층에서 6층", numberOfStairs: 25, serialNumber: "0443a4eb210289", stickerName: ""),
    StairModel(name: "포스텍 C5 1층에서 5층", numberOfStairs: 114, serialNumber: "0463e4e1200289", stickerName: ""),
    StairModel(name: "test11", numberOfStairs: 1, serialNumber: "0431907b230289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "0421f87f230289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "0433950f220289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "04434ae9200289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "0471737c230289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "0441197d230289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "04d19bba230289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "04f16f7d230289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "0403e11b220289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "0453e1e9200289", stickerName: ""),
    StairModel(name: "45식단 쇼케이스 부스", numberOfStairs: 100, serialNumber: "0453bd28220289", stickerName: ""),
    StairModel(name: "포스텍 108계단", numberOfStairs: 108, serialNumber: "04a34113220289", stickerName: ""),
]
