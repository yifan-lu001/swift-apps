//
//  NearbyRestaurantsView.swift
//  LionBudget
//
//  Created by Yifan Lu on 4/6/23.
//

import SwiftUI

struct GoToRestaurantButton: View {
    @EnvironmentObject var budgetManager: BudgetManager
    @Environment(\.dismiss) private var dismiss
    var restaurant: Venue
    
    var body: some View {
        Button(action: {
            budgetManager.addressToCoord(restaurant: restaurant)
            dismiss()
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 15)
                        .foregroundColor(Color.logoColor)
                    Text("Go here!")
                        .foregroundColor(.white)
                }
                .frame(width: 100, height: 35)
        }
    }
}

struct Restaurant: View {
    var restaurant: Venue
    
    var body: some View {
        ZStack {
            LinearGradient(gradient: Gradient(colors: [Color.white, Color(red: 225/255, green: 225/255, blue: 1)]), startPoint: .topLeading, endPoint: .bottomTrailing)
                .cornerRadius(25)
                .padding([.leading, .trailing], 25)
                .overlay(
                    RoundedRectangle(cornerRadius: 25)
                        .stroke(Color.logoColor, lineWidth: 2)
                        .padding([.leading, .trailing], 25)
                )
            VStack {
                Text(restaurant.name ?? "No name available")
                    .font(.title3)
                    .bold()
                    .padding([.top], 10)
                Text(restaurant.address ?? "No address available")
                    .multilineTextAlignment(.center)
                    .padding([.leading, .trailing], 25)
                Text(restaurant.price ?? "No price available")
                    .foregroundColor(.green)
                Text(String(format: "%.2f", restaurant.distance ?? 0) + " mi")
                GoToRestaurantButton(restaurant: restaurant)
                    .padding([.bottom], 10)
            }
        }
    }
}

struct NearbyRestaurantsView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var body: some View {
        VStack {
            ScrollView(.vertical) {
                ForEach(budgetManager.nearbyRestaurants) { restaurant in
                    Restaurant(restaurant: restaurant)
                }
            }
        }
    }
}

struct NearbyRestaurantsView_Previews: PreviewProvider {
    static var previews: some View {
        NearbyRestaurantsView().environmentObject(BudgetManager())
    }
}
