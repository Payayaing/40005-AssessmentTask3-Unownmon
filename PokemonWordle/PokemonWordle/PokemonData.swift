//
//  PokemonData.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct PokemonData {
    let name: String
    let sprite: URL?
    let types: [PokemonType]
    let height: Double
    let weight: Double
    let generation: Int
    
    init(name: String, sprite: URL?, types: [PokemonType], height: Double, weight: Double, generation: Int) {
        self.name = name
        self.sprite = sprite
        self.types = types
        self.height = height
        self.weight = weight
        self.generation = generation
    }
}
