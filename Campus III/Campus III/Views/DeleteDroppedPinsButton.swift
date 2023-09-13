//
//  DeleteDroppedPinsButton.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

struct DeleteDroppedPinsButton: View {
    @EnvironmentObject var campusManager: CampusManager
    var body: some View {
        Button(action: {
            campusManager.droppedPins.removeAll()
            }) {
                Image(systemName: "pin.slash")
                    .resizable()
                    .frame(width: 20, height: 20)
        }
            .disabled(campusManager.droppedPins.count == 0)
    }
}

struct DeleteDroppedPinsButton_Previews: PreviewProvider {
    static var previews: some View {
        DeleteDroppedPinsButton()
    }
}
