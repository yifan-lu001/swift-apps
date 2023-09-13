//
//  SettingsButtonsView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct SettingsButton: View {
    let buttonSymbol: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Image(systemName: buttonSymbol)
                .foregroundColor(Color.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(.blue, lineWidth: 2)
                        .frame(width: 45, height: 45)
                )
        }
        .padding()
    }
}

struct SettingsButtonsView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        HStack {
            SettingsButton(buttonSymbol: "gobackward", action: lionSpellManager.pressNewGameButton)
            Spacer()
            SettingsButton(buttonSymbol: "questionmark", action: lionSpellManager.pressHintsButton)
            Spacer()
            SettingsButton(buttonSymbol: "gear", action: lionSpellManager.pressPreferencesButton)
        }
        .padding()
    }
}

struct SettingsButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        SettingsButtonsView().environmentObject(LionSpellManager())
    }
}

