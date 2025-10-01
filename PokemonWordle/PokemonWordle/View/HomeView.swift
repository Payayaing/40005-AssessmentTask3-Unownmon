//
//  HomeView.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject var viewModel: GameViewModel
    @State private var path = NavigationPath()
    @State var showSheet: Bool = false
    
    var body: some View {
        NavigationStack(path: $path) {
            ZStack {
                //Placeholder background colour. It's ugly. Change please. :>
                //Color.teal.ignoresSafeArea()
                VStack {
                    HStack(spacing: 0) {
                        Image("unown")
                            .resizable()
                            .scaledToFill()
                            .frame(width: 100, height: 100)
                        
                        Text("Unownmon")
                            .font(.largeTitle)
                            .bold()
                    }
                    
                    Button(action: {
                        path.append(Screen.game)
                    }) {
                        HStack {
                            Text("Play! :>")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0x51F074))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .font(.headline)
                    }
                    
                    Button(action: {
                        self.showSheet = true
                    }) {
                        HStack {
                            Text("Information!")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xF2F54E))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                        .font(.headline)
                    }
                }
                .padding()
            }
            .navigationDestination(for: Screen.self) { screen in
                switch screen {
                case .game:
                    GameView(path: $path)
                case .selector:
                    SelectorView(path: $path)
                case .pokemonDetail(let index):
                    PokemonDetailView(index: index, path: $path)
                }
            }
        }
        .onAppear(perform: {
            Task {
                await viewModel.setCorrectPokemon()
            }
        })
        .sheet(isPresented: $showSheet) {
            InfoView()
        }
    }
}

#Preview {
    HomeView()
}

enum Screen: Hashable {
    case game, selector, pokemonDetail(index: Int)
}
