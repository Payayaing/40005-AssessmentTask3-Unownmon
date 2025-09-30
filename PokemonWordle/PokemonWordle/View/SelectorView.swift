//
//  SelectorView.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

struct SelectorView: View {
    @State var guess: String = ""
    @State var viewModel = SelectorViewModel()
    @ObservedObject var gameViewModel: GameViewModel
    @State var isLoading: Bool = true
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Search for Pokemon")
                .font(.largeTitle)
                .bold()
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $guess)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 10)
                    .onChange(of: guess) { old, new in
                        viewModel.filterNames(with: new)
                    }
                    .autocorrectionDisabled(true)
            }
            
            if isLoading {
                VStack {
                    Spacer()
                    Text("Loading...")
                    Spacer()
                }
            } else {
                List(viewModel.filteredNames, id: \.self) { name in
                    Button(action: {
                        path.append(Screen.pokemonDetail(name: name))
                    }) {
                        HStack {
                            AsyncImage(url: getURL(name: name))
                            Text(Pokemon.format(name: name))
                                    .font(.headline)
                        }
                    }
                }
                .scrollContentBackground(.hidden)
            }
        }
        .padding()
        .onAppear(perform: {
            Task {
                if let data = await viewModel.fetchNames() {
                    viewModel.loadNames(names: data)
                }
                isLoading = false
            }
        })
    }
    
    private func getURL(name: String) -> URL? {
        guard let index = viewModel.pokemonNames.firstIndex(of: name) else {
            return nil
            }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index+1).png")
    }
}
