//
//  InstructionsView.swift
//  PokemonWordle
//
//  Created by Bella on 1/10/2025.
//
import SwiftUI

struct InfoView: View {
    @Environment(\.dismiss) var dismiss
    
    var body: some View {
        VStack(alignment: .center) {
            Spacer()
            Text("Info")
                .font(.largeTitle)
                .bold()
            Text("Hi! :> Unownmon is a Pokemon wordle-like, where you guess the hidden Pokemon using clues from your guesses.\n")
                .multilineTextAlignment(.center)
            Text("You have 6 attempts to figure out the hidden Pokemon! Good luck :>")
                .multilineTextAlignment(.center)
            
            HStack() {
                VStack {
                    Image("correct")
                    Text("Correct")
                        .font(.caption)
                }
                VStack {
                    Image("wrong")
                    Text("Incorrect")
                        .font(.caption)
                }
                VStack {
                    Image("wrongpos")
                    Text("Wrong Slot")
                        .font(.caption)
                }
                VStack {
                    Image("up")
                    Text("Higher")
                        .font(.caption)
                }
                VStack {
                    Image("down")
                    Text("Lower")
                        .font(.caption)
                }
            }
            .padding()
            
            Text("Shoutout to Fireblend, who made the Squirdle web game, which is the inspiration for this application.\n")
                .multilineTextAlignment(.center)
            Text("The image assets for comparison indicators are from their GitHub, so please check them out at [Squirdle](github.com/Fireblend/Squirdle).")
                .multilineTextAlignment(.center)
            
            Spacer()
            
            Button(action: {
                dismiss()
            }) {
                Text("OK")
                    .font(.headline)
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(hex: 0x51F074))
                    .foregroundColor(.black)
                    .cornerRadius(12)
            }
        }
        .padding(15)
    }
}
