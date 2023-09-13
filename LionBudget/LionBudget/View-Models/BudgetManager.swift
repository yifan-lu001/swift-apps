//
//  BudgetManager.swift
//  LionBudget
//
//  Created by Yifan Lu on 4/5/23.
//

import Foundation
import MapKit
import SwiftUI
import WidgetKit

class BudgetManager : NSObject, ObservableObject {
    /*----- The Model -----*/
    @Published var model : BudgetModel = BudgetModel() {
        didSet {
            WidgetCenter.shared.reloadAllTimelines()
        }
    }
    
    /*----- Published variables -----*/
    @Published var region: MKCoordinateRegion
    @Published var location: CLLocationCoordinate2D?
    @Published var mapKitTrackingMode: MKUserTrackingMode = .none
    @Published var mapType: MKMapType = .standard
    @Published var showRoute: Bool = false
    @Published var walkingTo: MKMapItem = MKMapItem.forCurrentLocation()
    @Published var showDirections: Bool = false
    @Published var directionsTo: [String] = []
    @Published var droppedPins : [DroppedPin] = []
    @Published var nearbyRestaurants: [Venue] = []
    @Published var driving: Bool = false
    
    /*----- Selectors -----*/
    @Published var selectedPlace : Place?
    @Published var selectedDroppedPin : DroppedPin?
    @Published var selectedRestaurantDistance: String = ""
    @Published var selectedRestaurantHeading: Double = -1.0
    @Published var selectedPinDistance: Double = -1.0
    @Published var selectedRestaurant: Venue = Venue(name: "Chipotle", id: "Chipotle", rating: 3.7, price: "$", is_closed: false, distance: 10.1, address: "116 Heister St, State College, PA, 16801")
    @Published var selectedRestaurantCoordinate: Coord = Coord(latitude: 40.7964685139719, longitude: -77.8628317618596)
    
    /*----- Presenters -----*/
    @Published var showConfirmation = false
    @Published var showConfirmationDroppedPin = false
    
    /*----- Other variables -----*/
    let span = 0.01
    let pricePerMile = 0.655
    let locationManager: CLLocationManager
    
    /*----- Functions -----*/
    
    // Removes the given category
    func removeCategory(category: BudgetCategory) {
        let i = model.categories.firstIndex(of: category)!
        model.categories.remove(at: i)
    }
    
    // Adds the given category
    func addCategory(category: BudgetCategory) {
        model.categories.append(category)
    }
    
    // Given a category and a color, returns the category with correct RGB properties
    func createCategoryFromColor(category: BudgetCategory, color: Color) -> BudgetCategory {
        var newCategory = category
        let components = UIColor(color).cgColor.components
        let alpha = components![3]
        newCategory.r = (1 - alpha) + alpha * components![0]
        newCategory.g = (1 - alpha) + alpha * components![1]
        newCategory.b = (1 - alpha) + alpha * components![2]
        return newCategory
    }
    
    // Given a category and a color, updates the category with correct RGB properties
    func updateCategoryColor(category: BudgetCategory, color: Color) {
        for i in 0...model.categories.count-1 {
            if model.categories[i] == category {
                let components = UIColor(color).cgColor.components
                let alpha = components![3]
                model.categories[i].r = (1 - alpha) + alpha * components![0]
                model.categories[i].g = (1 - alpha) + alpha * components![1]
                model.categories[i].b = (1 - alpha) + alpha * components![2]
                return
            }
        }
    }
    
    // Gets the current time
    func getTime() -> String {
        let formatter = DateFormatter()
        formatter.timeStyle = .long
        let dateString = formatter.string(from: Date())
        let subString = dateString.dropLast(4)
        return String(subString)
    }
    
    // Gets the date
    func getDate() -> String {
        let formatter = DateFormatter()
        formatter.dateStyle = .long
        formatter.timeStyle = .none
        let dateString = formatter.string(from: Date())
        return dateString
    }
    
    // Creates a zero-based budget
    func createZeroBudget(total: Double) {
        for i in 0...model.categories.count-1 {
            model.categories[i].maxSpending = total / Double(model.categories.count)
        }
    }
    
    // Removes a building from being tracked as distance
    func removeBottomBar() {
        self.selectedRestaurantDistance = ""
        self.showRoute = false
        self.driving = false
    }
    
