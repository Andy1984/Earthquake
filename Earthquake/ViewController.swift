//
//  ViewController.swift
//  Earthquake
//
//  Created by mac on 2018/10/25.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    var tableView:UITableView!
    var features:[Feature] = []
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCell(withIdentifier: "ID")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "ID")
        }
        let feature = self.features[indexPath.row]
        cell!.textLabel!.text = feature.properties?.title
        return cell!
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Earthquakes"
        tableView = UITableView(frame: self.view.frame, style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        
        let allDayURLString = "https://earthquake.usgs.gov/earthquakes/feed/v1.0/summary/all_day.geojson"
        guard let allDayURL = URL(string: allDayURLString) else {
            return
        }
        Alamofire.request(allDayURL).responseJSON { (dataResponse) in
            guard let value = dataResponse.result.value else {
                return
            }
            let json = JSON(value)
//            let type = json["type"].string
            guard let featuresArrayObject = json["features"].arrayObject as? [[String:Any]] else {
                return
            }
//            let metadata = json["metadata"].dictionaryObject
//            let bbox = json["bbox"].arrayObject
            self.features = featuresArrayObject.map({ (dictJSON) -> Feature in
                return Feature.deserialize(from: dictJSON)!
            })
            self.tableView.reloadData()
        }
    }


}

