//
//  UserLocationButton.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI
import CoreLocationUI

struct UserLocationButton: View {
    @EnvironmentObject var campusManager : CampusManager
    var body: some View {
        Button(action: {
            campusManager.mapKitTrackingMode = .follow
            }) {
                Image(systemName: "location.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
        }
    }
}

struct UserLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        UserLocationButton().environmentObject(CampusManager())
    }
}
