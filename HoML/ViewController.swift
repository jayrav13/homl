//
//  ViewController.swift
//  HoML
//
//  Created by Jay Ravaliya on 1/22/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import UIKit
import CoreLocation
import SwiftyJSON

class ViewController: UIViewController, CLLocationManagerDelegate, UITableViewDelegate, UITableViewDataSource {

    // Location Stuff
    var locationManager : CLLocationManager!
    var locationTimer : NSTimer!
    
    // Nav Buttons
    var historyBarButtonItem : UIBarButtonItem!
    var profileBarButtonItem : UIBarButtonItem!
    
    var saidHelloToLabel : UILabel!
    var biosTableView : UITableView!
    var goToProfileLabel : UILabel!
    
    var currentUser : JSON!
    var userMatches : JSON!
    
    override func viewDidLoad() {
        
        // Basics
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "HOME"
        self.userMatches = []
        
        // Location Setup
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        // Add Buttons
        self.historyBarButtonItem = UIBarButtonItem(title: "History", style: UIBarButtonItemStyle.Plain, target: self, action: "pushToHistoryViewController:")
        self.navigationItem.leftBarButtonItem = self.historyBarButtonItem
        
        self.profileBarButtonItem = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "pushToProfileViewController:")
        self.navigationItem.rightBarButtonItem = self.profileBarButtonItem
        
        // If Location Services enabled, set up timer.
        if(CLLocationManager.locationServicesEnabled()) {
            // locationTimer = NSTimer.scheduledTimerWithTimeInterval(300, target: self, selector: "sendLocation", userInfo: nil, repeats: true)
        }
        
        // UI Elements - do not add yet
        self.saidHelloToLabel = UILabel()
        self.saidHelloToLabel.frame = CGRect(x: 0, y: Standard.screenHeight * 0.25, width: Standard.screenWidth, height: Standard.screenHeight * 0.05)
        self.saidHelloToLabel.text = "You could have said \"Hello\" to..."
        self.saidHelloToLabel.adjustsFontSizeToFitWidth = true
        self.saidHelloToLabel.textAlignment = NSTextAlignment.Center
        
        self.biosTableView = UITableView()
        self.biosTableView.frame = CGRect(x: Standard.screenWidth * 0.05, y: Standard.screenHeight * 0.40, width: Standard.screenWidth * 0.90, height: Standard.screenHeight * 0.15 * 3)
        self.biosTableView.dataSource = self
        self.biosTableView.delegate = self
        self.biosTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.biosTableView.scrollEnabled = false
        
        self.goToProfileLabel = UILabel()
        self.goToProfileLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.40, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.20)
        self.goToProfileLabel.text = "Go to your Profile page to get started!"
        self.goToProfileLabel.adjustsFontSizeToFitWidth = true
        self.goToProfileLabel.textAlignment = NSTextAlignment.Center
        
        self.loadUIElements()
        
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadUIElements()
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
        let hvc : HistoryViewController = HistoryViewController()
        self.navigationController?.pushViewController(hvc, animated: true)
    }
    
    func pushToProfileViewController(sender : UIButton) {
        // NSAPI.setProfileAddedSetting(true)
        let pvc : ProfileViewController = ProfileViewController()
        self.navigationController?.pushViewController(pvc, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        let cell : UITableViewCell = self.biosTableView.dequeueReusableCellWithIdentifier("cell")!
        if(userMatches.count != 0) {
            cell.textLabel?.text = self.userMatches["matches"][indexPath.row]["user2_id"].stringValue
        }
        else {
            cell.textLabel?.text = "Test"
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.biosTableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(userMatches.count != 0) {
            return userMatches["matches"].count
        }
        else {
            return 0
        }
        
    }

    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return Standard.screenHeight * 0.15
    }
    
    func loadUIElements() {
        if(NSAPI.getProfileAddedSetting()) {
            self.view.addSubview(self.saidHelloToLabel)
            self.view.addSubview(self.biosTableView)
            API.getMatches { (success, data) -> Void in
                if(success) {
                    self.userMatches = data
                    self.biosTableView.reloadData()
                }
                else {
                    print("Error")
                }
            }
        }
        else {
            self.view.addSubview(self.goToProfileLabel)
            // Do nothing
        }
    }
    
}

