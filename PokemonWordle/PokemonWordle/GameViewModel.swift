//
//  GameViewModel.swift
//  PokemonWordle
//
//  Created by Bella on 26/9/2025.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    @Published var pokemonGuesses: [Pokemon] = []
    @Published var correctPokemon: Pokemon?
    let decoder = JSONDecoder()
    
    init() {
        loadGuesses()
        loadCorrectPokemon()
    }
    
    func loadGuesses() {
        if let saved = UserDefaults.standard.data(forKey: "pokemonGuesses") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Pokemon].self, from: saved) {
                self.pokemonGuesses = decoded
            }
        }
    }
    
    func loadCorrectPokemon() {
        if let saved = UserDefaults.standard.data(forKey: "correctPokemon") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Pokemon.self, from: saved) {
                self.correctPokemon = decoded
            }
        }
    }
    
    func saveGuesses() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.pokemonGuesses) {
            UserDefaults.standard.set(encoded, forKey: "pokemonGuesses")
        }
    }
    
    func saveCorrectPokemon() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.correctPokemon) {
            UserDefaults.standard.set(encoded, forKey: "correctPokemon")
        }
    }
    
    func resetGame() async {
        self.pokemonGuesses = []
        self.correctPokemon = nil
        UserDefaults.standard.removeObject(forKey: "pokemonGuesses")
        UserDefaults.standard.removeObject(forKey: "correctPokemon")
        await setCorrectPokemon()
    }
    
    func addPokemon(pokemon: Pokemon) {
        pokemonGuesses.append(pokemon)
        saveGuesses()
    }
    
    func setCorrectPokemon() async {
        if self.correctPokemon != nil {
            return
        }
        let random = Int.random(in: 1...1025)
        if let data = await fetchData(name: String(random)) {
            self.correctPokemon = Pokemon(pokemonData: data)
            saveCorrectPokemon()
        }
    }
    
    func fetchData(name: String) async -> PokemonData? {
        // The Pokemon will always exist, therefore we can forcefully unwrap it in this way instead of using a guard condition. Height & Weight and Generation cannot be found in the same API call, so two calls need to be done to obtain all data needed.
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(name)")!
        let generationurl = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(name)")!
        do {
            let (baseData, _) = try await URLSession.shared.data(from: url)
            let (generationData, _) = try await URLSession.shared.data(from: generationurl)
            
            let baseResponse = try decoder.decode(PokemonBaseData.self, from: baseData)
            let generationResponse = try decoder.decode(PokemonGenData.self, from: generationData)
            
            print("Decoded height: \(baseResponse.height), weight: \(baseResponse.weight)")
            return PokemonData(name: baseResponse.name, sprite: baseResponse.sprite, types: baseResponse.types, height: baseResponse.height, weight: baseResponse.weight, generation: generationResponse.generation)
        } catch {
            print("Error occurred while trying to load Pokemon Data: \(error)")
            return nil
        }
    }
}

struct PokemonList: Codable {
    let results: [PokemonName]
}

struct PokemonName: Codable {
    let name: String
}
