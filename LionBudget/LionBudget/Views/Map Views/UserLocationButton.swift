//
//  UserLocationButton.swift
//  Campus III
//
//  Created by Yifan Lu on 4/6/23.
//

import SwiftUI
import CoreLocationUI

struct UserLocationButton: View {
    @EnvironmentObject var budgetManager : BudgetManager
    var body: some View {
        Button(action: {
            budgetManager.mapKitTrackingMode = .follow
            }) {
                Image(systemName: "location.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
        }
    }
}

struct UserLocationButton_Previews: PreviewProvider {
    static var previews: some View {
        UserLocationButton().environmentObject(BudgetManager())
    }
}
