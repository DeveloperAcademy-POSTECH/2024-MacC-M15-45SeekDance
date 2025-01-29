//
//  ColorExtension.swift
//  StepSquad
//
//  Created by hanseoyoung on 11/12/24.
//

import SwiftUI

extension Color {
    static let primaryColor = Color("primaryColor")
    static let secondaryColor = Color("secondaryColor")
    static let backgroundColor = Color("backgroundColor")

    static let Green50 = Color("Green50")
    static let Green100 = Color("Green100")
    static let Green200 = Color("Green200")
    static let Green300 = Color("Green300")
    static let Green400 = Color("Green400")
    static let Green500 = Color("Green500")
    static let Green600 = Color("Green600")
    static let Green700 = Color("Green700")
    static let Green800 = Color("Green800")
    static let Green900 = Color("Green900")

    static let Brown50 = Color("Brown50")
    static let Brown100 = Color("Brown100")
    static let Brown200 = Color("Brown200")
    static let Brown300 = Color("Brown300")
    static let Brown400 = Color("Brown400")
    static let Brown500 = Color("Brown500")
    static let Brown600 = Color("Brown600")
    static let Brown700 = Color("Brown700")
    static let Brown800 = Color("Brown800")
    static let Brown900 = Color("Brown900")

    static let Blue50 = Color("Blue50")
    static let Blue100 = Color("Blue100")
    static let Blue200 = Color("Blue200")
    static let Blue300 = Color("Blue300")
    static let Blue400 = Color("Blue400")
    static let Blue500 = Color("Blue500")
    static let Blue600 = Color("Blue600")
    static let Blue700 = Color("Blue700")
    static let Blue800 = Color("Blue800")
    static let Blue900 = Color("Blue900")

    static let Violet50 = Color("Violet50")
    static let Violet100 = Color("Violet100")
    static let Violet200 = Color("Violet200")
    static let Violet300 = Color("Violet300")
    static let Violet400 = Color("Violet400")
    static let Violet500 = Color("Violet500")
    static let Violet600 = Color("Violet600")
    static let Violet700 = Color("Violet700")
    static let Violet800 = Color("Violet800")
    static let Violet900 = Color("Violet900")

    static let Grey50 = Color("Grey50")
    static let Grey100 = Color("Grey100")
    static let Grey200 = Color("Grey200")
    static let Grey300 = Color("Grey300")
    static let Grey400 = Color("Grey400")
    static let Grey500 = Color("Grey500")
    static let Grey600 = Color("Grey600")
    static let Grey700 = Color("Grey700")
    static let Grey800 = Color("Grey800")
    static let Grey900 = Color("Grey900")

    static let Orange50 = Color("Orange50")
    static let Orange100 = Color("Orange100")
    static let Orange200 = Color("Orange200")
    static let Orange300 = Color("Orange300")
    static let Orange400 = Color("Orange400")
    static let Orange500 = Color("Orange500")
    static let Orange600 = Color("Orange600")
    static let Orange700 = Color("Orange700")
    static let Orange800 = Color("Orange800")
    static let Orange900 = Color("Orange900")

    static let Yellow50 = Color("Yellow50")
    static let Yellow100 = Color("Yellow100")
    static let Yellow200 = Color("Yellow200")
    static let Yellow300 = Color("Yellow300")
    static let Yellow400 = Color("Yellow400")
    static let Yellow500 = Color("Yellow500")
    static let Yellow600 = Color("Yellow600")
    static let Yellow700 = Color("Yellow700")
    static let Yellow800 = Color("Yellow800")
    static let Yellow900 = Color("Yellow900")

    static let NeutralWhite = Color("NeutralWhite")
    static let NetralBlack = Color("NetralBlack")

}

extension Color {
    init(hex: UInt, alpha: Double = 1) {
        self.init(
            .sRGB,
            red: Double((hex >> 16) & 0xff) / 255,
            green: Double((hex >> 08) & 0xff) / 255,
            blue: Double((hex >> 00) & 0xff) / 255,
            opacity: alpha
        )
    }
}
