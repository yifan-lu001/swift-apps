//
//  ScoreView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct ScoreView: View {
    @EnvironmentObject var lionSpellManager: LionSpellManager
    var body: some View {
        let currScore = lionSpellManager.score
        Text("Score: \(currScore)")
            .font(.largeTitle)
            .fontWeight(.heavy)
            .multilineTextAlignment(.center)
    }
}