    // Calculates the distance and directions to a venue
    func getDistanceToRestaurant() {
        self.calculateHeading(coord: selectedRestaurantCoordinate)
        let p2 = MKPlacemark(coordinate: selectedRestaurantCoordinate.coordCL2D)
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
            self.selectedRestaurantDistance = outputString!
            self.directionsTo = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
    }
    
    // Calculates the distance and directions to a dropped pin
    func getDistanceToPin(pin: DroppedPin) {
        self.selectedDroppedPin = pin
        self.selectedRestaurant = Venue(name: pin.title!)
        self.calculateHeading(coord: Coord(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude))
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
            self.selectedRestaurantDistance = outputString!
            self.directionsTo = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        
        let firsLocation = CLLocation(latitude: self.location!.latitude, longitude: self.location!.longitude)
        let secondLocation = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        self.selectedPinDistance = firsLocation.distance(from: secondLocation) / 1609
    }
    
    // Calculates the AUTOMOBILE distance and directions to a dropped pin
    func getAutomobileDistanceToPin(pin: DroppedPin) {
        self.driving = true
        self.selectedDroppedPin = pin
        self.selectedRestaurant = Venue(name: pin.title!)
        self.calculateHeading(coord: Coord(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude))
        let p2 = MKPlacemark(coordinate: pin.coordinate)
        let request = MKDirections.Request()
        request.source = MKMapItem.forCurrentLocation()
        request.destination = MKMapItem(placemark: p2)
        self.walkingTo = MKMapItem(placemark: p2)
        self.showRoute = true
        request.transportType = .automobile
        
        let directions = MKDirections(request: request)
        directions.calculate { response, error in
            guard let route = response?.routes.first else { return }
            let formatter = DateComponentsFormatter()
            formatter.unitsStyle = .full
            formatter.includesApproximationPhrase = true
            formatter.allowedUnits = [.hour, .minute, .second]
            let outputString = formatter.string(from: route.expectedTravelTime)
            self.selectedRestaurantDistance = outputString!
            self.directionsTo = route.steps.map { $0.instructions }.filter { !$0.isEmpty }
        }
        
        let firsLocation = CLLocation(latitude: self.location!.latitude, longitude: self.location!.longitude)
        let secondLocation = CLLocation(latitude: pin.coordinate.latitude, longitude: pin.coordinate.longitude)
        self.selectedPinDistance = firsLocation.distance(from: secondLocation) / 1609
    }
    
