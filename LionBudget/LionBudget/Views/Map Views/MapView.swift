//
//  ContentView.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI
import CoreLocationUI

struct ViewRestaurantsButton: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var body: some View {
        NavigationLink {
            NearbyRestaurantsView()
        } label: {
            Image(systemName: "fork.knife.circle")
        }
    }
}

struct MapView: View {
    @EnvironmentObject var budgetManager: BudgetManager
    var body: some View {
        let showUserLocationItem = ToolbarItem(placement: .navigationBarTrailing) {
            UserLocationButton()
        }
        
        let mapTypeMenuItem = ToolbarItem(placement: .navigationBarLeading) {
            MapTypeButton()
        }
        
        let viewRestaurantsMenuItem = ToolbarItem(placement: .navigationBarLeading) {
            ViewRestaurantsButton()
        }
        
        return NavigationStack {
            //CampusMapView()
            UIMap(manager: budgetManager)
                .ignoresSafeArea()
                .toolbar {
                    showUserLocationItem
                    mapTypeMenuItem
                    viewRestaurantsMenuItem
                }
                .overlay (alignment:.bottom) {
                    DistanceFromRestaurant()
                        .frame(height: 100)
                        .padding([.leading, .trailing], 10)
                }
        }
        .onAppear {
            budgetManager.loadData()
        }
        .sheet(isPresented: $budgetManager.showDirections) {
            DirectionsView()
        }
        .confirmationDialog("drop", isPresented: $budgetManager.showConfirmationDroppedPin, presenting: budgetManager.selectedDroppedPin) { pin in
            Button("Walking Directions") {
                budgetManager.getDistanceToPin(pin: pin)
            }
            Button("Driving Directions") {
                budgetManager.getAutomobileDistanceToPin(pin: pin)
            }
            Button("Delete Pin") {
                budgetManager.removePin(pin: pin)
            }
        } message: { pin in
            Text(pin.title!)
        }
    }
}

struct MapView_Previews: PreviewProvider {
    static var previews: some View {
        MapView().environmentObject(BudgetManager())
    }
}
