//
//  Pokemon.swift
//  PokemonWordle
//
//  Created by Bella on 25/9/2025.
//

import SwiftUI

struct Pokemon: Codable, Identifiable {
    // Pokemon struct contains all relevant data and attributes needed for the application's functionality. PokemonData is defined in PokemonData.swift, which uses PokeAPI information and stores it such that the API does not need to be called continuously for the same Pokemon.
    let id: UUID
    let pokemonData: PokemonData
    
    init(pokemonData: PokemonData) {
        self.id = UUID()
        self.pokemonData = pokemonData
    }
    
    // PokeAPI returns Pokemon names with kebab-case formatting, this should be converted to a more readable formatting. In most cases, Pokemon names only need to be capitalised as well as convert the hyphon to a space; however, there are some names that have custom formatting. These instances are specified to ensure correctness in formatting for all Pokemon.
    static func format(name: String) -> String {
        let customFormat = [
            "nidoran-f": "Nidoran (F)",
            "nidoran-m": "Nidoran (M)",
            "farfetch-d": "Farfetch'd",
            "sirfetch-d": "Sirfetch'd",
            "ho-oh": "Ho-Oh",
            "mime-jr": "Mime Jr.",
            "mr-mime": "Mr. Mime",
            "mr-rime": "Mr. Rime",
            "porygon-z": "PorygonZ",
            "jangmo-o": "Jangmo-o",
            "hakamo-o": "Hakamo-o",
            "kommo-o": "Kommo-o",
            "type-null": "Type: Null",
            "wo-chien": "Wo-Chien",
            "chi-yu": "Chi-Yu",
            "chien-pao": "Chien-Pao",
            "ting-lu": "Ting-Lu"
        ]
        if let new = customFormat[name] {
            return new
        } else {
            return name.replacingOccurrences(of: "-", with:" ").capitalized
        }
    }
    
    func format() -> String {
        return Pokemon.format(name: self.pokemonData.name)
    }
    
    // Returning pokemonData attributes so that functions wanting this information can use this method instead of using pokemon.pokemonData.[attribute].
    func getGeneration() -> Int {
        return self.pokemonData.generation
    }
    
    // All Pokemon always have at least one type. When initialising Pokemon objects, if they only have one type, then a secondary type "None" will be added. Therefore, forcefully unwrapping this list to return the first and second type will not result in any issues and will result in stable behaviour.
    func getFirstType() -> String {
        return self.pokemonData.types.first!.format()
    }
    
    func getSecondType() -> String {
        return self.pokemonData.types.last!.format()
    }
    
    func getHeight() -> Double {
        return self.pokemonData.height
    }
    
    func getWeight() -> Double {
        return self.pokemonData.weight
    }
    
    // First is always the Pokemon being guessed, Second is always the correct Pokemon. Both Strings and Ints are being compared, so a template type T is used (which is assumed to be Comparable).
    func compare<T: Comparable>(first: T, second: T) -> Comparison {
        if first > second { // Guess value is higher than true value, so indicate to the user that they should guess something lower.
            return .lower
        } else if first < second {
            return .higher
        } else {
            return .equal
        }
    }
    
    // Compares all relevant attributes between guess and correct by using the compare() method on each attribute, returning a custom Comparison enum and storing in a dictionary structure. This is used to efficiently compare all attributes and display them in GameView.
    func comparePokemon(second: Pokemon) -> [String: Comparison] {
        var comparison: [String: Comparison] = [
            "generation": compare(first: self.getGeneration(), second: second.getGeneration()),
            "type1": compare(first: self.getFirstType(), second: second.getFirstType()),
            "type2": compare(first: self.getSecondType(), second: second.getSecondType()),
            "height": compare(first: self.getHeight(), second: second.getHeight()),
            "weight": compare(first: self.getWeight(), second: second.getWeight())
        ]
        
        // Types cannot be higher or lower than each other in the domain of Pokemon, so if the compare() method does not set them as equal, set them as wrong.
        if comparison["type1"] == .higher || comparison["type1"] == .lower {
            comparison["type1"] = .wrong
        }
        
        if comparison["type2"] == .higher || comparison["type2"] == .lower {
            comparison["type2"] = .wrong
        }
        
        // Since Pokemon have primary and secondary typings, and the comparison table only compares primary to primary and secondary to secondary, a wrong slot comparison should be provided to notify the user that the type itself is correct, but in the wrong slot.
        if self.getFirstType() == second.getSecondType() {
            comparison["type1"] = .wrongSlot
        } else if self.getSecondType() == second.getFirstType() {
            comparison["type2"] = .wrongSlot
        }
        
        return comparison
    }
}

// Custom enum that stores all possible comparisons between attributes, containing an image property which stores image link for each case.
enum Comparison {
    case higher, lower, equal, wrong, wrongSlot
    
    var image: String {
        switch self {
        case .higher: return "up"
        case .lower: return "down"
        case .equal: return "correct"
        case .wrong: return "wrong"
        case .wrongSlot: return "wrongpos"
        }
    }
}
