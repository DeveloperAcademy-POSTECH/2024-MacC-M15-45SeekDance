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
    let keyword: String
    
    init(item: String, itemImage: String, itemColor: UInt, achievementId: String, keyword: String) {
        self.item = item
        self.itemImage = itemImage
        self.itemColor = itemColor
        self.achievementId = achievementId
        self.keyword = keyword
    }
}

let hiddenItems: [String: Item] = [
    "Bullocho": Item(
        item: "불로초",
        itemImage: "Bullocho",
        itemColor: 0x03787B,
        achievementId: "bullocho",
        keyword: "NFC"),
    "Clover": Item(
        item: "네잎 클로버",
        itemImage: "Clover",
        itemColor: 0x03787B,
        achievementId: "clover",
        keyword: "히든")
]
