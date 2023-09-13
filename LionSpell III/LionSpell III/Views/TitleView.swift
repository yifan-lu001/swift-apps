//
//  TitleView.swift
//  LionSpell III
//
//  Created by Yifan Lu on 1/25/23.
//

import SwiftUI

struct TitleView: View {
    var body: some View {
        Image("LIONSPELL")
            .resizable()
            .aspectRatio(contentMode:.fit)
            .padding()
    }
}

struct TitleView_Previews: PreviewProvider {
    static var previews: some View {
        TitleView()
    }
}
