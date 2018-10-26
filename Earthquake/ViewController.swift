//
//  ViewController.swift
//  Earthquake
//
//  Created by mac on 2018/10/25.
//  Copyright © 2018 YWC. All rights reserved.
//

import UIKit
import SVProgressHUD
import MJRefresh

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    private var tableView:UITableView!
    private var features:[Feature] = []
    override func viewDidLoad() {
        super.viewDidLoad()
        title = "Earthquakes"
        createTableView()
        requestEarthquakesList()
    }
    
    @objc func requestEarthquakesList() {
        SVProgressHUD.show()
        MapRequest.requestEarthquakesOfAllDay(success: { (features) in
            SVProgressHUD.dismiss()
            self.features = features
            self.tableView.reloadData()
            self.tableView.mj_header.endRefreshing()
        }) { (error) in
            self.tableView.mj_header.endRefreshing()
            SVProgressHUD.showError(withStatus: error.localizedDescription)
        }
    }
    
    private func createTableView() {
        tableView = UITableView(frame: self.view.frame, style: .plain)
        view.addSubview(tableView)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.mj_header = MJRefreshNormalHeader(refreshingTarget: self, refreshingAction: #selector(requestEarthquakesList))
    }
    
    
    
    // delegate methods of tableView
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.features.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "ID") ?? UITableViewCell(style: .default, reuseIdentifier: "ID")
        let feature = self.features[indexPath.row]
        cell.textLabel!.text = feature.properties?.place
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let focusFeature = self.features[indexPath.row]
        //copy a new array
        var otherFeatures = self.features
        //remove focus one from the new array
        otherFeatures.remove(at: indexPath.row)
        let vc = MapViewController(focusFeature:focusFeature, otherFeatures: otherFeatures)
        navigationController?.pushViewController(vc, animated: true)
        //cancel the selected status
        tableView.cellForRow(at: indexPath)?.isSelected = false
    }
}

