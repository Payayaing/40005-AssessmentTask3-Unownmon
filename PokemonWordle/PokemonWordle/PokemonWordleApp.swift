//
//  PokemonWordleApp.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

@main
struct PokemonWordleApp: App {
    @StateObject var gameViewModel = GameViewModel()
    @StateObject var noteViewModel = NoteViewModel()
    
    var body: some Scene {
        WindowGroup {
            HomeView()
                .environmentObject(gameViewModel)
                .environmentObject(noteViewModel)
        }
    }
}
