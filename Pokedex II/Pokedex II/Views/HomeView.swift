//
//  HomeView.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

struct GetListView: View {
    @EnvironmentObject var pokedexManager : PokedexManager
    var body: some View {
        NavigationLink {
            PokemonRowView()
        } label: {
            Image(systemName: "list.bullet")
        }
    }
}

struct CapturedPokemon: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    
    var body: some View {
        let pot = pokedexManager.model.pokemon.filter { $0.captured! }
        ScrollView(.horizontal) {
            HStack {
                ForEach(pot) { pokemon in
                    NavigationLink {
                        PokemonDetailsView(pokemon: pokedexManager.model.pokemon[pokemon.id-1])
                    } label : {
                        PokemonCard(pokemon: pokemon)
                            .scaleEffect(0.25)
                            .frame(width: 93.75, height: 125)
                    }
                }
            }
        }
    }
}

struct PokemonCardsOfType: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    var pType: PokemonType
    
    var body: some View {
        let pot = pokedexManager.model.pokemon.filter { $0.types.contains(pType) }
        ScrollView(.horizontal) {
            HStack {
                ForEach(pot) { pokemon in
                    NavigationLink {
                        PokemonDetailsView(pokemon: pokemon)
                    } label : {
                        PokemonCard(pokemon: pokemon)
                            .scaleEffect(0.25)
                            .frame(width: 93.75, height: 125)
                    }
                }
            }
        }
    }
}

struct HomeView: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    
    let getListItem = ToolbarItem(placement: .navigationBarTrailing) {
        GetListView()
    }
    
    var body: some View {
        NavigationStack {
            List {
                let pot = pokedexManager.model.pokemon.filter { $0.captured! }
                if pot.count > 0 {
                    Section(content: {
                        CapturedPokemon()
                    }, header: {
                        HStack {
                            Image("pokeball")
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text("CAPTURED")
                                .bold()
                            Image("pokeball")
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    })
                }
                ForEach(PokemonType.allCases) { pType in
                    Section(content: {
                        PokemonCardsOfType(pType: pType)
                    }, header: {
                        HStack {
                            Image(pType.id.lowercased())
                                .resizable()
                                .frame(width: 20, height: 20)
                            Text(pType.id)
                                .foregroundColor(Color(pokemonType: pType))
                                .bold()
                            Image(pType.id.lowercased())
                                .resizable()
                                .frame(width: 20, height: 20)
                        }
                    })
                }
                
            }
            .navigationTitle("Home")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                getListItem
            }
        }
    }
}

struct HomeView_Previews: PreviewProvider {
    static var previews: some View {
        HomeView().environmentObject(PokedexManager())
    }
}
