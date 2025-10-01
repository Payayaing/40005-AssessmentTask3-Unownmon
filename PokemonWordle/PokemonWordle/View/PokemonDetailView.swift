//
//  PokemonDetailView.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

struct PokemonDetailView: View {
    @State var index: Int
    @State var pokemon: Pokemon?
    @State var showSheet: Bool = false
    @EnvironmentObject var gameViewModel: GameViewModel
    @Environment(\.dismiss) var dismiss
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
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
                .tint(pokemon.pokemonData.types.first!.color())
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
                Spacer()
                Text("Loading...")
                Spacer()
            }
        }
        .onAppear(perform: {
            Task {
                if let data = await gameViewModel.fetchData(index: index) {
                    self.pokemon = Pokemon(pokemonData: data)
                }
            }
        })
        .sheet(isPresented: $showSheet) {
            NoteView()
                .presentationDetents([.medium, .large])
        }
    }
}
