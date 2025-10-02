//
//  PokemonDetailView.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

struct PokemonDetailView: View {
    // This view displays detailed stats for each Pokemon, requiring the API number (or list index) to fetch the data correctly.
    @State var index: Int
    @State var pokemon: Pokemon?
    @State var showSheet: Bool = false
    @State var showAlert: Bool = false
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            // Safely unwraps the pokemon to avoid crashes from forcefully unwrapping a nil value, as the application needs to wait for the PokeAPI fetch. Before the data is successfully obtained, the Pokemon is nil.
            if let pokemon = pokemon {
                Spacer()
                HStack {
                    AsyncImage(url: pokemon.pokemonData.sprite) { result in
                        result.image?
                            .resizable()
                            .scaledToFill()
                    }
                    .frame(width: 150, height: 150)
                    
                    VStack {
                        Text(pokemon.pokemonData.name)
                            .font(.title)
                            .bold()
                        
                        // Display each type as text with corresponding type colours.
                        HStack {
                            ForEach(pokemon.pokemonData.types, id: \.name) { type in
                                Text(type.format())
                                    .padding(.horizontal, 8)
                                    .padding(.vertical, 4)
                                    .background(type.color())
                                    .foregroundColor(type.textColor())
                                    .cornerRadius(10)
                                    .font(.headline)
                            }
                        }
                    }
                }
                
                // Show height and weight on a linear scale for a more intuitive user experience. The minimum and maximum labels correspond to the minimum and maximum bounds for height and weight respectively.
                Gauge(value: pokemon.getHeight(), in: 0.1...20.0) {
                    Text("Height (m)")
                        .font(.headline)
                } currentValueLabel: {
                    Text("\(pokemon.getHeight().formatted(.number.precision(.fractionLength(1))))")
                        .font(.headline)
                } minimumValueLabel: {
                    Text("0.1")
                } maximumValueLabel: {
                    Text("20.0")
                }
                .tint(pokemon.pokemonData.types.first!.color()) // Pokemon always have two types, so this is guaranteed to be safe.
                .padding()
            
                Gauge(value: pokemon.getWeight(), in: 0.1...999.9) {
                    Text("Weight (kg)")
                        .font(.headline)
                } currentValueLabel: {
                    Text("\(pokemon.getWeight().formatted(.number.precision(.fractionLength(1))))")
                        .font(.headline)
                } minimumValueLabel: {
                    Text("0.1")
                } maximumValueLabel: {
                    Text("999.9")
                }
                .tint(pokemon.pokemonData.types.first!.color())
                .padding()
                
                Text("Founding Generation: \(pokemon.getGeneration())")
                    .font(.headline)
                
                Spacer()
                
                VStack {
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
                    
                    Button(action: {
                        // Adds the Pokemon to the guesses, and navigates the user back to GameView.
                        gameViewModel.addPokemon(pokemon: pokemon)
                        path.removeLast(2)
                    }) {
                        HStack {
                            Text("Guess this Pokemon!")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0x51F074))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .font(.headline)
                    }
                }
                .padding()
            } else {
                // While the Pokemon is nil, display 'Loading'.
                Spacer()
                Text("Loading...")
                Spacer()
            }
        }
        .onAppear(perform: {
            // When the view appears, fetch the selected Pokemon's data to display. If this process fails, then alert the user and provides instructions for what the user should do.
            Task {
                if let data = await gameViewModel.fetchData(index: index) {
                    self.pokemon = Pokemon(pokemonData: data)
                } else {
                    self.showAlert = true
                }
            }
        })
        .sheet(isPresented: $showSheet) {
            NoteView()
                .presentationDetents([.medium, .large])
        }
        .alert("An Error Occurred", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("An error occurred trying to fetch the data for this Pokemon. Please try again in a little bit or try a different Pokemon. Thank you :>")
        }
    }
}
