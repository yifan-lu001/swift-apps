//
//  PokemonRow.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

struct PokemonRow: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    var pokemon : Pokemon
    
    var body: some View {
        HStack {
            Text(pokemon.idString)
                .foregroundColor(Color(red: 107/256, green: 107/256, blue: 107/256))
                //.padding(.leading, 20)
            Text(pokemon.name)
                .bold()
            Spacer()
            if pokedexManager.model.pokemon[pokemon.id-1].captured! {
                Image("pokeball")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 10)
            }
            else {
                Circle()
                    .inset(by: 10)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 48, height: 48)
            }
            ZStack {
                LinearGradient(pokemon: pokemon)
                    .frame(width: 90, height: 90)
                    .cornerRadius(15)
                Image(pokemon.idString)
                    .resizable()
                    .frame(width: 80, height: 80)
            }
            //.padding(.trailing, 20)
        }
    }
}

struct PokemonRow_Previews: PreviewProvider {
    static var previews: some View {
        PokemonRow(pokemon: Pokemon.samplePokemon).environmentObject(PokedexManager())
    }
}
