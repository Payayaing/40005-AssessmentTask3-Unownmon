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
    @State var pokemon: Pokemon?
    @ObservedObject var viewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            if let pokemon = pokemon {
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
                    path.removeLast(2)
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
            } else {
                Spacer()
                Text("Loading...")
                Spacer()
            }
        }
        .onAppear(perform: {
            Task {
                if let data = await viewModel.fetchData(name: name) {
                    self.pokemon = Pokemon(pokemonData: data)
                }
            }
        })
    }
}
