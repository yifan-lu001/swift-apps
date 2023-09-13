//
//  ContentView.swift
//  Pokedex II
//
//  Created by Yifan Lu on 3/20/23.
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var pokedexManager: PokedexManager
    @Environment(\.scenePhase) var scenePhase
    
    var body: some View {
        HomeView()
            .onChange(of: scenePhase) { currentPhase in
                if currentPhase == .inactive {
                    pokedexManager.encodeToFile()
                }
            }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(PokedexManager())
    }
}
