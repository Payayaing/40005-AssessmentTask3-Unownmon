//
//  PokemonDetailView.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI

struct PokemonDetailView: View {
    @State var name: String
    @StateObject var viewModel: PokemonDetailViewModel
    
    init(name: String) {
        _name = State(initialValue: name)
        _viewModel = StateObject(wrappedValue: PokemonDetailViewModel(name: name))
    }
    
    var body: some View {
        VStack {
            Text("Name: \(viewModel.pokemon.pokemonData.name)")
            AsyncImage(url: viewModel.pokemon.pokemonData.sprite)
            ForEach(viewModel.pokemon.pokemonData.types, id: \.name) { type in
                Text(type.format())
            }
            Text("Height: \(viewModel.pokemon.pokemonData.height)")
            Text("Weight: \(viewModel.pokemon.pokemonData.weight)")
            Text("Generation: \(viewModel.pokemon.pokemonData.generation)")
        }
    }
}
