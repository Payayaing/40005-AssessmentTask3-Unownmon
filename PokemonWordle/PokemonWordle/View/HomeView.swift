//
//  HomeView.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct HomeView: View {
    // Opening view which the user sees when they open the application. NavigationPath allows for clean transitioning between views.
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
                        // Add the GameView NavigationPath, where the user can start playing the main game.
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
                        // Application information is shown using a sheet. This sets the sheet to be visible.
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
                        // Black outline.
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.black, lineWidth: 1))
                    }
                }
                .padding()
            }
            .padding()
            .navigationDestination(for: Screen.self) { screen in
                // Defines all possible navigation destinations for this application. These destinations are specified using a custom Screen enum.
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
            // When the view appears, set the correct Pokemon for the main game. This allows for persistent app data, and only needs to be set once unless the user requests to reset the game in GameView.
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

// Custom enum to allow for easier reference of screens for navigation.
enum Screen: Hashable {
    case game, selector, pokemonDetail(index: Int)
}
