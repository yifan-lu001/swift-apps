//
//  GetDistanceMenu.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

struct GetDistanceButton: View {
    @EnvironmentObject var campusManager : CampusManager
    let action : (Building) -> Void
    let building : Building
    var body: some View {
        Button(action: {
            action(building)
            campusManager.calculateHeading(building: building)
            }) {
                Text(building.name)
        }
    }
}

struct GetDistanceMenu: View {
    @EnvironmentObject var campusManager : CampusManager
    var body: some View {
        Menu {
            ForEach(campusManager.campusModel.buildings) { building in
                GetDistanceButton(action: campusManager.getDistanceTo, building: building)
            }
        } label: {
            Image(systemName: "figure.walk.circle")
                .resizable()
                .frame(width: 25, height: 25)
        }
    }
}

struct GetDistanceMenu_Previews: PreviewProvider {
    static var previews: some View {
        GetDistanceMenu().environmentObject(CampusManager())
    }
}
