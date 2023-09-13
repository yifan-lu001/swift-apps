//
//  CampusManager.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import Foundation
import MapKit
import SwiftUI

class CampusManager : NSObject, ObservableObject {
    @Published var campusModel : CampusModel = CampusModel()
    
    @Published var region : MKCoordinateRegion
    let span = 0.01
    
    @Published var showBuildings : Bool = false
    
    @Published var location: CLLocationCoordinate2D?
        
    @Published var mapKitTrackingMode : MKUserTrackingMode = .none
    
    @Published var mapType : MKMapType = .standard
    
    @Published var whichBuildings : Int = 0
    
    @Published var showRoute : Bool = false
    
    @Published var walkingTo : MKMapItem = MKMapItem.forCurrentLocation()
    
    @Published var showDirections : Bool = false
    
    @Published var directionsTo : [String] = []
    
    @Published var selectedBuildingDistance : String = ""
    @Published var selectedBuildingHeading : Double = -1.0
    @Published var selectedBuilding : Building = Building.sampleBuilding
    
    @Published var droppedPins : [DroppedPin] = []
    
    // Selectors
    @Published var selectedPlace : Place?
    @Published var selectedDroppedPin : DroppedPin?
    @Published var selectedBuildings = Set<Building>() {
        didSet {
            if triggerObservers {
                // Re-enter additionally selected buildings
                addBuildings()
                
                // Remove de-selected buildings
                for i in campusModel.places {
                    if buildingWasDeleted(building: i) {
                        campusModel.places.remove(at: getIndexOfPlaces(place: i))
                    }
                }
                
                // Make data persistent
                encodeToFile()
                
                // Move the map
                if selectedBuildings.count == 0 {
                    self.region.center = CLLocationCoordinate2D(latitude: 40.7964685139719, longitude: -77.8628317618596)
                    self.region.span = MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01)
                }
                else {
                    updateRegion()
                }
            }
        }
    }
        
    // Presenters
    @Published var showConfirmation = false
    @Published var showSheet = false
    @Published var showDetails = false
    @Published var showFavorites = true
    @Published var showPlottedBuildings = true
    @Published var showConfirmationDroppedPin = false
    
    let locationManager : CLLocationManager
    
    // Trigger didSets?
    @Published var triggerObservers : Bool = true
    
    // Toggles a place to be favorited (or not)
    func toggleFavorite(place: Place) {
        guard let index = campusModel.places.firstIndex(of: place) else { return }
        self.campusModel.places[index].favorite.toggle()
        
        // Update the favorites array
        updateFavorites()
        
        // Make data persistent
        encodeToFile()
    }
    
    // Checks if the place is already selected
    func placeNotIn(place: Place) -> Bool {
        for p in self.campusModel.places {
            if place.name == p.name {
                return false
            }
        }
        return true
    }
    
    // Checks if the place is already selected in favorites
    func favoriteNotIn(place: Place) -> Bool {
        for b in self.campusModel.favoriteBuildings {
            if place.name == b.name {
                return false
            }
        }
        return true
    }
    
    // Checks the index of the building
    func getIndexOfPlaces(place: Place) -> Int {
        for i in 0...campusModel.places.count-1 {
            if campusModel.places[i].name == place.name {
                return i
            }
        }
        return -1
    }
    
    // Checks the index of a favorite
    func getIndexOfFavorite(place: Place) -> Int {
        if campusModel.favoriteBuildings.count == 0 {
            return -1
        }
        for i in 0...campusModel.favoriteBuildings.count-1 {
            if campusModel.favoriteBuildings[i].name == place.name {
                return i
            }
        }
        return -1
    }
    
    // Checks if the building was deleted
    func buildingWasDeleted(building: Place) -> Bool {
        for bldg in selectedBuildings {
            if bldg.name == building.name {
                return false
            }
        }
        return true
    }
    
    // Adds data to selectedBuildings
    func updateSelectedBuildings() {
        triggerObservers = false
        for place in self.campusModel.places {
            selectedBuildings.insert(placeToBuilding(place: place))
        }
        triggerObservers = true
    }
    
    // Returns a Building object from a Place object
    func placeToBuilding(place: Place) -> Building {
        var bldg : Building
        if place.year_constructed != 0 && place.photo != "" {
            bldg = Building(latitude: place.latitude, longitude: place.longitude, name: place.name, opp_bldg_code: place.opp_bldg_code, year_constructed: place.year_constructed, photo: place.photo)
        }
        else if place.year_constructed == 0 && place.photo != "" {
            bldg = Building(latitude: place.latitude, longitude: place.longitude, name: place.name, opp_bldg_code: place.opp_bldg_code, year_constructed: nil, photo: place.photo)
        }
        else if place.year_constructed != 0 && place.photo == "" {
            bldg = Building(latitude: place.latitude, longitude: place.longitude, name: place.name, opp_bldg_code: place.opp_bldg_code, year_constructed: place.year_constructed, photo: nil)
        }
        else {
            bldg = Building(latitude: place.latitude, longitude: place.longitude, name: place.name, opp_bldg_code: place.opp_bldg_code, year_constructed: nil, photo: nil)
        }
        return bldg
    }
    
    // Re-updates buildings
    func addBuildings() {
        for building in selectedBuildings {
            var place : Place
            if building.year_constructed != nil && building.photo != nil {
                place = Place(latitude: building.latitude, longitude: building.longitude, name: building.name, opp_bldg_code: building.opp_bldg_code, year_constructed: building.year_constructed, photo: building.photo)
            }
            else if building.year_constructed == nil && building.photo != nil {
                place = Place(latitude: building.latitude, longitude: building.longitude, name: building.name, opp_bldg_code: building.opp_bldg_code, year_constructed: 0, photo: building.photo)
            }
            else if building.year_constructed != nil && building.photo == nil {
                place = Place(latitude: building.latitude, longitude: building.longitude, name: building.name, opp_bldg_code: building.opp_bldg_code, year_constructed: building.year_constructed, photo: "")
            }
            else {
                place = Place(latitude: building.latitude, longitude: building.longitude, name: building.name, opp_bldg_code: building.opp_bldg_code, year_constructed: 0, photo: "")
            }
            if !favoriteNotIn(place: place) {
                place.favorite = true
            }
            if placeNotIn(place: place) {
                self.campusModel.places.append(place)
            }
        }
    }
    
    // Encodes to file
    func encodeToFile() {
        // Encode to file
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(campusModel.places)
            let writtenString = String(data: data, encoding: .utf8)!
            let fm = FileManager.default
            let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
            let url = urls.first
            var fileURL = url!.appendingPathComponent("plots")
            fileURL = fileURL.appendingPathExtension("json")
            try writtenString.write(to: fileURL, atomically: true, encoding: .utf8)
        }
        catch {
            // print(error)
        }
    }
    
    // Update the region of the map after the user selects or deselects buildings to be mapped
    func updateRegion() {
        // Find the maximum and minimum latitude and longitude for plotted buildings
        var minLatitude = 90.0
        var maxLatitude = -90.0
        var minLongitude = 90.0
        var maxLongitude = -90.0
        for place in campusModel.places {
            minLatitude = min(minLatitude, place.latitude)
            maxLatitude = max(maxLatitude, place.latitude)
            minLongitude = min(minLongitude, place.longitude)
            maxLongitude = max(maxLongitude, place.longitude)
        }
        
        // Calculate the center latitude and longitude and span
        let centerLatitude = 0.5 * (minLatitude + maxLatitude)
        let centerLongitude = 0.5 * (minLongitude + maxLongitude)
        let spanX = max((maxLatitude - centerLatitude) * 2.5, 0.01)
        let spanY = max((maxLongitude - centerLongitude) * 2.5, 0.01)
        
        // Set the center and span
        self.region.center = CLLocationCoordinate2D(latitude: centerLatitude, longitude: centerLongitude)
        self.region.span = MKCoordinateSpan(latitudeDelta: spanX, longitudeDelta: spanY)
    }
    
    // Updates the favorites list
    func updateFavorites() {
        for place in campusModel.places {
            // Add newly favorited buildings
            if place.favorite && favoriteNotIn(place: place) {
                campusModel.favoriteBuildings.append(placeToBuilding(place: place))
            }
            
            // Remove de-selected buldings
            if !place.favorite && !favoriteNotIn(place: place) {
                campusModel.favoriteBuildings.remove(at: getIndexOfFavorite(place: place))
            }
        }
    }
    
    // Updates the nearby list
    func updateNearby() {
        campusModel.nearbyBuildings.removeAll()
        for building in campusModel.buildings {
            if isNearby(building: building) {
                campusModel.nearbyBuildings.append(building)
            }
        }
    }
    
    // Checks if a building is nearby
    func isNearby(building: Building) -> Bool {
        let buildingLocation : CLLocation = CLLocation(latitude: building.latitude, longitude: building.longitude)
        let myLocation : CLLocation = CLLocation(latitude: location!.latitude, longitude: location!.longitude)
        let distance = myLocation.distance(from: buildingLocation)
        if distance <= 250 {
            return true
        }
        return false
    }
    
    // Calculates the distance to a building
    func getDistanceTo(building: Building) {
        self.selectedBuilding = building
        let p2 = MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: building.latitude, longitude: building.longitude))
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: p2)
        self.walkingTo = MKMapItem(placemark: p2)
        self.showRoute = false
        self.showRoute = true
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.includesApproximationPhrase = true
            formatter.allowedUnits = [.hour, .minute, .second]
            let outputString = formatter.string(from: route.expectedTravelTime)
            self.selectedBuildingDistance = outputString!
            self.directionsTo = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
    }
    
    // Calculates the distance and directions to a dropped pin
    func getDistanceToPin(pin: DroppedPin) {
        self.selectedDroppedPin = pin
        self.selectedBuilding = Building(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude, name: pin.title!, opp_bldg_code: 0, year_constructed: 0, photo: "")
        self.calculateHeading(building: self.selectedBuilding)
        let p2 = MKPlacemark(coordinate: pin.coordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: p2)
        self.walkingTo = MKMapItem(placemark: p2)
        self.showRoute = true
        request.transportType = .walking
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.includesApproximationPhrase = true
            formatter.allowedUnits = [.hour, .minute, .second]
            let outputString = formatter.string(from: route.expectedTravelTime)
            self.selectedBuildingDistance = outputString!
            self.directionsTo = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
    }
    
    // Removes a building from being tracked as distance
    func removeBottomBar() {
        self.selectedBuildingDistance = ""
        self.showRoute = false
    }
    
    // Calculates the heading to a building
    func calculateHeading(building: Building) {
        let lat1 = location!.latitude
        let long1 = location!.longitude
        let lat2 = building.latitude
        let long2 = building.longitude
        // Formula found from online GPS website
        let x = cos(lat2 / 180 * .pi) * sin((long2 - long1) / 180 * .pi)
        let y = cos(lat1 / 180 * .pi) * sin(lat2 / 180 * .pi) - sin(lat1 / 180 * .pi) * cos(lat2 / 180 * .pi) * cos((long2 - long1) / 180 * .pi)
        selectedBuildingHeading = atan2(x,y)
    }
    
    // Gets the name of the pin to be used
    func getNameOfPin(place: Place) -> String {
        if !self.showPlottedBuildings {
            return ""
        }
        else if !self.showFavorites {
            return "mappin.and.ellipse"
        }
        else if !place.favorite {
            return "mappin.and.ellipse"
        }
        return "heart.circle"
    }
    
    // Removes a dropped pin
    func removePin(pin: DroppedPin) {
        for i in 0...self.droppedPins.count {
            if self.droppedPins[i].coordinate.longitude == pin.coordinate.longitude && self.droppedPins[i].coordinate.latitude == pin.coordinate.latitude {
                self.droppedPins.remove(at: i)
                return
            }
        }
    }
    
    // Initializer
    override init() {
        let _campusModel = CampusModel()
        region = MKCoordinateRegion(center: _campusModel.centerCoord.coordCL2D, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
        campusModel = _campusModel
        
        // Location manager initialization
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = .leastNonzeroMagnitude
        locationManager.requestWhenInUseAuthorization()
        
        // Update the selected buildings
        updateSelectedBuildings()
        
        // Update the favorites
        updateFavorites()
        
        // Update the region if necessary
        if selectedBuildings.count != 0 {
            updateRegion()
        }
    }
}

// Define extensions here to have support for CoreLocation
extension Coord {
    var coordCL2D : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}
