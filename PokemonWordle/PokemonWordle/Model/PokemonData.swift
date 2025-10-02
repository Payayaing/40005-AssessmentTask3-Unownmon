//
//  PokemonData.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct PokemonData: Codable {
    // Combines decoded PokeAPI data from PokemonBaseData and PokemonGenData, so that this information is accessible in one structure. This is stored in UserDefaults, so this structure conforms to the Codable protocol.
    let name: String
    let sprite: URL?
    var types: [PokemonType]
    let height: Double
    let weight: Double
    let generation: Int
    
    init(name: String, sprite: URL?, types: [PokemonType], height: Double, weight: Double, generation: Int) {
        self.name = name
        self.sprite = sprite
        self.types = types
        
        // This application requires to show both typings. As such, a placeholder typing "None" is used for singular typed Pokemon. This also indicates to the user that the correct Pokemon only has one type.
        if self.types.count == 1 {
            self.types.append(PokemonType(name: "None"))
        }
        
        self.height = height
        self.weight = weight
        self.generation = generation
    }
}
