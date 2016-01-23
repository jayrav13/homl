//
//  MatchDetailsViewController.swift
//  HoML
//
//  Created by Jay Ravaliya on 1/23/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import UIKit
import MapKit
import SwiftyJSON

class MatchDetailsViewController : UIViewController, MKMapViewDelegate {
    
    var mapView : MKMapView!
    var matchData : JSON!
    
    var bioLabel : UILabel!
    var storyLabel : UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = self.matchData["match"]["username"].stringValue
        
        self.mapView = MKMapView()
        self.mapView.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.2, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.4)
        self.mapView.mapType = MKMapType.Standard
        self.mapView.zoomEnabled = true
        self.mapView.scrollEnabled = true
        self.mapView.delegate = self
        self.view.addSubview(mapView)
        
        let location : CLLocationCoordinate2D = CLLocationCoordinate2D(latitude: CLLocationDegrees(self.matchData["lat"].doubleValue), longitude: CLLocationDegrees(self.matchData["long"].doubleValue))
        let coordinateRegion : MKCoordinateRegion = MKCoordinateRegion(center: location, span: MKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView.setRegion(coordinateRegion, animated: true)
        
        let pin : MKPointAnnotation = MKPointAnnotation()
        pin.coordinate = CLLocationCoordinate2DMake(location.latitude, location.longitude)
        pin.title = self.matchData["match"]["username"].stringValue
        self.mapView.addAnnotation(pin)
        
        self.bioLabel = UILabel()
        self.bioLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.1, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.1)
        self.bioLabel.text = self.matchData["match"]["bio"].stringValue
        self.bioLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.bioLabel)
        
        self.storyLabel = UILabel()
        self.storyLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.6, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.3)
        self.storyLabel.text = self.matchData["match"]["story"].stringValue
        self.storyLabel.textAlignment = NSTextAlignment.Justified
        self.storyLabel.numberOfLines = 10
        self.storyLabel.adjustsFontSizeToFitWidth = true
        self.view.addSubview(self.storyLabel)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
