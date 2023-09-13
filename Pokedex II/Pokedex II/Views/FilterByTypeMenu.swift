//
//  FilterByTypeMenu.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

struct FilterByTypeMenu: View {
    @EnvironmentObject var pokedexManager : PokedexManager
    
    var body: some View {
        Picker("Filter", selection: $pokedexManager.filter) {
            Text("All").tag(nil as PokemonType?)
            ForEach(PokemonType.allCases, id: \.self) {
                Text($0.rawValue)
                    .tag($0 as PokemonType?)
            }
        }
    }
}

struct FilterByTypeMenu_Previews: PreviewProvider {
    static var previews: some View {
        FilterByTypeMenu().environmentObject(PokedexManager())
    }
}
