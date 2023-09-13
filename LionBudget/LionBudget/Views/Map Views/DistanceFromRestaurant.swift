//
//  DistanceFromBuildingView.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI

struct HeadingArrow: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var body: some View {
        
        Image(systemName: "arrow.up")
            .resizable()
            .frame(width: 25, height: 25)
            .rotationEffect(Angle(radians: budgetManager.selectedRestaurantHeading))
            .foregroundColor(.white)
    }
}

struct XButton: View {
    @EnvironmentObject var budgetManager : BudgetManager
    var body: some View {
        Button(action: {
            budgetManager.removeBottomBar()
            }) {
                Image(systemName: "xmark.circle")
                    .resizable()
                    .frame(width: 25, height: 25)
                    .foregroundColor(.white)
        }
    }
}

struct ShowDirectionsButton: View {
    @EnvironmentObject var budgetManager : BudgetManager
    var body: some View {
        Button(action: {
            budgetManager.showDirections = true
            }) {
                Text("Show Directions")
                    .padding(5)
                    .foregroundColor(.white)
                    .background(.blue)
                    .cornerRadius(5)
        }
    }
}

struct DistanceFromRestaurant: View {
    @EnvironmentObject var budgetManager : BudgetManager
    var body: some View {
        ZStack {
            RoundedRectangle(cornerSize: CGSize(width: 10, height: 10))
                .opacity(budgetManager.selectedRestaurantDistance == "" ? 0 : 0.5)
            VStack {
                HeadingArrow()
                    .padding(.top, 10)
                Text("Traveling to \(budgetManager.selectedRestaurant.name!):")
                    .bold()
                    .foregroundColor(.white)
                    .padding([.leading, .trailing], 10)
                if budgetManager.driving {
                    Text("\(budgetManager.selectedRestaurantDistance) (~$\(budgetManager.getPrice()) gas)")
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 10)
                }
                else {
                    Text(budgetManager.selectedRestaurantDistance)
                        .foregroundColor(.white)
                        .padding([.leading, .trailing], 10)
                }
                ShowDirectionsButton()
                    .padding([.bottom, .leading, .trailing], 10)
            }
            .opacity(budgetManager.selectedRestaurantDistance == "" ? 0 : 1)
            XButton()
                .opacity(budgetManager.selectedRestaurantDistance == "" ? 0 : 1)
                .offset(x: 170, y: -51.5)
        }
    }
}

struct DistanceFromBuildingView_Previews: PreviewProvider {
    static var previews: some View {
        DistanceFromRestaurant().environmentObject(BudgetManager())
    }
}
