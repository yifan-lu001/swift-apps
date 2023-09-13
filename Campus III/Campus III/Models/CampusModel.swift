//
//  CampusModel.swift
//  Campus III
//
//  Created by Yifan Lu on 3/11/23.
//

import Foundation
import MapKit
import CoreLocation

// Struct for decoding places from the JSON file
struct Building : Codable, Identifiable, Comparable, Hashable {
    static func < (lhs: Building, rhs: Building) -> Bool {
        return lhs.name < rhs.name
    }
    
    let latitude : Double
    let longitude : Double
    let name : String
    let opp_bldg_code : Int
    let year_constructed : Int?
    let photo : String?
    var id: String { name }
    
    static var allBuildings: [Building] = Bundle.main.decode(file: "buildings.json")
    static let sampleBuilding: Building = allBuildings[0]
}

// Bundle extension to decode JSON file
extension Bundle {
    func decode<T: Decodable>(file: String) -> T {
        guard let url = self.url(forResource: file, withExtension: nil) else {
            fatalError("Could not find \(file) in the project.")
        }
        
        guard let data = try? Data(contentsOf: url) else {
            fatalError("Could not load \(file) in the project.")
        }
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode \(file) in the project.")
        }
        
        return loadedData
    }
    
    func decodeWithString<T: Decodable>(contents: String) -> T {
        let data = contents.data(using: .utf8)!
        
        let decoder = JSONDecoder()
        
        guard let loadedData = try? decoder.decode(T.self, from: data) else {
            fatalError("Could not decode the String in the project.")
        }
        
        return loadedData
    }
    
}

struct Coord {
    var latitude : Double
    var longitude : Double
}

struct CampusModel {
    var centerCoord : Coord
    var buildings : [Building]
    var favoriteBuildings : [Building]
    var nearbyBuildings : [Building]
    var places : [Place]
    
    init() {
        func getBuildings() -> [Place] {
            var bldgs : [Place] = []
            let fm = FileManager.default
            let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
            let url = urls.first
            var fileURL = url!.appendingPathComponent("plots")
            fileURL = fileURL.appendingPathExtension("json")
            do {
                try bldgs = Bundle.main.decodeWithString(contents: String(contentsOf: fileURL))
            }
            catch {
                // print(error)
            }
            return bldgs
        }
        centerCoord = Coord(latitude: 40.7964685139719, longitude: -77.8628317618596)
        buildings = Building.allBuildings
        buildings.sort()
        favoriteBuildings = []
        nearbyBuildings = []
        places = getBuildings()
    }
}
