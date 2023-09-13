//
//  WordsFoundView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct WordsFoundView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        let len = lionSpellManager.getWordsFoundLen()
        let wordsFound = lionSpellManager.wordsFound
        VStack(spacing: 10) {
            // Distinguish between singular and plural
            if len == 1 {
                Text("\(len) Word Found")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            else {
                Text("\(len) Words Found")
                    .font(.title2)
                    .fontWeight(.bold)
            }
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 10) {
                    ForEach(wordsFound, id: \.self) { word in
                        Text(word)
                            .font(.title)
                            .fontWeight(.bold)
                            .foregroundColor(Color.white)
                    }
                }
                .padding(10)
            }
            .background(.blue)
        }
    }
}

struct WordsFoundView_Previews: PreviewProvider {
    static var previews: some View {
        WordsFoundView().environmentObject(LionSpellManager())
    }
}
