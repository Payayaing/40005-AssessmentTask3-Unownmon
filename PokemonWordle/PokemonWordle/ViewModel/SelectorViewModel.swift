//
//  SelectorViewModel.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

class SelectorViewModel: ObservableObject {
    // Class responsible for fetching a full list of Pokemon, allowing the user to scroll through valid options in order to make their guess. This also supports live filtering using a filter() method with a search query.
    @Published var pokemonNames: [String] = []
    @Published var filteredNames: [String] = []
    @Published var search: String = ""
    let decoder = JSONDecoder()
    
    // Fetches a full list of Pokemon names from PokeAPI using an async operation. This call could potentially fail, so to prevent an application crash, the error is silently ignored and returns a nil value.
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
    
    // After fetching a full list of Pokemon names in a separate method, set the internal variable to contain this list. This allows for this list to only require one PokeAPI call. The filtered name list uses the full list as a base.
    func loadNames(names: [String]) {
        self.pokemonNames = names
        self.filteredNames = names
    }
    
    // Using the search query stored in this class, which is attached to a TextField in SelectorView, allows for live filtering of the list so that users can find a specific Pokemon much faster. If the search query is an empty string, then just return the full list.
    func filter() {
        if search.isEmpty {
            self.filteredNames = self.pokemonNames
        } else {
            self.filteredNames = self.pokemonNames.filter { Pokemon.format(name: $0).lowercased().contains(self.search.lowercased()) }
        }
    }
    
    // To get the corresponding number that queries PokeAPI for a specific Pokemon, obtain the index of that Pokemon's name within the pokemonNames array.
    func getApiNumber(name: String) -> Int? {
        if let index = self.pokemonNames.firstIndex(where: {$0 == name}) {
            return index + 1
        }
        return nil
    }
}

// Wrapper to hold the list of Pokemon name strings.
struct PokemonList: Codable {
    let results: [PokemonName]
}

struct PokemonName: Codable {
    let name: String
}
