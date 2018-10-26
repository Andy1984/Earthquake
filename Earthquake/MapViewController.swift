//
//  MapViewController.swift
//  Earthquake
//
//  Created by mac on 2018/10/26.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
class MapViewController: UIViewController {
    private var focusFeature:Feature
    private var otherFeatures:[Feature]
    
    //Init
    init(focusFeature:Feature, otherFeatures:[Feature]) {
        self.focusFeature = focusFeature
        self.otherFeatures = otherFeatures
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.title = "Google Map"
    }
    
    // Create map
    override func loadView() {
        guard let coordinates = parseCoordinates(focusFeature.geometry?.coordinates) else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let selectedMarker = self.createMarker(feature: self.focusFeature, mapView: mapView)
        mapView.selectedMarker = selectedMarker
        // Creates markers
        DispatchQueue.global().async {
            // This loop costs 0.005s on iPhone8 if the array size is 240
            for feature in self.otherFeatures {
                _ = self.createMarker(feature: feature, mapView:mapView)
            }
        }
    }
    
    func createMarker(feature:Feature, mapView:GMSMapView) -> GMSMarker? {
        guard let coordinates = parseCoordinates(feature.geometry?.coordinates) else {
            return nil
        }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        if let property = feature.properties {
            marker.title = property.place
            if let millisecond = property.time {
                let second = TimeInterval(millisecond) / 1000
                let timeDate = Date(timeIntervalSince1970: second)
                let timeString = timeDate.description
                marker.snippet = timeString
            }
            marker.map = mapView
        }
        return marker
    }

    // convert array to tuple
    func parseCoordinates(_ wrappedCoordinates:[Double]?) -> (longitude:Double, latitude:Double, depth:Double)? {
        guard let coordinates = wrappedCoordinates else {
            return nil
        }
        guard coordinates.count == 3 else {
            return nil
        }
        let longitude = coordinates[0]
        let latitude = coordinates[1]
        let depth = coordinates[2]
        return (longitude, latitude, depth)
    }
}
