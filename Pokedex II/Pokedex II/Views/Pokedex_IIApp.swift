//
//  Pokedex_IIApp.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

@main
struct Pokedex_IIApp: App {
    @StateObject var pokedexManager = PokedexManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(pokedexManager)
        }
    }
}
