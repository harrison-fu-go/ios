//
//  ViewController.swift
//  YYMap
//
//  Created by zk-fuhuayou on 2021/6/8.
//

import UIKit
class ViewController: UIViewController, MAMapViewDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //set api key.
        AMapServices.shared().apiKey = "7f346ad6f354441c4c0cd7a6d465d31b"
        AMapServices.shared().enableHTTPS = true
        //set
        let mapView = MAMapView(frame: self.view.bounds)
        mapView.delegate = self
        mapView.isShowsUserLocation = true
        mapView.userTrackingMode = .follow
        
        
        //显示室内地图
//        mapView.isShowTraffic = true
        
        
        //
        self.view.addSubview(mapView)
    }
    

}

