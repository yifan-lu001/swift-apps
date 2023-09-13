//
//  HintsView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct HintsDoneButton: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        Button(action: {
            lionSpellManager.showHints = false
            }) {
                Text("Done")
                    .foregroundColor(.blue)
                    .padding([.bottom,.top, .trailing], 20)
        }
    }
}

struct ListWords: View {
    let columns = [GridItem(.flexible()), GridItem(.flexible())]
    let words: [String]
    var body: some View {
        VStack {
            Text("Possible Words")
                .underline()
                .bold()
                .font(.title)
            ScrollView {
                LazyVGrid(columns: columns) {
                    ForEach(words, id: \.self) { word in
                        Text(word)
                    }
                }
            }
        }
    }
}

struct HintsView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        NavigationView {
            VStack {
                HStack {
                    Spacer()
                    HintsDoneButton()
                }
                Form {
                    let possibleWords = lionSpellManager.getWords()
                    // Summary section
                    Section(header: Text("Summary").foregroundColor(.blue)) {
                        NavigationLink {
                            ListWords(words: possibleWords)
                        } label: {
                            Text("Total number of words: \(possibleWords.count)")
                        }
                        Text("Total possible points: \(lionSpellManager.getPoints(words: possibleWords))")
                        let listPangrams = lionSpellManager.getPangrams(words: possibleWords)
                        NavigationLink {
                            ListWords(words: listPangrams)
                        } label: {
                            Text("Number of Pangrams: \(listPangrams.count)")
                        }
                    }
                    
                    // Words of length section
                    let p = lionSpellManager.getPossibleWordLengths(words: possibleWords)
                    ForEach(p, id: \.self) { num in
                        Section(header: Text("Words of Length \(num)").foregroundColor(.blue)) {
                            ForEach(lionSpellManager.scramble.letters, id: \.self) { letter in
                                let wol = lionSpellManager.getWordsOfLength(words: possibleWords, len: num, start: letter)
                                if wol.count != 0 {
                                    NavigationLink {
                                        ListWords(words: wol)
                                    } label: {
                                        Text("\(letter): \(wol.count)")
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .pickerStyle(.segmented)
            .background(Color(red: 0.9569, green: 0.9451, blue: 0.97))
        }
        }
}

struct HintsView_Previews: PreviewProvider {
    static var previews: some View {
        HintsView().environmentObject(LionSpellManager())
    }
}
