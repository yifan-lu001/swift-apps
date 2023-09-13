//
//  DroppedPin.swift
//  Campus III
//
//  Created by Yifan Lu on 4/6/23.
//

import Foundation
import MapKit

class DroppedPin: NSObject, MKAnnotation {
    var coordinate: CLLocationCoordinate2D
    var title: String?
    init(coord: CLLocationCoordinate2D) {
        coordinate = coord
        let roundedLatitude = round(coordinate.latitude * 100) / 100.0
        let roundedLongitude = round(coordinate.longitude * 100) / 100.0
        title = "(\(roundedLatitude), \(roundedLongitude))"
    }
}
