//
//  GameView.swift
//  PokemonWordle
//
//  Created by Bella on 26/9/2025.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    
    var body: some View {
        NavigationStack {
            VStack {
                if let pokemon = viewModel.correctPokemon {
                    Text("Correct Pokemon: \(pokemon.pokemonData.name)")
                }
                HStack {
                    NavigationLink(destination: SelectorView(gameViewModel: viewModel)) {
                        HStack {
                            Text("Make a Guess!")
                        }
                        .padding()
                        .frame(maxWidth: 150)
                        .background(Color(hex: 0xA6CAF5))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                }
                
                ForEach(viewModel.pokemonGuesses) { guess in
                    GuessView(pokemon: guess)
                }
                
                Button(action: {
                    Task {
                        await viewModel.resetGame()
                    }
                }) {
                    HStack {
                        Text("Reset Game")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: 0xA6CAF5))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                }
            }
        }
    }
}

#Preview {
    GameView(viewModel: GameViewModel())
}
