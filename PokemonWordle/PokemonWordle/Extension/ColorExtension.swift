//
//  ColorExtension.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

// Custom extension for Color that accepts a hex code format (0xFF0000) to allow for increased flexibility in colour design within the application.
extension Color {
    init(hex: Int, opacity: Double = 1.0) {
        let red = Double((hex & 0xff0000) >> 16) / 255.0
        let green = Double((hex & 0xff00) >> 8) / 255.0
        let blue = Double(hex & 0xff) / 255.0
        self.init(.sRGB, red: red, green: green, blue: blue, opacity: opacity)
    }
}
