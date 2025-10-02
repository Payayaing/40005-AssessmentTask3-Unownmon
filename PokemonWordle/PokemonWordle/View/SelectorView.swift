//
//  SelectorView.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

struct SelectorView: View {
    @StateObject var viewModel = SelectorViewModel()
    @State var isLoading: Bool = true
    @Binding var path: NavigationPath
    
    var body: some View {
        VStack {
            Text("Search for Pokemon")
                .font(.largeTitle)
                .bold()
            
            HStack {
                Image(systemName: "magnifyingglass")
                TextField("Search", text: $viewModel.search)
                    .textFieldStyle(.roundedBorder)
                    .padding(.horizontal, 10)
                    .autocorrectionDisabled(true)
                    .onChange(of: viewModel.search) {
                        viewModel.filter()
                    }
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
                        // The index should always be a valid number. However, in the event that this function does not work as intended, the application should not crash, so show a Bulbasaur instead.
                        path.append(Screen.pokemonDetail(index: viewModel.getApiNumber(name: name) ?? 1))
                    }) {
                        HStack {
                            AsyncImage(url: getURL(name: name))
                            Text(Pokemon.format(name: name))
                                    .font(.headline)
                                    .foregroundColor(.black)
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
        guard let index = viewModel.getApiNumber(name: name) else {
            return nil
            }
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index).png")
    }
}
