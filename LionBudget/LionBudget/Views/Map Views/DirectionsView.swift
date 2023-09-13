//
//  DirectionsView.swift
//  Campus III
//
//  Created by Yifan Lu on 4/6/23.
//

import SwiftUI

struct DirectionsDoneButton: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var body: some View {
        Button(action: {
            budgetManager.showDirections = false
            }) {
                Text("Done")
                    .foregroundColor(.blue)
                    .padding([.bottom,.top, .trailing], 20)
        }
    }
}

struct DirectionsView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var body: some View {
        VStack {
            HStack {
                Text("Directions")
                    .padding()
                    .bold()
                Spacer()
                DirectionsDoneButton()
            }
            Divider().background(Color.blue)
            List(0..<budgetManager.directionsTo.count, id: \.self) { i in
                Text(budgetManager.directionsTo[i])
                    .padding(5)
            }
        }
    }
}

struct DirectionsView_Previews: PreviewProvider {
    static var previews: some View {
        DirectionsView().environmentObject(BudgetManager())
    }
}
