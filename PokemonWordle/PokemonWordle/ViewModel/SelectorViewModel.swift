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
    @Published var search: String = ""
    let decoder = JSONDecoder()
    
    func fetchNames() async -> [String]? {
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon-species?limit=1025&offset=0")!
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
    
    func filter() {
        if search.isEmpty {
            self.filteredNames = self.pokemonNames
        } else {
            self.filteredNames = self.pokemonNames.filter { Pokemon.format(name: $0).lowercased().contains(self.search.lowercased()) }
        }
    }
    
    func getApiNumber(name: String) -> Int? {
        if let index = self.pokemonNames.firstIndex(where: {$0 == name}) {
            return index + 1
        }
        return nil
    }
}
