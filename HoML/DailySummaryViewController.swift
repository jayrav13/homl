//
//  DailySummaryViewController.swift
//  HoML
//
//  Created by Alec Huang on 1/24/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import Foundation
import UIKit
import MapKit
import SwiftyJSON

class DailySummaryViewController : UIViewController, MKMapViewDelegate {
    
    var date : String!
    var dailyMatches : JSON!
    
    var mapView : MKMapView!
    var locationPin : MKPointAnnotation!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let index = self.date.startIndex.advancedBy(5)
        self.date = date.substringToIndex(index)
        self.title = self.date + " Summary"
        
        self.mapView = MKMapView()
        self.mapView.frame = CGRect(x: 0, y: 0, width: Standard.screenWidth, height: Standard.screenHeight)
        self.mapView.mapType = MKMapType.Standard
        self.mapView.zoomEnabled = true
        self.mapView.scrollEnabled = true
        self.mapView.delegate = self
        self.populateMap()
        self.centerMap()
        self.view.addSubview(mapView)
    }
    
    func centerMap() {
        let coordinateRegion : MKCoordinateRegion = MKCoordinateRegion(center: CLLocationCoordinate2D(latitude: CLLocationDegrees(dailyMatches["matches"][0]["lat"].doubleValue), longitude: CLLocationDegrees(dailyMatches["matches"][0]["long"].doubleValue)), span: MKCoordinateSpan(latitudeDelta: 0.1, longitudeDelta: 0.1))
        self.mapView.setRegion(coordinateRegion, animated: true)
    }
    
    func populateMap() {
        if(CLLocationManager.locationServicesEnabled()) {
            for(var i = 0; i < dailyMatches["matches"].count; i++) {
                let locationPin = MKPointAnnotation()
                locationPin.coordinate = CLLocationCoordinate2DMake(CLLocationDegrees(dailyMatches["matches"][i]["lat"].doubleValue), CLLocationDegrees(dailyMatches["matches"][i]["long"].doubleValue))
                locationPin.title = dailyMatches["matches"][i]["match"]["age"].stringValue + " " + dailyMatches["matches"][i]["match"]["gender"].stringValue
                self.mapView.addAnnotation(locationPin)
            }
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}