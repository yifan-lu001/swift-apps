//
//  LettersView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct LettersView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        let letters = lionSpellManager.guessedLetters
        HStack (spacing: 0){
            ForEach(letters, id: \.self) { letter in
                Text(letter)
                    .font(.title)
                    .fontWeight(.heavy)
            }
        }
    }
}

struct LettersView_Previews: PreviewProvider {
    static var previews: some View {
        LettersView().environmentObject(LionSpellManager())
    }
}
