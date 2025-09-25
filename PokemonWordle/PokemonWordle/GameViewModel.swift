//
//  GameViewModel.swift
//  PokemonWordle
//
//  Created by Bella on 26/9/2025.
//

import SwiftUI

class GameViewModel: ObservableObject {
    @Published var pokemonNames: [String] = []
    let decoder = JSONDecoder()
    
    func fetchPokemonNames() async -> [String] {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1025&offset=0")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try decoder.decode
        }
    }
}
