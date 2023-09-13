//
//  PokemonDetailsView.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

struct CapturedButton: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    var pokemon: Pokemon
    
    var body: some View {
        Button(action: {
            pokedexManager.releasePokemon(pokemon: pokemon)
            }) {
                Image("pokeball")
                    .resizable()
                    .frame(width: 30, height: 30)
                    .padding(.trailing, 10)
        }
    }
}

struct ReleasedButton: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    var pokemon: Pokemon
    
    var body: some View {
        Button(action: {
            pokedexManager.capturePokemon(pokemon: pokemon)
            }) {
                Circle()
                    .inset(by: 10)
                    .stroke(Color.black, lineWidth: 2)
                    .frame(width: 48, height: 48)
        }
    }
}

struct PokemonImage: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    var pokemon : Pokemon
    
    var body : some View {
        ZStack {
            LinearGradient(pokemon: pokemon)
                .cornerRadius(25)
                .frame(width: 375, height: 375)
            Image(pokemon.idString)
                .resizable()
                .frame(width: 325, height: 325)
            Text("#" + pokemon.idString)
                .bold()
                .font(.title)
                .foregroundColor(.white)
                .offset(x: 140, y: 160)
            if pokedexManager.model.pokemon[pokemon.id-1].captured! {
                CapturedButton(pokemon: pokemon)
                    .offset(x: -155, y: -160)
            }
            else {
                ReleasedButton(pokemon: pokemon)
                    .offset(x: -160, y: -160)
            }
        }
    }
}

struct HeightAndWeight: View {
    var pokemon : Pokemon
    
    var body : some View {
        HStack {
            Spacer()
            VStack {
                Text("Height")
                    .bold()
                    .font(.title2)
                Text(String(format: "%.2f", pokemon.height) + " m")
            }
            Spacer()
            VStack {
                Text("Weight")
                    .bold()
                    .font(.title2)
                Text(String(format: "%.1f", pokemon.weight) + " kg")
            }
            Spacer()
        }
    }
}

struct TypeView: View {
    var type : PokemonType
    
    var body : some View {
        Text(type.id)
            .padding([.top, .bottom], 10)
            .padding([.leading, .trailing], 15)
            .background(Color(pokemonType: type))
            .cornerRadius(15)
            .foregroundColor(.white)
            .font(.title3)
            .bold()
    }
}

struct Types: View {
    var pokemon : Pokemon
    
    var body : some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Types")
                    .bold()
                    .font(.title2)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(pokemon.types) { type in
                            TypeView(type: type)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct Weaknesses: View {
    var pokemon : Pokemon
    
    var body : some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Weaknesses")
                    .bold()
                    .font(.title2)
                ScrollView(.horizontal) {
                    HStack {
                        ForEach(pokemon.weaknesses) { type in
                            TypeView(type: type)
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct PreEvos: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    var pokemon : Pokemon
    
    var body : some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Previous Evolutions")
                    .bold()
                    .font(.title2)
                if pokemon.prev_evolution != nil {
                    HStack {
                        ForEach(pokemon.prev_evolution!, id: \.self) { preevo in
                            NavigationLink {
                                PokemonDetailsView(pokemon: pokedexManager.model.pokemon[preevo-1])
                            } label : {
                                PokemonCard(pokemon: pokedexManager.model.pokemon[preevo-1])
                                    .scaleEffect(0.25)
                                    .frame(width: 93.75, height: 125)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct NextEvos: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    var pokemon : Pokemon
    
    var body : some View {
        HStack {
            VStack(alignment: .leading) {
                Text("Next Evolutions")
                    .bold()
                    .font(.title2)
                if pokemon.next_evolution != nil {
                    HStack {
                        ForEach(pokemon.next_evolution!, id: \.self) { nextevo in
                            NavigationLink {
                                PokemonDetailsView(pokemon: pokedexManager.model.pokemon[nextevo-1])
                            } label : {
                                PokemonCard(pokemon: pokedexManager.model.pokemon[nextevo-1])
                                    .scaleEffect(0.25)
                                    .frame(width: 93.75, height: 125)
                            }
                        }
                    }
                }
            }
            Spacer()
        }
    }
}

struct PokemonDetailsView: View {
    var pokemon : Pokemon
    
    var body: some View {
        NavigationStack {
            ScrollView(.vertical) {
                VStack {
                    PokemonImage(pokemon: pokemon)
                        .padding([.top, .bottom], 10)
                    HeightAndWeight(pokemon: pokemon)
                        .padding([.top, .bottom], 10)
                    Types(pokemon: pokemon)
                        .padding([.top, .bottom], 10)
                    Weaknesses(pokemon: pokemon)
                        .padding([.top, .bottom], 10)
                    if pokemon.prev_evolution != nil {
                        PreEvos(pokemon: pokemon)
                            .padding([.top, .bottom], 10)
                    }
                    if pokemon.next_evolution != nil {
                        NextEvos(pokemon: pokemon)
                            .padding([.top, .bottom], 10)
                    }
                }
            }
            .padding([.leading, .trailing], 15)
            .navigationTitle(pokemon.name)
            .navigationBarTitleDisplayMode(.inline)
        }
    }
}

struct PokemonDetailsView_Previews: PreviewProvider {
    static var previews: some View {
        PokemonDetailsView(pokemon: Pokemon.samplePokemon).environmentObject(PokedexManager())
    }
}
