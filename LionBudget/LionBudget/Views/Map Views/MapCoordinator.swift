//
//  MapCoordinator.swift
//  Campus III
//
//  Created by Yifan Lu on 4/6/23.
//

import Foundation
import MapKit
import SwiftUI

class MapCoordinator : NSObject, MKMapViewDelegate {
    let manager : BudgetManager
    
    init(manager : BudgetManager) {
        self.manager = manager
    }
    func mapView(_ mapView: MKMapView, viewFor annotation: MKAnnotation) -> MKAnnotationView? {
        
        switch annotation {
        case is MKUserLocation:
            return nil
        case is Place:
            _ = annotation as! Place
            let marker = MKAnnotationView(annotation: annotation, reuseIdentifier: "Place")
            marker.image = UIImage(systemName: "mappin")
            marker.isEnabled = true
            marker.canShowCallout = true
            marker.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return marker
            
        case is DroppedPin:
            let marker = MKAnnotationView(annotation: annotation, reuseIdentifier: "DroppedPin")
            marker.image = UIImage(systemName: "mappin.circle")
            marker.isEnabled = true
            marker.canShowCallout = true
            marker.leftCalloutAccessoryView = UIButton(type: .detailDisclosure)
            return marker
            
        default:
            return nil
        }
    }
    
    func mapView(_ mapView: MKMapView, rendererFor overlay: MKOverlay) -> MKOverlayRenderer {
        let polyline = overlay as! MKPolyline
        let renderer = MKPolylineRenderer(polyline: polyline)
        renderer.strokeColor = UIColor.blue
        renderer.lineWidth = 5
        return renderer
    }
    
    func mapView(_ mapView: MKMapView, annotationView view: MKAnnotationView, calloutAccessoryControlTapped control: UIControl) {
        // assume view's annotation is a place
        if let place = view.annotation as? Place {
            manager.showConfirmation = true
            manager.selectedPlace = place
        }
        else {
            let userPin = view.annotation as! DroppedPin
            manager.showConfirmationDroppedPin = true
            manager.selectedDroppedPin = userPin
            
        }
    }
    
    @objc func addPin(recognizer: UILongPressGestureRecognizer) {
        guard recognizer.state == .began else {return}
        
        let view = recognizer.view as! MKMapView
        let point = recognizer.location(in: view)
        let coordinate = view.convert(point, toCoordinateFrom: view)
        
        let pin = DroppedPin(coord: coordinate)
        manager.droppedPins.append(pin)
    }
}
