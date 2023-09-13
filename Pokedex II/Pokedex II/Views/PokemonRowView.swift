//
//  PokemonRowView.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

struct PokemonListFiltered: View {
    @EnvironmentObject var pokedexManager : PokedexManager
    var filteredPokemon: [Pokemon] {
        if (pokedexManager.filter == nil) {
            return pokedexManager.model.pokemon
        }
        else {
            return pokedexManager.model.pokemon.filter { $0.types.contains(pokedexManager.filter!)
            }
        }
    }
    
    var body: some View {
        List {
            ForEach(filteredPokemon) { pokemon in
                NavigationLink {
                    PokemonDetailsView(pokemon: pokemon)
                } label : {
                    PokemonRow(pokemon: pokemon)
                }
            }
        }
    }
}

struct PokemonRowView: View {
    @EnvironmentObject var pokedexManager : PokedexManager
    
    let filterByTypeItem = ToolbarItem(placement: .navigationBarTrailing) {
        FilterByTypeMenu()
    }
    
    var body: some View {
        NavigationStack {
            PokemonListFiltered()
                .toolbar {
                    filterByTypeItem
                }
            .navigationTitle("Pokédex List")
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PokemonRowView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRowView().environmentObject(PokedexManager())
    }
}
