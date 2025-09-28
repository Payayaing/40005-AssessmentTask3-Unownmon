//
//  PokemonDetailView.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

struct PokemonDetailView: View {
    @State var name: String
    @State var pokemon: Pokemon = Pokemon(pokemonData: PokemonData(name: "", sprite: URL(string: ""), types: [], height: 0, weight: 0, generation: 0))
    @ObservedObject var viewModel: GameViewModel
    @State var isLoading: Bool = true
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack {
            if isLoading {
                Spacer()
                Text("Loading...")
                Spacer()
            } else {
                Text("Name: \(pokemon.pokemonData.name)")
                AsyncImage(url: pokemon.pokemonData.sprite)
                ForEach(pokemon.pokemonData.types, id: \.name) { type in
                    Text(type.format())
                }
                Text("Height: \(pokemon.pokemonData.height)")
                Text("Weight: \(pokemon.pokemonData.weight)")
                Text("Generation: \(pokemon.pokemonData.generation)")
                Button(action: {
                    viewModel.addPokemon(pokemon: pokemon)
                    dismiss()
                }) {
                    HStack {
                        Text("Guess this Pokemon!")
                    }
                    .padding()
                    .frame(maxWidth: 150)
                    .background(Color(hex: 0xA6CAF5))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                }
            }
        }
        .onAppear(perform: {
            Task {
                if let data = await viewModel.fetchData(name: name) {
                    self.pokemon = Pokemon(pokemonData: data)
                }
                isLoading = false
            }
        })
    }
}
