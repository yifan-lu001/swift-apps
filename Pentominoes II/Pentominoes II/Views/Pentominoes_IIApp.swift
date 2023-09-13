//
//  Pentominoes_IIApp.swift
//  Pentominoes II
//
//  Created by Yifan Lu on 2/9/23.
//

import SwiftUI

@main
struct Pentominoes_IIApp: App {
    @StateObject var pentominoesManager = PentominoesManager()
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(pentominoesManager)
        }
    }
}
