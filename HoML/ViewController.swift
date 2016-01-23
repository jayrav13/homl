//
//  ViewController.swift
//  HoML
//
//  Created by Jay Ravaliya on 1/22/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate {

    var locationManager : CLLocationManager!
    var locationTimer : NSTimer!
    
    var historyBarButtonItem : UIBarButtonItem!
    var profileBarButtonItem : UIBarButtonItem!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.view.backgroundColor = UIColor.whiteColor()
        
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.historyBarButtonItem = UIBarButtonItem(title: "History", style: UIBarButtonItemStyle.Plain, target: self, action: "pushToHistoryViewController:")
        self.navigationItem.leftBarButtonItem = self.historyBarButtonItem
        
        self.profileBarButtonItem = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "pushToProfileViewController:")
        self.navigationItem.rightBarButtonItem = self.profileBarButtonItem
        
        /*API.createUser(23, gender: "M", bio: "sup", story: "sup bro") { (success, data) -> Void in
            if(success) {
                print("Success!")
            }
            else {
                print("Fail!")
            }
        }*/
        
        if(CLLocationManager.locationServicesEnabled()) {
            // locationTimer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: "sendLocation", userInfo: nil, repeats: true)
        }
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        
    }

    func sendLocation() {
        API.sendLocation((self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!) { (success, data) -> Void in
            
        }
    }
    
    func pushToHistoryViewController(sender : UIButton) {
        var hvc : HistoryViewController = HistoryViewController()
        self.navigationController?.pushViewController(hvc, animated: true)
    }
    
    func pushToProfileViewController(sender : UIButton) {
        var pvc : ProfileViewController = ProfileViewController()
        self.navigationController?.pushViewController(pvc, animated: true)
    }

}

