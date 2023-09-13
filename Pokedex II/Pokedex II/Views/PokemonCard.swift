//
//  PokemonCard.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

struct PokemonCard: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    var pokemon : Pokemon
    
    var body: some View {
        ZStack {
            LinearGradient(pokemon: pokemon)
                .cornerRadius(25)
                .frame(width: 375, height: 500)
            VStack {
                Text(pokemon.name)
                    .fontWeight(.heavy)
                    .font(.system(size: 50))
                    .foregroundColor(.white)
                Image(pokemon.idString)
                    .resizable()
                    .frame(width: 325, height: 325)
                HStack {
                    if pokemon.captured! {
                        CapturedButton(pokemon: pokemon).disabled(true)
                            .scaleEffect(1.5)
                    }
                    else {
                        ReleasedButton(pokemon: pokemon).disabled(true)
                            .scaleEffect(1.5)
                    }
                    Text("#" + pokemon.idString)
                        .fontWeight(.heavy)
                        .font(.largeTitle)
                        .foregroundColor(.white)
                }
            }

        }
    }
}

struct PokemonCard_Previews: PreviewProvider {
    static var previews: some View {
        PokemonCard(pokemon: Pokemon.samplePokemon).environmentObject(PokedexManager())
    }
}
