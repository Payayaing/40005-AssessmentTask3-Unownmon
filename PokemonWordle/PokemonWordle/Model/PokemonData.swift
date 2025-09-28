//
//  PokemonData.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct PokemonData: Codable {
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
        if self.types.count == 1 {
            self.types.append(PokemonType(name: "None"))
        }
        self.height = height
        self.weight = weight
        self.generation = generation
    }
}
