//
//  ContentView.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import SwiftUI
import CoreLocationUI

struct ContentView: View {
    @EnvironmentObject var campusManager: CampusManager
    var body: some View {
        let buildingToolbarItem = ToolbarItem(placement: .navigationBarLeading) {
            BuildingListButton()
        }
        
        let showFavoritesToolbarItem = ToolbarItem(placement: .navigationBarTrailing) {
            ToggleFavoritesButton()
        }
        
        let showPinsToolbarItem = ToolbarItem(placement: .navigationBarTrailing) {
            TogglePinsButton()
        }
        
        let showUserLocationItem = ToolbarItem(placement: .navigationBarTrailing) {
            UserLocationButton()
        }
        
        let showDistanceMenuItem = ToolbarItem(placement: .navigationBarLeading) {
            GetDistanceMenu()
        }
        
        let mapTypeMenuItem = ToolbarItem(placement: .navigationBarLeading) {
            MapTypeButton()
        }
        
        let deleteDroppedPinsItem = ToolbarItem(placement: .navigationBarLeading) {
            DeleteDroppedPinsButton()
        }
        
        return NavigationStack {
            //CampusMapView()
            UIMap(manager: campusManager)
                .ignoresSafeArea()
                .toolbar {
                    buildingToolbarItem
                    showUserLocationItem
                    showPinsToolbarItem
                    showFavoritesToolbarItem
                    showDistanceMenuItem
                    mapTypeMenuItem
                    deleteDroppedPinsItem
                }
                .overlay (alignment:.bottom) {
                    DistanceFromBuildingView()
                        .frame(height: 100)
                        .padding([.leading, .trailing], 10)
                }
        }
        .sheet(isPresented: $campusManager.showBuildings) {
            BuildingListView(selection: $campusManager.selectedBuildings)
        }
        .sheet(isPresented: $campusManager.showDetails) {
            PlaceDetailsView(place: campusManager.selectedPlace)
        }
        .sheet(isPresented: $campusManager.showDirections) {
            DirectionsView()
        }
        .confirmationDialog("spot", isPresented: $campusManager.showConfirmation, presenting: campusManager.selectedPlace) { place in
            Button(place.favorite ? "Unfavorite" : "Favorite") {
                campusManager.toggleFavorite(place: place)
            }
            Button("Details") {
                campusManager.selectedPlace = place
                campusManager.showDetails = true
            }
        } message: { place in
            Text("\(place.name)")
        }
        .confirmationDialog("drop", isPresented: $campusManager.showConfirmationDroppedPin, presenting: campusManager.selectedDroppedPin) { pin in
            Button("Directions") {
                campusManager.getDistanceToPin(pin: pin)
            }
            Button("Delete Pin") {
                campusManager.removePin(pin: pin)
            }
        } message: { pin in
            Text(pin.title!)
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView().environmentObject(CampusManager())
    }
}
