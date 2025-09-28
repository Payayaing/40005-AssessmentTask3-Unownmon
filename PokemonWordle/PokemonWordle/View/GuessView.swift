//
//  GuessView.swift
//  PokemonWordle
//
//  Created by Bella on 28/9/2025.
//

import SwiftUI

struct GuessView: View {
    @State var guess: Pokemon
    @State var correct: Pokemon
    
    var body: some View {
        HStack {
            VStack {
                Text(guess.pokemonData.name)
                AsyncImage(url: guess.pokemonData.sprite)
            }
            ForEach(guess.pokemonData.types, id: \.name) { type in
                Text(type.format())
            }
            Text("\(String(format: "%.1f", guess.pokemonData.height))m")
            Text("\(String(format: "%.1f", guess.pokemonData.weight))kg")
            Text("\(guess.pokemonData.generation)")
        }
    }
}
