//
//  ItemModel.swift
//  StepSquad
//
//  Created by Groo on 11/27/24.
//

import SwiftUI

class Item: Codable {
    let item: String
    let itemImage: String
    let itemColor: UInt
    let achievementId: String
    
    init(item: String, itemImage: String, itemColor: UInt, achievementId: String) {
        self.item = item
        self.itemImage = itemImage
        self.itemColor = itemColor
        self.achievementId = achievementId
    }
}

let hiddenItems: [String: Item] = [
    // TODO: - 불로초 성취 이름 변경
    "Bullocho": Item(item: "불로초", itemImage: "Bullocho", itemColor: 0x03787B, achievementId: "infiniteTime"),
]
