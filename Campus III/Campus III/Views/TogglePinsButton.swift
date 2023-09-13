//
//  TogglePinsButton.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

struct TogglePinsButton: View {
    @EnvironmentObject var campusManager: CampusManager
    var body: some View {
        Button(action: {
            campusManager.showPlottedBuildings.toggle()
            }) {
                Image(systemName: campusManager.showPlottedBuildings ? "mappin.slash.circle" : "mappin.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
        }
    }
}

struct TogglePinsButton_Previews: PreviewProvider {
    static var previews: some View {
        TogglePinsButton().environmentObject(CampusManager())
    }
}
