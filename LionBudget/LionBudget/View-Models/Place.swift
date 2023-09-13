//
//  Place.swift
//  Campus III
//
//  Created by Yifan Lu on 4/6/23.
//

import Foundation
import MapKit

class Place :  NSObject, Identifiable, MKAnnotation, Codable {
    var latitude: Double
    var longitude: Double
    let name : String
    let opp_bldg_code : Int
    let year_constructed : Int?
    let photo : String?
    var favorite : Bool = false
    var id = UUID()

    static var standard = Place(latitude: 40.7964670898592, longitude: -77.8628317618596, name: "Carnegie", opp_bldg_code: 704000, year_constructed: 1904, photo: "carnegie")
    
    init(latitude: Double, longitude: Double, name: String, opp_bldg_code: Int, year_constructed: Int?, photo: String?) {
        self.latitude = latitude
        self.longitude = longitude
        self.name = name
        self.opp_bldg_code = opp_bldg_code
        self.year_constructed = year_constructed
        self.photo = photo
    }

}

// Computed Properties
extension Place {
    var title : String? { self.name }
    var address : String { get {(self.subThoroughfare ?? "") + " " + (self.thoroughfare ?? "")} }
    var thoroughfare : String? {self.placeMark.thoroughfare}
    var subThoroughfare : String? {self.placeMark.subThoroughfare}
    var placeMark : MKPlacemark { MKPlacemark(coordinate: CLLocationCoordinate2D(latitude: self.latitude, longitude: self.longitude)) }
    var coordinate : CLLocationCoordinate2D {self.placeMark.coordinate}
}

struct Venue: Codable, Hashable, Identifiable {
    var name: String?
    var id: String?
    var rating: Float?
    var price: String?
    var is_closed: Bool?
    var distance: Double?
    var address: String?
}

