//
//  GameView.swift
//  PokemonWordle
//
//  Created by Bella on 26/9/2025.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel: GameViewModel
    @State var showAlert: Bool = false
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            if let pokemon = viewModel.correctPokemon {
                Text("Correct Pokemon: \(pokemon.pokemonData.name)")
            }
            Text("Guess that Pokemon! You have \(viewModel.numGuesses) guesses left.")
            HStack {
                Button(action: {
                    path.append(Screen.selector)
                }) {
                    HStack {
                        Text("Make a Guess!")
                    }
                    .padding()
                    .frame(maxWidth: 150)
                    .background(Color(hex: 0xA6CAF5))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .opacity(viewModel.gameFinished ? 0.5 : 1.0)
                }
                .disabled(viewModel.gameFinished)
            }
                
            HStack(alignment: .center) {
                let list = ["Pokemon", "Gen", "Type 1", "Type 2", "Height", "Weight"]
                ForEach(list, id:\.self) { item in
                    if item == "Pokemon" {
                        Spacer()
                    }
                    Text(item)
                        .font(.headline)
                        .bold()
                    if item == "Pokemon" {
                        Spacer()
                    }
                }
            }
            .padding(.horizontal, 5)
                
            ScrollView(.vertical) {
                if viewModel.pokemonGuesses.isEmpty {
                    Spacer()
                    Text("Make a Guess!")
                    Spacer()
                } else {
                    ForEach(viewModel.pokemonGuesses) { guess in
                        GuessView(guess: guess, correct: viewModel.correctPokemon!)
                    }
                }
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
        .onChange(of: viewModel.gameFinished) {
            if viewModel.gameFinished {
                self.showAlert = true
            }
        }
        .alert("Game Over!", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let correct = viewModel.correctPokemon {
                Text(":< Aw... ran out of guesses and bitches. The Pokemon was \(correct.format()). Try again bro ^-^")
            } else {
                Text(":< Aw... ran out of guesses and bitches. Try again bro ^-^")
            }
        }
    }
}
