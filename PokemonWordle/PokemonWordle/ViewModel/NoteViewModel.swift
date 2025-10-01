//
//  NoteViewModel.swift
//  PokemonWordle
//
//  Created by Bella on 1/10/2025.
//

import SwiftUI
import Combine

class NoteViewModel: ObservableObject {
    @Published var content: String = ""
    
    init() {
        loadNotes()
    }
    
    func loadNotes() {
        self.content = UserDefaults.standard.string(forKey: "content") ?? ""
    }
    
    func saveNotes() {
        UserDefaults.standard.set(self.content, forKey: "content")
    }
}
