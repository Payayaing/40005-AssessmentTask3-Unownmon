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
            // Include this line when debugging/testing win conditions.
            //Text("Correct Pokemon: \(viewModel.correctPokemon?.format() ?? "None")")
            
            Text("Guess that Pokemon! You have **\(viewModel.numGuesses)** guesses left.\n(Hint: Tap on each guess to see Pokemon details!)")
                .multilineTextAlignment(.center)
                .padding(.bottom, 10)
            
            // Instead of using Text for each attribute, this uses a ForEach that goes through each of the list items and uses them for the headings, including Spacer when needed.
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
            
            //
            ScrollView(.vertical) {
                // Communicates to the user that they have no guesses, and they should make a guess using the below button.
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
                    // Add the SelectorView NavigationPath, providing a list of Pokemon that they can make a guess from.
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
                    .opacity(viewModel.gameState != .progress ? 0.5 : 1.0) // Visually indicates to the user that they are unable to use the button if the game is over.
                    .font(.headline)
                }
                .disabled(viewModel.gameState != .progress) // Does not allow for the user to make a guess if the game is over.
                
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
                        // Notes are shown as a sheet attached to this view. This triggers the sheet to appear.
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
        .onChange(of: viewModel.gameState) { // Listening to the game state such that the UI can react accordingly if the game is over. If the game is over, then an alert is shown which either congratulates the user or tells them they lost.
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
            } else { // In case the correct Pokemon did not load properly, thus avoiding a potential crash. This supports this application's method of error handling being to handle it silently without causing a crash.
                Text("Please close this and reset the game! :>")
            }
        }
        .sheet(isPresented: $showSheet) {
            NoteView()
                .presentationDetents([.medium, .large])
        }
    }
}
