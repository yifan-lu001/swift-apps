//
//  MapTypeButton.swift
//  Campus III
//
//  Created by Yifan Lu on 4/6/23.
//

import SwiftUI
import CoreLocationUI

struct MapTypeButton: View {
    @EnvironmentObject var budgetManager : BudgetManager
    var body: some View {
        let mapTypes: [String] = ["Standard", "Hybrid", "Imagery"]
        Menu {
            ForEach(mapTypes, id: \.self) {mapType in
                Button(mapType) {
                    if mapType == "Standard" {
                        budgetManager.mapType = .standard
                    }
                    else if mapType == "Hybrid" {
                        budgetManager.mapType = .hybrid
                    }
                    else {
                        budgetManager.mapType = .satellite
                    }
                }
            }
        } label: {
            Image(systemName: "map.circle")
                .resizable()
                .frame(width: 25, height: 25)
        }
    }
}

struct MapTypeButton_Previews: PreviewProvider {
    static var previews: some View {
        MapTypeButton().environmentObject(BudgetManager())
    }
}
