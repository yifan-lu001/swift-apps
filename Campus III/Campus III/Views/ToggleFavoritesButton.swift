//
//  ToggleFavoritesButton.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

struct ToggleFavoritesButton: View {
    @EnvironmentObject var campusManager: CampusManager
    var body: some View {
        Button(action: {
            campusManager.showFavorites.toggle()
            }) {
                Image(systemName: campusManager.showFavorites ? "heart.slash.circle" : "heart.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
        }
    }
}

struct ToggleFavoritesButton_Previews: PreviewProvider {
    static var previews: some View {
        ToggleFavoritesButton()
    }
}

