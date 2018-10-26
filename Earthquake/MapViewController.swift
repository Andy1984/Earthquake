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
    //Init
    init(focusFeature:Feature, otherFeatures:[Feature]) {
        self.focusFeature = focusFeature
        self.otherFeatures = otherFeatures
        super.init(nibName: nil, bundle: nil)
    }
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var focusFeature:Feature
    private var otherFeatures:[Feature]
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    // Create map
    override func loadView() {
        guard let coordinates = parseCoordinates(focusFeature.geometry?.coordinates) else {
            return
        }
        let camera = GMSCameraPosition.camera(withLatitude: coordinates.latitude, longitude: coordinates.longitude, zoom: 6.0)
        let mapView = GMSMapView.map(withFrame: CGRect.zero, camera: camera)
        view = mapView
        
        let selectedMarker = createMarker(feature: focusFeature, mapView: mapView)
        mapView.selectedMarker = selectedMarker
        
        //Creates markers
        for feature in otherFeatures {
            _ = createMarker(feature: feature, mapView:mapView)
        }
    }
    
    func createMarker(feature:Feature, mapView:GMSMapView) -> GMSMarker? {
        guard let coordinates = parseCoordinates(feature.geometry?.coordinates) else {
            return nil
        }
        let marker = GMSMarker()
        marker.position = CLLocationCoordinate2D(latitude: coordinates.latitude, longitude: coordinates.longitude)
        if let property = feature.properties {
            marker.title = property.title
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

    // convert arrary to tuple
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
