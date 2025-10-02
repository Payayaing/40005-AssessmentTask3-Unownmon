//
//  PokemonBaseData.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI

struct PokemonBaseData: Decodable {
    // Decodes PokeAPI JSON from the 'pokemon/[pokemon]' call. This is one of two calls that are made as Generation data is required from the 'pokemon-species/[pokemon]' call.
    let name: String
    let sprite: URL?
    let types: [PokemonType]
    let height: Double
    let weight: Double
    
    // Ignores irrelevant properties from the PokeAPI call by specifying the properties to be considered.
    enum CodingKeys: String, CodingKey {
        case species, sprites, types, height, weight
    }
    
    init(from decoder: Decoder) throws {
        // From the JSON file, contain only the properties specified by the CodingKeys.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        // For readability purposes, the name is automatically formatted and stored. This also allows views to just be able to print the name instead of needing to format it.
        let species = try container.decode(SpeciesWrapper.self, forKey: .species)
        self.name = Pokemon.format(name: species.name)
        
        let sprite = try container.decode(SpriteWrapper.self, forKey: .sprites)
        self.sprite = URL(string: sprite.sprite)
        
        let types = try container.decode(Array<TypeWrapper>.self, forKey: .types)
        self.types = types.map({$0.type})
        
        // JSON stores height and weight as integer values (such as 4.2 being represented as 42). As these Pokemon values only use 1 decimal point, these can be divided by 10 and stored as a Double instead.
        let height = try container.decode(Int.self, forKey: .height)
        self.height = Double(height) / 10.0
        
        let weight = try container.decode(Int.self, forKey: .weight)
        self.weight = Double(weight) / 10.0
    }
}

// Wrapper for Pokemon species. This also ignores the URL field in the JSON file.
private struct SpeciesWrapper: Codable {
    let name: String
}

// Wrapper for Pokemon sprite. The only sprite that is required, as well as provides the most visual information, is the front_default sprite. All others can be ignored.
private struct SpriteWrapper: Codable {
    let sprite: String
    
    enum CodingKeys: String, CodingKey {
        case sprite = "front_default"
    }
}

// Wrapper for Pokemon types. This also ignores the slot field in the JSON file, which is irrelevant as slot can be determined from order in the PokemonType array.
private struct TypeWrapper: Codable {
    let type: PokemonType
}
