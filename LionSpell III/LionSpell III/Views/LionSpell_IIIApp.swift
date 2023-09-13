//
//  LionSpell_IIIApp.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

@main
struct LionSpell_IIIApp: App {
    @StateObject var lionSpellManager = LionSpellManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(lionSpellManager)
        }
    }
}
