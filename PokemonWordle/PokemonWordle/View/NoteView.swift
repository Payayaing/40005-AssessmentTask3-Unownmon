//
//  NoteView.swift
//  PokemonWordle
//
//  Created by Bella on 1/10/2025.
//
import SwiftUI

struct NoteView: View {
    // Allows for user note taking mid-game, allowing for self-sufficiency without needing a piece of paper to write gathered clues from. This note can be accessed from both GameView and PokemonDetailView.
    @Environment(\.dismiss) var dismiss
    @EnvironmentObject var viewModel: NoteViewModel
    
    var body: some View {
        VStack {
            Text("Notes")
                .font(.largeTitle)
                .bold()
            Text("Tap on the sheet to type your notes! Save your notes or clear them with the buttons at the bottom.")
                .multilineTextAlignment(.center)
            Divider()
            
            TextEditor(text: $viewModel.content)
                .frame(maxWidth: .infinity)
                .autocorrectionDisabled()
            
            HStack {
                Button(action: {
                    // Triggers UserDefault saving for notes and closes the sheet.
                    viewModel.saveNotes()
                    dismiss()
                }) {
                    Text("Save")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0x51F074))
                        .foregroundColor(.black)
                        .cornerRadius(12)
                }
                
                Button(action: {
                    // Clears note content and saves the empty note to UserDefaults.
                    viewModel.content = ""
                    viewModel.saveNotes()
                }, label: {
                    Text("Clear Notes")
                        .font(.headline)
                        .padding()
                        .frame(maxWidth: .infinity)
                        .background(Color(hex: 0xED4040))
                        .foregroundColor(.white)
                        .cornerRadius(12)
                })
            }
        }
        .padding()
    }
}
