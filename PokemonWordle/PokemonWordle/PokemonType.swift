//
//  PokemonType.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct PokemonType: Codable {
    let name: String
    
    func format() -> String {
        return self.name.capitalized
    }
    
    func color() -> Color {
        switch (self.name) {
        case "normal":
            return Color(hex: 0xA8A77A)
        case "fire":
            return Color(hex: 0xEE8130)
        case "water":
            return Color(hex: 0x6390F0)
        case "electric":
            return Color(hex: 0xF7D02C)
        case "ground":
            return Color(hex: 0xE2BF65)
        case "grass":
            return Color(hex: 0x7AC74C)
        case "ice":
            return Color(hex: 0x96D9D6)
        case "fighting":
            return Color(hex: 0xC22E28)
        case "flying":
            return Color(hex: 0xA98FF3)
        case "poison":
            return Color(hex: 0xA33EA1)
        case "psychic":
            return Color(hex: 0xF95587)
        case "bug":
            return Color(hex: 0xA6B91A)
        case "rock":
            return Color(hex: 0xB6A136)
        case "ghost":
            return Color(hex: 0x735797)
        case "dragon":
            return Color(hex: 0x6F35FC)
        case "dark":
            return Color(hex: 0x705746)
        case "steel":
            return Color(hex: 0xB7B7CE)
        case "fairy":
            return Color(hex: 0xD685AD)
        default:
            return Color.gray
        }
    }
}
