//
//  Bookmarks.swift
//  StepSquad
//
//  Created by Groo on 5/11/25.
//

import SwiftUI

@Observable
class Bookmarks: Codable {
    private var gpsStaircases: Set<String>
    private let key = "Bookmarks"
    let savePath = URL.documentsDirectory.appending(path: "BookmarkedGPSStaircases")
    init() {
        do {
            let data = try Data(contentsOf: savePath)
            let decoded = try JSONDecoder().decode(Set<String>.self, from: data)
            gpsStaircases = decoded
        } catch {
            gpsStaircases = []
        }
    }
    func contains(_ gpsStaircaseID: String) -> Bool {
        if gpsStaircases.contains(gpsStaircaseID) {
            return true
        } else {
            return false
        }
    }
    func add(_ gpsStaircaseID: String) {
        gpsStaircases.insert(gpsStaircaseID)
        save()
    }
    func remove(_ gpsStaircaseID: String) {
        gpsStaircases.remove(gpsStaircaseID)
        save()
    }
    func save() {
        do {
            let data = try JSONEncoder().encode(gpsStaircases)
            try data.write(to: savePath, options: [.atomic, .completeFileProtection])
        } catch {
            print("Unable to save data.")
        }
    }
}
