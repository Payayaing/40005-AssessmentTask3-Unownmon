//
//  NoteViewModel.swift
//  PokemonWordle
//
//  Created by Bella on 1/10/2025.
//

import SwiftUI
import Combine

class NoteViewModel: ObservableObject {
    // This view model controls the note-taking content, storing its value, as well as handling UserDefault loading and saving.
    @Published var content: String = ""
    
    init() {
        loadNotes()
    }
    
    func loadNotes() {
        // In the event that there is an error obtaining UserDefault data, replace the content with an empty string instead of causing an error.
        self.content = UserDefaults.standard.string(forKey: "content") ?? ""
    }
    
    func saveNotes() {
        UserDefaults.standard.set(self.content, forKey: "content")
    }
}
