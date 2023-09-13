//
//  ContentView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI
import ConfettiSwiftUI

struct ContentView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        VStack {
            TitleView()
            Spacer()
            WordsFoundView()
            VStack {
                Spacer()
                ScoreView()
                Spacer()
                Divider()
                LettersView()
                Divider()
                Spacer()
            }
            VStack {
                ButtonsView()
                Spacer()
                ActionButtonsView()
                SettingsButtonsView()
                Spacer()
            }
        }
        .sheet(isPresented: $lionSpellManager.showPreferences) {
            PreferencesView()
        }
        .sheet(isPresented: $lionSpellManager.showHints) {
            HintsView()
        }
        .alert(isPresented: $lionSpellManager.alerting) {
                    Alert(
                        title: Text("Congratulations!"),
                        message: Text("You found all possible words!")
                    )
                }
        .confettiCannon(counter: $lionSpellManager.confetti, num: 100, radius: 500)
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(LionSpellManager())
    }
}

