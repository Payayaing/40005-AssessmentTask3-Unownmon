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
            VStack {
                HStack(spacing: 0) {
                    Image("unown")
                        .resizable()
                        .scaledToFill()
                        .frame(width: 65, height: 65)
                    Text("Unownmon")
                        .font(.title)
                        .bold()
                    Spacer()
                }
                .frame(maxWidth: 250)
                  
                VStack(spacing: 15) {
                    Button(action: {
                        path.append(Screen.game)
                    }) {
                        HStack {
                            Text("Play! :>")
                        }
                        .padding()
                        .frame(maxWidth: 250)
                        .background(.black)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                        .font(.headline)
                    }
                        
                    Button(action: {
                        self.showSheet = true
                    }) {
                        HStack {
                            Text("About")
                    }
                    .padding()
                    .frame(maxWidth: 250)
                    .background(.white)
                    .foregroundColor(.black)
                    .cornerRadius(12)
                    .font(.headline)
                    .overlay(
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1))
                    }
                }
                .padding()
            }
            .padding()
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
        .environmentObject(GameViewModel())
}

enum Screen: Hashable {
    case game, selector, pokemonDetail(index: Int)
}
