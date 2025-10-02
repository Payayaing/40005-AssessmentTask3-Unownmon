//
//  SelectorView.swift
//  PokemonWordle
//
//  Created by Bella on 27/9/2025.
//

import SwiftUI
import Combine

struct SelectorView: View {
    // View which displays a full list of 1025 Pokemon that the user can choose from to make their guess. They are able to filter the list using a TextField to search for specific Pokemon, or can scroll through the list manually. They can then tap on a Pokemon to obtained detailed information.
    @StateObject var viewModel = SelectorViewModel()
    @State var isLoading: Bool = true
    @State var showAlert: Bool = false
    @Binding var path: NavigationPath
    @Environment(\.dismiss) var dismiss
    
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
                        // Live list filtering by filtering the list whenever the search query changes.
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
                        // The index should always be a valid number. However, in the event that this function does not work as intended, the application should not crash, so show a Bulbasaur instead. This shows the selected Pokemon with their detailed stats on a succeeding view.
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
                // Upon view appearing, the application fetches a list of Pokemon names. In the event that this does not work, then trigger an alert to communicate this to the user and provide instructions as to what they should do.
                if let data = await viewModel.fetchNames() {
                    viewModel.loadNames(names: data)
                } else {
                    self.showAlert = true
                }
                isLoading = false
            }
        })
        .alert("An Error Occurred", isPresented: $showAlert) {
            Button("OK", role: .cancel) {
                dismiss()
            }
        } message: {
            Text("An error occurred while retrieving the Pokemon list. Please wait a few seconds and try again :>")
        }
    }
    
    // Since the full list obtains strings and the sprite requires an index, this converts the name to the corresponding index and returns the relevant link. If somehow an invalid Pokemon is accessed, this should not crash the application.
    private func getURL(name: String) -> URL? {
        guard let index = viewModel.getApiNumber(name: name) else {
            return nil
        }
        // The PokeAPI sprite responses always use this GitHub link. Thus, we can get the image directly from this link instead of having to query the API.
        return URL(string: "https://raw.githubusercontent.com/PokeAPI/sprites/master/sprites/pokemon/\(index).png")
    }
}
