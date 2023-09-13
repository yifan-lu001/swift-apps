//
//  UIMap.swift
//  Campus III
//
//  Created by Yifan Lu on 4/6/23.
//

import SwiftUI
import MapKit

struct UIMap: UIViewRepresentable {
    @ObservedObject var manager : BudgetManager
    
    func makeUIView(context: Context) -> MKMapView {
        let mapView = MKMapView()
        mapView.mapType = .standard
        mapView.showsUserLocation = true
        mapView.setRegion(manager.region, animated: true)
        mapView.delegate = context.coordinator
        mapView.userTrackingMode = .none
        
        let longPress = UILongPressGestureRecognizer(target: context.coordinator, action: #selector(context.coordinator.addPin))
        
        mapView.addGestureRecognizer(longPress)
        return mapView
    }
    
    func updateUIView(_ mapView: MKMapView, context: Context) {
        let annotations = mapView.annotations
        mapView.removeAnnotations(annotations)
        mapView.addAnnotations(manager.droppedPins)
        mapView.setRegion(manager.region, animated: true)
        
        mapView.mapType = manager.mapType
        mapView.userTrackingMode = manager.mapKitTrackingMode
        
        if manager.showRoute {
            mapView.removeOverlays(mapView.overlays)
            let request = MKDirections.Request()
            request.source = MKMapItem.forCurrentLocation()
            request.destination = manager.walkingTo
            request.transportType = .walking
            
            let directions = MKDirections(request: request)
            directions.calculate { response, error in
                guard let route = response?.routes.first else { return }
                mapView.addOverlay(route.polyline)
                mapView.setVisibleMapRect(
                  route.polyline.boundingMapRect,
                  edgePadding: UIEdgeInsets(top: 20, left: 20, bottom: 20, right: 20),
                  animated: true)
            }
        }
        else {
            mapView.removeOverlays(mapView.overlays)
        }
    }
        
    func makeCoordinator() -> MapCoordinator {
        return MapCoordinator(manager: manager)
    }
}

