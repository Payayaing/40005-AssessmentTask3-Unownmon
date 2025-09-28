//
//  GuessView.swift
//  PokemonWordle
//
//  Created by Bella on 28/9/2025.
//

import SwiftUI

struct GuessView: View {
    @State var pokemon: Pokemon
    
    var body: some View {
        HStack {
            Text(pokemon.pokemonData.name)
            AsyncImage(url: pokemon.pokemonData.sprite)
            ForEach(pokemon.pokemonData.types, id: \.name) { type in
                Text(type.format())
            }
            Text("\(String(format: "%.1f", pokemon.pokemonData.height))m")
            Text("\(String(format: "%.1f", pokemon.pokemonData.weight))kg")
            Text("\(pokemon.pokemonData.generation)")
        }
    }
}
