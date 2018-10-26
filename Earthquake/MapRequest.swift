//
//  MapRequest.swift
//  Earthquake
//
//  Created by mac on 2018/10/27.
//  Copyright © 2018 YWC. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON

class MapRequest {
    static func requestEarthquakesOfAllDay(success:@escaping ([Feature])->(), failure:@escaping (Error)->()) {
        let allDayURLString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
        guard let allDayURL = URL(string: allDayURLString) else {
            return
        }
        Alamofire.request(allDayURL).responseJSON { (dataResponse) in
            // Handle error
            if let error = dataResponse.error {
                failure(error)
                return
            }
            
            let error = NSError(domain: "JSON format is not expected", code: -1, userInfo: [NSLocalizedDescriptionKey:"JSON format is not expected"]) as Error
            
            // Use SwiftyJSON to get features array
            guard let value = dataResponse.result.value else {
                failure(error)
                return
            }
            let json = JSON(value)
            guard let featuresArrayObject = json["features"].arrayObject as? [[String:Any]] else {
                failure(error)
                return
            }
            // Use HandyJSON to convert dictionaries to model structs
            let features = featuresArrayObject.map({ (dictJSON) -> Feature in
                return Feature.deserialize(from: dictJSON)!
            })
            success(features)
        }
    }
}


