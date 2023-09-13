//
//  LinearGradient+Pokemon.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

extension LinearGradient {
    init(pokemon: Pokemon) {
        self = LinearGradient(gradient: Gradient(colors: pokemon.pokemonColors), startPoint: .topLeading, endPoint: .bottomTrailing)
    }
}
