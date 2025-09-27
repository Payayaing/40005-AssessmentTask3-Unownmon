//
//  PokemonGenData.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI

struct PokemonGenData: Decodable {
    let generation: Int
    let generationFormat = [
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
    
    enum CodingKeys: String, CodingKey {
        case generation = "generation"
    }
    
    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        let generationString = try container.decode(GenerationWrapper.self, forKey: .generation)
        // Generation must be between 1-9 as those are the only currently existing generations (as of 27/09/2025). This dictionary conversion format uses the exact String representation that the API uses to store founding generation data.
        self.generation = generationFormat[generationString.name]!
    }
}

struct GenerationWrapper: Codable {
    let name: String
}
