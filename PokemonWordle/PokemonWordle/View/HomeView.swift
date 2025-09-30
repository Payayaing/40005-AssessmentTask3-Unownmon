//
//  HomeView.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct HomeView: View {
    @StateObject var viewModel = GameViewModel()
    @State private var path = NavigationPath()
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                //Placeholder background colour. It's ugly. Change please. :>
                //Color.teal.ignoresSafeArea()
                VStack {
                    Text("Unownmon")
                        .font(.largeTitle)
                        .bold()
                    
                    Button(action: {
                        path.append(Screen.game)
                    }) {
                        HStack {
                            Text("Play! :>")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xA6CAF5))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                    
                    Button(action: {
                        path.append(Screen.settings)
                    }) {
                        HStack {
                            Text("Settings :>")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xA6CAF5))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                }
                .padding()
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .game:
                    GameView(viewModel: viewModel, path: $path)
                case .selector:
                    SelectorView(gameViewModel: viewModel, path: $path)
                case .pokemonDetail(let name):
                    PokemonDetailView(name: name, viewModel: viewModel, path: $path)
                case .settings:
                    LeaderboardView()
                }
            }
        }
        .onAppear(perform: {
            Task {
                await viewModel.setCorrectPokemon()
            }
        })
    }
}

#Preview {
    HomeView()
}

enum Screen: Hashable {
    case game, selector, pokemonDetail(name: String), settings
}
