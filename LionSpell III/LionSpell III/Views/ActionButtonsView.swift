//
//  ActionButtonsView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct ActionButton: View {
    let buttonText: String
    var action: () -> Void
    var body: some View {
        Button(action: action) {
            Text(buttonText)
                .foregroundColor(Color.blue)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(.blue, lineWidth: 2)
                        .frame(width: 90, height: 45)
                )
        }
        .padding()
    }
}

struct ActionButtonsView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        HStack {
            ActionButton(buttonText: "Delete", action: lionSpellManager.pressDeleteButton)
                .disabled(lionSpellManager.guessedLetters == [" "])
                .opacity(lionSpellManager.guessedLetters == [" "] ? 0.6 : 1)
            Spacer()
            ActionButton(buttonText: "Enter", action: lionSpellManager.pressSubmitButton)
                .disabled(!lionSpellManager.canSubmit)
                .opacity(!lionSpellManager.canSubmit ? 0.6 : 1)
        }
        .padding()
    }
}

struct ActionButtonsView_Previews: PreviewProvider {
    static var previews: some View {
        ActionButtonsView().environmentObject(LionSpellManager())
    }
}
