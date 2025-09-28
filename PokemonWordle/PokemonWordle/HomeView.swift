//
//  HomeView.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct HomeView: View {
    @State var username: String = ""
    @StateObject var viewModel = GameViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                //Placeholder background colour. It's ugly. Change please. :>
                //Color.teal.ignoresSafeArea()
                VStack {
                    Text("Unownmon")
                        .font(.largeTitle)
                        .bold()
                    
                    HStack {
                        Text("Username:")
                        TextField("Hi", text: $username)
                            .textFieldStyle(.roundedBorder)
                    }
                    .padding()
                    
                    NavigationLink(destination: GameView(viewModel: viewModel)) {
                        HStack {
                            Text("Play! :>")
                        }
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xA6CAF5))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                    
                    NavigationLink(destination: LeaderboardView()) {
                        HStack {
                            Text("Leaderboard :>")
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
