//
//  GuessView.swift
//  PokemonWordle
//
//  Created by Bella on 28/9/2025.
//

import SwiftUI

struct GuessView: View {
    // This view displays a guessed Pokemon with comparison of its stats against the hidden correct Pokemon. In GameView, all the player sees are comparison arrows (up, down, equal, etc.), so the player is able to view the stats of a requested Pokemon with a tap gesture. This shows an alert with the message containing stats, which is easily dismissible.
    @State var guess: Pokemon
    @State var correct: Pokemon
    @State var comparison: [String: Comparison]?
    @State var showAlert: Bool = false
    @State var alertMessage: String = ""

    var body: some View {
        HStack(alignment: .center) {
            AsyncImage(url: guess.pokemonData.sprite)
            // In the event that the View loads without the main comparison table, unwrap the table safely instead to prevent unwrapping nil crashes. All keys in the table are forcefully unwrapped as they are guaranteed to be in the table.
            if let comparison = self.comparison {
                VStack {
                    Image(comparison["generation"]!.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                VStack {
                    Image(comparison["type1"]!.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                VStack {
                    Image(comparison["type2"]!.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                VStack {
                    Image(comparison["height"]!.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
                
                VStack {
                    Image(comparison["weight"]!.image)
                        .resizable()
                        .frame(width: 50, height: 50)
                }
            }
        }
        .onAppear(perform: {
            self.comparison = self.guess.comparePokemon(second: self.correct)
        })
        .onTapGesture {
            //Show Pokemon stats using the inbuilt Swift alert.
            self.alertMessage = "Generation: \(self.guess.getGeneration())\nType 1: \(self.guess.getFirstType())\nType 2: \(self.guess.getSecondType())\nHeight: \(self.guess.getHeight().formatted(.number.precision(.fractionLength(1))))m\nWeight: \(self.guess.getWeight().formatted(.number.precision(.fractionLength(1))))kg"
            self.showAlert = true
        }
        .alert("\(guess.format())", isPresented: $showAlert) {
            Button("OK", role: .cancel) {}
        } message: {
            Text(alertMessage)
        }
    }
}
