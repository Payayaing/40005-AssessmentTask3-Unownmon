//
//  GameView.swift
//  PokemonWordle
//
//  Created by Bella on 26/9/2025.
//

import SwiftUI

struct GameView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State var showAlert: Bool = false
    @State var showSheet: Bool = false
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack(alignment: .center) {
            //Text("Correct Pokemon: \(viewModel.correctPokemon?.format() ?? "None")")
            
            Text("Guess that Pokemon! You have **\(viewModel.numGuesses)** guesses left.\n(Hint: Tap on each guess to see Pokemon details!)")
                .multilineTextAlignment(.center)
            Spacer()
            
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
                    Text("Make a Guess! :>")
                        .font(.headline)
                        .foregroundColor(Color(hex: 0x2A7D3D))
                } else {
                    ForEach(viewModel.pokemonGuesses) { guess in
                        GuessView(guess: guess, correct: viewModel.correctPokemon!)
                    }
                }
            }
            
            VStack(spacing: 10) {
                Button(action: {
                    path.append(Screen.selector)
                }) {
                    HStack {
                        Text("Make a Guess!")
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: 0x51F074))
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .opacity(viewModel.gameState != .progress ? 0.5 : 1.0)
                    .font(.headline)
                }
                .disabled(viewModel.gameState != .progress)
                
                HStack {
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
                        .background(Color(hex: 0xED4040))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(.headline)
                    }
                    
                    Button(action: {
                        self.showSheet = true
                    }) {
                        HStack {
                            Text("Show Notes")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0x47A1E6))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .font(.headline)
                    }
                }
            }
            .padding()
        }
        .onChange(of: viewModel.gameState) {
            if viewModel.gameState != .progress {
                self.showAlert = true
            }
        }
        .alert(self.viewModel.gameState == .won ? "You won!" : "You lost :<", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            if let correct = viewModel.correctPokemon {
                if viewModel.gameState == .won {
                    Text("You got the correct Pokemon! YIPPEE")
                } else { // .loss condition. This alert can only be triggered by .won or .loss enum change, so .progress does not need to be considered.
                    Text(":< Aw... ran out of guesses. The Pokemon was \(correct.format()). Try again ^-^")
                }
            } else {
                Text("Please close this and reset the game! :>")
            }
        }
        .sheet(isPresented: $showSheet) {
            NoteView()
                .presentationDetents([.medium, .large])
        }
    }
}
