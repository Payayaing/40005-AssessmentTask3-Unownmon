//
//  PokemonDetailViewModel.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

class PokemonDetailViewModel: ObservableObject {
    @Published var pokemon: Pokemon = Pokemon(pokemonData: PokemonData(
        name: "Loading", sprite: nil, types: [], height: 0.0, weight: 0.0, generation: 0
    ))
    
    init(name: String) {
        Task {
            await loadPokemon(named: name)
        }
    }
    
    private func loadPokemon(named name: String) async {
        if let data = await fetchData(name: name) {
            DispatchQueue.main.async {
                self.pokemon = data
            }
        }
    }
    
    func fetchData(name: String) async -> Pokemon? {
        let decoder = JSONDecoder()
        // The Pokemon will always exist, therefore we can forcefully unwrap it in this way instead of using a guard condition. Height & Weight and Generation cannot be found in the same API call, so two calls need to be done to obtain all data needed.
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
        let generationurl = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(name)")!
        do {
            let (baseData, _) = try await URLSession.shared.data(from: url)
            let (generationData, _) = try await URLSession.shared.data(from: generationurl)
            
            let baseResponse = try decoder.decode(PokemonBaseData.self, from: baseData)
            let generationResponse = try decoder.decode(PokemonGenData.self, from: generationData)
            
            return Pokemon(pokemonData: PokemonData(name: baseResponse.name, sprite: baseResponse.sprite, types: baseResponse.types, height: baseResponse.height, weight: baseResponse.weight, generation: generationResponse.generation))
        } catch {
            print("Error occurred while trying to load Pokemon Data: \(error)")
            return nil
        }
    }
}
