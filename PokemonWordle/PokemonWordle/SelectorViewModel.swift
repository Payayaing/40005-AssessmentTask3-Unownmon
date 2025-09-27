//
//  SelectorViewModel.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

class SelectorViewModel: ObservableObject {
    @Published var pokemonNames: [String] = []
    @Published var filteredNames: [String] = []
    let decoder = JSONDecoder()
    
    func fetchNames() async -> [String]? {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon?limit=1025&offset=0")!
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            let response = try decoder.decode(PokemonList.self, from: data)
            let names = response.results.map(\.name)
            return names
        } catch {
            print("Failed to load Pokemon list: \(error)")
            return nil
        }
    }
    
    func loadNames(names: [String]) {
        self.pokemonNames = names
        self.filteredNames = names
    }
    
    func filterNames(with search: String) {
        self.filteredNames = filter(search: search)
    }
    
    func filter(search: String) -> [String] {
        if search.isEmpty {
            return self.pokemonNames
        }
        return self.pokemonNames.filter { Pokemon.format(name: $0).lowercased().contains(search.lowercased()) }
    }
}
