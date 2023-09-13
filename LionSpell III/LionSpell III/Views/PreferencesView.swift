//
//  PreferencesView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct DoneButton: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        Button(action: {
            lionSpellManager.showPreferences = false
            }) {
                Text("Done")
                    .foregroundColor(.blue)
                    .padding([.bottom,.top, .trailing], 20)
        }
    }
}

struct PreferencesView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        VStack {
            HStack {
                Spacer()
                DoneButton()
            }
            Form {
                Section(header: Text("DIFFICULTY").foregroundColor(.blue)) {
                    Picker("Number of Letters", selection: $lionSpellManager.gamePreferences.probSize) {
                            Text("5").tag(ProblemSize.easy)
                            Text("6").tag(ProblemSize.medium)
                            Text("7").tag(ProblemSize.hard)
                    }
                    .pickerStyle(.segmented)
                }
                Section(header: Text("LANGUAGE").foregroundColor(.blue)) {
                    Picker("Language", selection: $lionSpellManager.gamePreferences.lang) {
                        ForEach(Language.allCases) { lang in
                            Text(lang.rawValue.capitalized)
                        }
                    }
                    .pickerStyle(.segmented)
                }
            }
        }
        .pickerStyle(.segmented)
        .background(Color(red: 0.9569, green: 0.9451, blue: 0.97))
    }
}

struct PreferencesView_Previews: PreviewProvider {
    static var previews: some View {
        PreferencesView().environmentObject(LionSpellManager())
    }
}