    // Calculates the heading to a locatiopn
    func calculateHeading(coord: Coord) {
        let lat1 = location!.latitude
        let long1 = location!.longitude
        let lat2 = coord.latitude
        let long2 = coord.longitude
        // Formula found from online GPS website
        let x = cos(lat2 / 180 * .pi) * sin((long2 - long1) / 180 * .pi)
        let y = cos(lat1 / 180 * .pi) * sin(lat2 / 180 * .pi) - sin(lat1 / 180 * .pi) * cos(lat2 / 180 * .pi) * cos((long2 - long1) / 180 * .pi)
        selectedRestaurantHeading = atan2(x,y)
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
    
    // Gets the formatted string for price of gas
    func getPrice() -> String {
        var price = Double(String(format: "%.2f", self.pricePerMile * self.selectedPinDistance / 1609))
        if price ?? 0.0 < 0.01 {
            price = 0.01
        }
        return String(format: "%.2f", price!)
    }
    
    // Loads data from Yelp API
    func loadData() {
        let apikey = "wTNS9T-dTE8aWzqbs7Bu39WUiHj1tc1rrYG9h1AcA_lfHKCOHrIvgCSmGRpPAeRpF9a73VPheWbPHV-HmfsAUI-C1hwL3ak2Rdo8nEOoWc03hia_gGc0-YybR0YvZHYx"
        guard let url = URL(string: "https://api.yelp.com/v3/businesses/search?term=restaurants&latitude=\(location!.latitude)&longitude=\(location!.longitude)") else {return}
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        urlRequest.setValue("application/json", forHTTPHeaderField: "Content-Type")
        urlRequest.setValue("Bearer \(apikey)", forHTTPHeaderField: "Authorization")
        URLSession.shared.dataTask(with: urlRequest) { data, response, error in
            if let data = data {
                do {
                    // Read data as JSON
                    let json = try JSONSerialization.jsonObject(with: data, options: [])
                    
                    // Main dictionary
                    guard let resp = json as? NSDictionary else { return }
                    
                    // Businesses
                    guard let businesses = resp.value(forKey: "businesses") as? [NSDictionary] else { return }
                    
                    var venuesList: [Venue] = []
                    
                    for business in businesses {
                        var venue = Venue()
                        venue.name = business.value(forKey: "name") as? String
                        venue.id = business.value(forKey: "id") as? String
                        venue.rating = business.value(forKey: "rating") as? Float
                        venue.price = business.value(forKey: "price") as? String
                        venue.is_closed = business.value(forKey: "is_closed") as? Bool
                        let distanceInMeters = business.value(forKey: "distance") as? Double
                        venue.distance = (distanceInMeters ?? 0) / 1609
                        let address = business.value(forKeyPath: "location.display_address") as? [String]
                        venue.address = address?.joined(separator: ", ")
                        venuesList.append(venue)
                    }
                    self.nearbyRestaurants = venuesList
                }
                
                catch {
                    print("Caught error")
                }
            }
        }
        .resume()
    }
    
    // Gets coordinates from address
    func addressToCoord(restaurant: Venue) {
        let geocoder = CLGeocoder()
        geocoder.geocodeAddressString(restaurant.address ?? "") {
            placemarks, error in
            guard let placemarks = placemarks, let location = placemarks.first?.location else { return }
            let lat = location.coordinate.latitude
            let lon = location.coordinate.longitude
            self.selectedRestaurantCoordinate = Coord(latitude: lat, longitude: lon)
            self.selectedRestaurant = restaurant
            self.getDistanceToRestaurant()
        }
        
    }
    
    // Parses the prices from raw text read in from the camera
    func parseText(text: String) -> [ReceiptItem] {
        let arrayText = text.split(whereSeparator: \.isNewline)
        var prices: [ReceiptItem] = []
        var id = 1
        for line in arrayText {
            let tmp = line.filter("0123456789.".contains)
            if tmp.contains(".") {
                if let amt = Double(tmp) {
                    prices.append(ReceiptItem(id: id, amount: amt))
                    id = id + 1
                }
            }
        }
        return prices
    }

    // Adds the transaction given the price and category name
    func addTransaction(price: Double, categoryName: String) {
        for i in 0...model.categories.count-1 {
            if model.categories[i].name == categoryName {
                model.categories[i].currentSpending += price
                let transaction = Transaction(amount: price, time: self.getTime(), date: self.getDate())
                model.categories[i].history.append(transaction)
                break
            }
        }
    }
    
    // Resets the spending in the categories
    func resetCategories() {
        for i in 0...model.categories.count-1 {
            model.categories[i].currentSpending = 0
            model.categories[i].history = []
        }
    }
    
    // Gets the history of all categories
    func getAllHistory() -> [HistoryType] {
        var history: [HistoryType] = []
        for cat in model.categories {
            history.append(HistoryType(category: cat, data: cat.history))
        }
        return history
    }
    
    // Encodes to file
    func encodeToFile() {
        // Encode to file
        let encoder = JSONEncoder()
        encoder.outputFormatting = .prettyPrinted
        do {
            let data = try encoder.encode(model.categories)
            let writtenString = String(data: data, encoding: .utf8)!
            let fm = FileManager.default
            let containerURL = fm.containerURL(forSecurityApplicationGroupIdentifier: "group.edu.psu.yjl5480.MyGroup")
            var fileURL = containerURL!.appendingPathComponent("categories")
            fileURL = fileURL.appendingPathExtension("json")
            try writtenString.write(to: fileURL, atomically: true, encoding: .utf8)
        }
        catch {
            // print(error)
        }
    }
    
    // Initializer
    override init() {
        let _budgetModel = BudgetModel()
        region = MKCoordinateRegion(center: _budgetModel.centerCoord.coordCL2D, span: MKCoordinateSpan(latitudeDelta: span, longitudeDelta: span))
        model = _budgetModel
        
        // Location manager initialization
        locationManager = CLLocationManager()
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = .leastNonzeroMagnitude
        locationManager.requestWhenInUseAuthorization()
    }
}

// Extension to support CoreLocation
extension Coord {
    var coordCL2D : CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)
    }
}

extension String {
    func matches(_ regex: String) -> Bool {
        return self.range(of: regex, options: .regularExpression, range: nil, locale: nil) != nil
    }
}
