//
//  MainTabView.swift
//  StepSquad
//
//  Created by Groo on 10/5/25.
//

import SwiftUI

@available(iOS 18.0, *)
struct MainTabView: View {
    var body: some View {
        TabView {
            TabView {
                Tab("home", systemImage: "house.fill") {
                    Text("home")
                }
                
                Tab("k-stairs", systemImage: "stairs") {
                    Text("k-stairs")
                }
                
                Tab("my record", systemImage: "person.crop.rectangle.stack.fill") {
                    Text("records")
                }
                .badge("N")
                
                Tab("setting", systemImage: "gear") {
                    Text("setting")
                }
            }
        }
        .tint(.primaryColor)
    }
}

#Preview {
    if #available(iOS 18.0, *) {
        MainTabView()
    } else {
        // Fallback on earlier versions
    }
}
