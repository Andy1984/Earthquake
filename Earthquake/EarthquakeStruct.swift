//
//  EarthquakeStruct.swift
//  Earthquake
//
//  Created by mac on 2018/10/26.
//  Copyright © 2018 YWC. All rights reserved.
//

import Foundation
import HandyJSON

struct Feature: HandyJSON {
    init() {}
    var type:String?
    var properties:Properties?
    var geometry:Geometry?
    var id:String?
}

struct Geometry: HandyJSON {
    init() {}
    var type:String?
    var coordinates:[Double]?
}

struct Properties: HandyJSON {
    init() {}
    
    var mag:Float?
    var place:String?
    var time:Int?
    var updated:Int?
    var tz:Int?
    var url:String?
    var detail:String?
    
    var magType:String?
    var type:String?
    var title:String?
    
}
