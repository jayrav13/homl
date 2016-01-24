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
    
    var aslLabel : UILabel!
    var crossImageView : UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        self.title = self.matchData["match"]["username"].stringValue
        self.navigationController?.navigationBar.tintColor = UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)]
        
        let mapping = [
            "M" : "male",
            "F" : "female",
            "O" : ""
        ]
        
        self.aslLabel = UILabel()
        self.aslLabel.frame = CGRect(x: 0, y: Standard.screenHeight * 0.09, width: Standard.screenWidth, height: Standard.screenHeight * 0.1)
        self.aslLabel.text = String(Int(self.matchData["match"]["age"].doubleValue)) + ", " + mapping[self.matchData["match"]["gender"].stringValue]!
        self.aslLabel.textAlignment = NSTextAlignment.Center
        self.aslLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.aslLabel.font = UIFont(name: "OpenSans-Semibold", size: 32)
        self.view.addSubview(self.aslLabel)
        
        self.bioLabel = UILabel()
        self.bioLabel.frame = CGRect(x: Standard.screenWidth * 0.19, y: Standard.screenHeight * 0.18, width: Standard.screenWidth * 0.62, height: Standard.screenHeight * 0.04)
        self.bioLabel.layer.cornerRadius = 5
        self.bioLabel.layer.masksToBounds = true
        self.bioLabel.text = self.matchData["match"]["bio"].stringValue
        self.bioLabel.font = UIFont(name: "OpenSans-Semibold", size: 12)
        self.bioLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.bioLabel.textAlignment = NSTextAlignment.Center
        self.bioLabel.layer.borderColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1).CGColor
        self.bioLabel.layer.borderWidth = 1
        self.view.addSubview(self.bioLabel)
        
        self.storyLabel = UILabel()
        self.storyLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.25, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.4)
        self.storyLabel.text = self.matchData["match"]["story"].stringValue
        self.storyLabel.textAlignment = NSTextAlignment.Justified
        self.storyLabel.numberOfLines = 30
        self.storyLabel.font = UIFont(name: "OpenSans-Semibold", size: 20)
        self.storyLabel.adjustsFontSizeToFitWidth = true
        self.storyLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.view.addSubview(self.storyLabel)
        
        self.mapView = MKMapView()
        self.mapView.frame = CGRect(x: 0, y: Standard.screenHeight * 0.7, width: Standard.screenWidth, height: Standard.screenHeight * 0.3)
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
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
