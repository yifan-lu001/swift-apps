//
//  PokedexManager.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import Foundation

class PokedexManager : ObservableObject {
    // The Model
    @Published var model : PokedexModel = PokedexModel()
    
    // Filter for Pokémon list
    @Published var filter : PokemonType?
    
    // Removes a Pokémon from the captured list
    func releasePokemon(pokemon: Pokemon) {
        model.pokemon[pokemon.id-1].captured = false
    }
    
    // Adds a Pokémon to the captured list
    func capturePokemon(pokemon: Pokemon) {
        model.pokemon[pokemon.id-1].captured = true
    }
    
    // Encodes to file
    func encodeToFile() {
        // Encode to file
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(model.pokemon)
            let writtenString = String(data: data, encoding: .utf8)!
            let fm = FileManager.default
            let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
            let url = urls.first
            var fileURL = url!.appendingPathComponent("captured")
            fileURL = fileURL.appendingPathExtension("json")
            try writtenString.write(to: fileURL, atomically: true, encoding: .utf8)
        }
        catch {
            // print(error)
        }
    }
}
