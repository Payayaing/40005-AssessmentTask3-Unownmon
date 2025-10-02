//
//  PokemonGenData.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI

struct PokemonGenData: Decodable {
    // Decodes PokeAPI JSON from the 'pokemon-species/[pokemon]' call. This is the second call made, which only needs to obtain generation data. A string to integer dictionary is provided to convert the generation string into an integer.
    let generation: Int
    let generationFormat: [String: Int] = [
        "generation-i": 1,
        "generation-ii": 2,
        "generation-iii": 3,
        "generation-iv": 4,
        "generation-v": 5,
        "generation-vi": 6,
        "generation-vii": 7,
        "generation-viii": 8,
        "generation-ix": 9
    ]

    // As all other information is obtained from the 'pokemon' call, the only data needed is generation. Ignore all other fields.
    enum CodingKeys: String, CodingKey {
        case generation = "generation"
    }
    
    init(from decoder: Decoder) throws {
        // From the JSON file, contain only the properties specified by the CodingKeys.
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let generationString = try container.decode(GenerationWrapper.self, forKey: .generation)
        // Generation must be between 1-9 as those are the only currently existing generations (as of 27/09/2025). This dictionary conversion format uses the exact String representation that the API uses to store founding generation data.
        self.generation = generationFormat[generationString.name]!
    }
}

// Wrapper for Pokemon generation. This also ignores the URL field in the JSON file.
struct GenerationWrapper: Codable {
    let name: String
}
