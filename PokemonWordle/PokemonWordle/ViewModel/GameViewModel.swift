//
//  GameViewModel.swift
//  PokemonWordle
//
//  Created by Bella on 26/9/2025.
//

import SwiftUI
import Combine

class GameViewModel: ObservableObject {
    // This is the main view model that controls the main game logic and flow.
    @Published var pokemonGuesses: [Pokemon] = []
    @Published var correctPokemon: Pokemon?
    @Published var numGuesses: Int = 6
    @Published var gameState: GameState = .progress
    let decoder = JSONDecoder()
    
    init() {
        // When the object is initialised, obtain game data from UserDefaults.
        loadGuesses()
        Task {
            await loadCorrectPokemon()
        }
    }
    
    func loadGuesses() {
        // Fetches number of guesses remaining as well as game state from UserDefaults. If there is an error loading in gameState, then set state as in progress.
        self.numGuesses = UserDefaults.standard.integer(forKey: "numGuesses")
        let state = UserDefaults.standard.string(forKey: "gameState")
        self.gameState = GameState(rawValue: state ?? "progress") ?? .progress
        
        // Fetches saved guesses from UserDefaults and decodes using JSONDecoder, storing them as Pokemon objects. If this fails in any way, then set pokemonGuesses to an empty list.
        if let saved = UserDefaults.standard.data(forKey: "pokemonGuesses") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode([Pokemon].self, from: saved) {
                self.pokemonGuesses = decoded
            } else {
                self.pokemonGuesses = []
            }
        } else {
            self.pokemonGuesses = []
        }
    }
    
    // Fetches the saved hidden Pokemon from UserDefaults and decodes the object using JSONDecoder. If there is no Pokemon saved, then generate a new Pokemon to replace.
    func loadCorrectPokemon() async {
        if let saved = UserDefaults.standard.data(forKey: "correctPokemon") {
            let decoder = JSONDecoder()
            if let decoded = try? decoder.decode(Pokemon.self, from: saved) {
                self.correctPokemon = decoded
            }
        } else {
            await setCorrectPokemon()
        }
    }
    
    // Using a JSONEncoder to encode the full list of Pokemon guesses and save it in UserDefaults. Also save the number of attempts remaining and game progress state. This allows for users to put down and pick up the game in their own time and have their progress saved.
    func saveGuesses() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.pokemonGuesses) {
            UserDefaults.standard.set(encoded, forKey: "pokemonGuesses")
        }
        UserDefaults.standard.set(self.numGuesses, forKey: "numGuesses")
        UserDefaults.standard.set(self.gameState.rawValue, forKey: "gameState")
    }
    
    // Using a JSONEncoder to encode the hidden correct Pokemon and save it in UserDefaults.
    func saveCorrectPokemon() {
        let encoder = JSONEncoder()
        if let encoded = try? encoder.encode(self.correctPokemon) {
            UserDefaults.standard.set(encoded, forKey: "correctPokemon")
        }
    }
    
    // Reset all attributes to default state, and save these to UserDefaults. saveCorrectPokemon() is redundant to call here since setCorrectPokemon() calls this upon generating a new Pokemon anyway.
    func resetGame() async {
        self.pokemonGuesses = []
        self.correctPokemon = nil
        self.numGuesses = 6
        self.gameState = .progress
        self.saveGuesses()
        await setCorrectPokemon()
    }
    
    // When the user selects a Pokemon to guess from PokemonDetailView, add it to the guess list and reduce the number of attempts remaining. This also needs to check whether the guessed Pokemon is the correct one. Since Pokemon names are entirely unique, the names only need to be compared.
    // Safely unwraps the correct Pokemon in the event that this is nil, but this most of the time should not be an issue. This avoids any fatal crashes.
    func addPokemon(pokemon: Pokemon) {
        pokemonGuesses.append(pokemon)
        self.numGuesses -= 1
        if let correct = self.correctPokemon {
            if pokemon.format() == correct.format() {
                self.gameState = .won
            }
            else {
                if self.numGuesses == 0 {
                    self.gameState = .lost
                }
            }
        }
        saveGuesses()
    }
    
    // Randomly generates a set Pokemon. There are 1025 Pokemon in the Pokedex, so randomly generate an index and fetch PokeAPI data for that Pokemon, then save.
    func setCorrectPokemon() async {
        if self.correctPokemon != nil {
            return
        }
        let random = Int.random(in: 1...1025)
        if let data = await fetchData(index: random) {
            self.correctPokemon = Pokemon(pokemonData: data)
            saveCorrectPokemon()
        }
    }
    
    // Fetches specific Pokemon data from PokeAPI using an async operation. This call could potentially fail, so to prevent an application crash, the error is silently ignored and returns a nil value. Two calls are needed to obtain all data for each Pokemon, then combine this data into one PokemonData struct.
    func fetchData(index: Int) async -> PokemonData? {
        // The Pokemon will always exist, therefore we can forcefully unwrap it in this way instead of using a guard condition. Height & Weight and Generation cannot be found in the same API call, so two calls need to be done to obtain all data needed.
        let url = URL(string: "https://pokeapi.co/api/v2/pokemon/\(index)")!
        let generationurl = URL(string: "https://pokeapi.co/api/v2/pokemon-species/\(index)")!
        do {
            let (baseData, _) = try await URLSession.shared.data(from: url)
            let (generationData, _) = try await URLSession.shared.data(from: generationurl)
            
            let baseResponse = try decoder.decode(PokemonBaseData.self, from: baseData)
            let generationResponse = try decoder.decode(PokemonGenData.self, from: generationData)
            
            return PokemonData(name: baseResponse.name, sprite: baseResponse.sprite, types: baseResponse.types, height: baseResponse.height, weight: baseResponse.weight, generation: generationResponse.generation)
        } catch {
            print("Error occurred while trying to load Pokemon Data: \(error)")
            return nil
        }
    }
}

// Custom String enum to indicate game progress.
enum GameState: String {
    case won, lost, progress
}
