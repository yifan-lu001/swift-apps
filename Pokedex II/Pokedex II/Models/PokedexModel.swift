//
//  PokedexModel.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import Foundation
import SwiftUI

// Struct for decoding Pokémon from the JSON file
struct Pokemon : Codable, Identifiable, Comparable, Hashable {
    static func < (lhs: Pokemon, rhs: Pokemon) -> Bool {
        return lhs.id < rhs.id
    }
    
    let id : Int
    let name : String
    let types : [PokemonType]
    let height : Double
    let weight : Double
    let weaknesses : [PokemonType]
    let prev_evolution : [Int]?
    let next_evolution : [Int]?
    var captured : Bool?
    
    static var allPokemon : [Pokemon] = Bundle.main.decode(file: "pokedex.json")
    static var samplePokemon : Pokemon = Pokemon(id: 1, name: "Bulbasaur", types: [.grass, .poison], height: 0.71, weight: 6.9, weaknesses: [.fire, .ice, .flying, .psychic], prev_evolution: nil, next_evolution: [2, 3], captured: false)
}

// Computed properties for Pokemon
extension Pokemon {
    var idString : String { String(format: "%03d", self.id) }
    var pokemonColors : [Color] { types.count == 2 ? [Color(pokemonType: types[0]), Color(pokemonType: types[1])] : [Color(pokemonType: types[0])] }
}

// Bundle extension to decode JSON file
extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) in the project.")
        }
        
        return loadedData
    }
    
    func decodeWithString<T: Decodable>(contents: String) -> T {
        let data = contents.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode the String in the project.")
        }
        
        return loadedData
    }
    
}

struct PokedexModel {
    var pokemon : [Pokemon]
    
    init() {
        func getData() -> [Pokemon] {
            var capturedPokemon : [Pokemon] = []
            let fm = FileManager.default
            let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
            let url = urls.first
            var fileURL = url!.appendingPathComponent("captured")
            fileURL = fileURL.appendingPathExtension("json")
            do {
                try capturedPokemon = Bundle.main.decodeWithString(contents: String(contentsOf: fileURL))
            }
            catch {
                // print(error)
            }
            return capturedPokemon
        }
        func updatePokemon() -> [Pokemon] {
            let data = getData()
            if data.count != 151 {
                var r : [Pokemon] = []
                for p in Pokemon.allPokemon {
                    var poke : Pokemon = p
                    poke.captured = false
                    r.append(poke)
                }
                return r
            }
            return data
        }
        pokemon = updatePokemon()
    }
}
