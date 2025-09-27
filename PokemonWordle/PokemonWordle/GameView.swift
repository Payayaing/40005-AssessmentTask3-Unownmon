//
//  GameView.swift
//  PokemonWordle
//
//  Created by Bella on 26/9/2025.
//

import SwiftUI

struct GameView: View {
    @ObservedObject var viewModel = GameViewModel()
    @State var isLoading: Bool = true
    
    var body: some View {
        NavigationStack {
            VStack {
                Text("Unownmon")
                    .font(.largeTitle)
                    .bold()
                HStack {
                    NavigationLink(destination: SelectorView()) {
                        HStack {
                            Text("Make a Guess!")
                        }
                        .padding()
                        .frame(maxWidth: 150)
                        .background(Color(hex: 0xA6CAF5))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                    }
                }
            }
        }
    }
}

#Preview {
    GameView()
}
