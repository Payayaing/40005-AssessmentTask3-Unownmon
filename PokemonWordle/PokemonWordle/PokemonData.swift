//
//  PokemonData.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct PokemonData: Decodable {
    let name: String
    let sprite: URL?
    let types: [PokemonType]
    let height: Double
    let weight: Double
    let generation: Int = 0
    
    enum CodingKeys: String, CodingKey {
        case species, sprites, types, height, weight
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        let species = try container.decode(SpeciesWrapper.self, forKey: .species)
        self.name = Pokemon.format(name: species.name)
        
        let sprite = try container.decode(SpriteWrapper.self, forKey: .sprites)
        self.sprite = URL(string: sprite.sprite)
        
        let types = try container.decode(Array<TypeWrapper>.self, forKey: .types)
        self.types = types.map({$0.type})
        
        let height = try container.decode(HeightWrapper.self, forKey: .height)
        self.height = Double(height.height / 10)
        
        let weight = try container.decode(WeightWrapper.self, forKey: .weight)
        self.weight = Double(weight.weight / 10)
    }
}

private struct SpeciesWrapper: Codable {
    let name: String
}

private struct SpriteWrapper: Codable {
    let sprite: String
    
    enum CodingKeys: String, CodingKey {
        case sprite = "front_default"
    }
}

private struct TypeWrapper: Codable {
    let type: PokemonType
}

private struct HeightWrapper: Codable {
    let height: Int
}

private struct WeightWrapper: Codable {
    let weight: Int
}
