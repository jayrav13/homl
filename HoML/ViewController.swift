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
    
    var helloLabel : UILabel!
    
    var dangerButton : UIButton!
    var dangerBox : UILabel!
    
    var activityIndicator : UIActivityIndicatorView!
    
    override func viewDidLoad() {
        
        // Nav bar title
        self.navigationController?.navigationBar.tintColor = UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)
        self.navigationController!.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName : UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)]
        
        // Basics
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        self.title = "storyteller"
        self.navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont(name: "Mentone-Semibold", size: 20)!]
        self.userMatches = []
        
        // Location Setup
        self.locationManager = CLLocationManager()
        self.locationManager.delegate = self
        self.locationManager.requestAlwaysAuthorization()
        self.locationManager.requestWhenInUseAuthorization()
        self.locationManager.startUpdatingLocation()
        
        self.helloLabel = UILabel()
        self.helloLabel.frame = CGRect(x: 0, y: Standard.screenHeight * 0.15, width: Standard.screenWidth, height: Standard.screenHeight * 0.10)
        self.helloLabel.textAlignment = NSTextAlignment.Center
        self.helloLabel.font = UIFont(name: "OpenSans-Semibold", size: 30)
        self.helloLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        // self.view.addSubview(self.helloLabel)
        
        // Add Buttons
        self.historyBarButtonItem = UIBarButtonItem(title: "History", style: UIBarButtonItemStyle.Plain, target: self, action: "pushToHistoryViewController:")
        self.navigationItem.leftBarButtonItem = self.historyBarButtonItem
        
        self.profileBarButtonItem = UIBarButtonItem(title: "Profile", style: UIBarButtonItemStyle.Plain, target: self, action: "pushToProfileViewController:")
        self.navigationItem.rightBarButtonItem = self.profileBarButtonItem
        
        // If Location Services enabled, set up timer.
        if(CLLocationManager.locationServicesEnabled()) {
            locationTimer = NSTimer.scheduledTimerWithTimeInterval(30, target: self, selector: "sendLocation", userInfo: nil, repeats: true)
        }
        
        // UI Elements - do not add yet
        self.saidHelloToLabel = UILabel()
        self.saidHelloToLabel.frame = CGRect(x: 0, y: Standard.screenHeight * 0.25, width: Standard.screenWidth, height: Standard.screenHeight * 0.05)
        self.saidHelloToLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.saidHelloToLabel.font = UIFont(name: "OpenSans-Semibold", size: 18)
        self.saidHelloToLabel.text = "Today, you could have said \"hello\" to..."
        self.saidHelloToLabel.adjustsFontSizeToFitWidth = true
        self.saidHelloToLabel.textAlignment = NSTextAlignment.Center
        
        self.biosTableView = UITableView()
        self.biosTableView.frame = CGRect(x: 0, y: Standard.screenHeight * 0.40, width: Standard.screenWidth, height: Standard.screenHeight * 0.10 * 3)
        self.biosTableView.dataSource = self
        self.biosTableView.delegate = self
        self.biosTableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.biosTableView.scrollEnabled = false
        self.biosTableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.biosTableView.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        
        self.goToProfileLabel = UILabel()
        self.goToProfileLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.40, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.20)
        self.goToProfileLabel.text = "Go to your Profile page to get started!"
        self.goToProfileLabel.font = UIFont(name: "OpenSans-Semibold", size: 18)
        self.goToProfileLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.goToProfileLabel.adjustsFontSizeToFitWidth = true
        self.goToProfileLabel.textAlignment = NSTextAlignment.Center
        
        self.dangerBox = UILabel()
        self.dangerBox.frame = CGRect(x: 0, y: Standard.screenHeight * 0.9, width: Standard.screenWidth, height: Standard.screenHeight * 0.1)
        self.dangerBox.backgroundColor = UIColor.whiteColor()
        // self.view.addSubview(self.dangerBox)
        
        self.dangerButton = UIButton(type: UIButtonType.System)
        self.dangerButton.frame = CGRect(x: 0, y: Standard.screenHeight * 0.9, width: Standard.screenWidth, height: Standard.screenHeight * 0.1)
        self.dangerButton.setTitle("Safety Status", forState: UIControlState.Normal)
        self.dangerButton.addTarget(self, action: "pushToDangerViewController:", forControlEvents: UIControlEvents.TouchUpInside)
        self.dangerButton.backgroundColor = UIColor(red: 0, green: 1, blue: 0, alpha: 0.5)
        self.dangerButton.setTitleColor(UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1), forState: UIControlState.Normal)
        self.dangerButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 18)
        // self.view.addSubview(self.dangerButton)
        
        self.activityIndicator = UIActivityIndicatorView(activityIndicatorStyle: UIActivityIndicatorViewStyle.WhiteLarge)
        self.activityIndicator.frame = CGRect(x: Standard.screenWidth / 2 - Standard.screenWidth * 0.05, y: Standard.screenHeight / 2 - Standard.screenWidth * 0.05, width: Standard.screenWidth * 0.1, height: Standard.screenHeight * 0.1)
        self.activityIndicator.alpha = 0
        if(NSAPI.getProfileAddedSetting()) {
            self.view.addSubview(self.activityIndicator)
        }
        
        self.loadUIElements()
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.loadUIElements()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func locationManager(manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
    }
    
    func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        self.locationManager.startUpdatingLocation()
    }
    
    func sendLocation() {
        API.sendLocation((self.locationManager.location?.coordinate.latitude)!, longitude: (self.locationManager.location?.coordinate.longitude)!) { (success, data) -> Void in
            if(success) {
                
                if(data["sum"].doubleValue <= 10.0) {
                    self.dangerButton.backgroundColor = UIColor(red: 28/255, green: 136/255, blue: 72/255, alpha: 0.5)
                }
                else if(data["sum"].doubleValue > 10.0 && data["sum"].doubleValue <= 20.0) {
                    self.dangerButton.backgroundColor = UIColor(red: 255/255, green: 171/255, blue: 0, alpha: 0.5)
                }
                else {
                    self.dangerButton.backgroundColor = UIColor(red: 255/255, green: 7/255, blue: 0, alpha: 0.5)
                }
                
            }
            else {
                print("Error sending location!")
            }
        }
    }
    
    func pushToHistoryViewController(sender : UIButton) {
        let hvc : HistoryViewController = HistoryViewController()
        API.getDates { (success, data) -> Void in
            hvc.matchDates = data
            self.navigationController?.pushViewController(hvc, animated: true)
        }
    }
    
    func pushToProfileViewController(sender : UIButton) {
        let pvc : ProfileViewController = ProfileViewController()
        if(self.currentUser != nil) {
            pvc.userData = self.currentUser
        }
        self.navigationController?.pushViewController(pvc, animated: true)
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = self.biosTableView.dequeueReusableCellWithIdentifier("cell")!
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.textLabel?.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        if(userMatches.count != 0) {
            cell.textLabel?.text = self.userMatches["matches"][indexPath.row]["match"]["bio"].stringValue
            // cell.detailTextLabel?.text = self.userMatches["matches"][indexPath.row]["match"]["story"].stringValue
        }
        else {
            cell.textLabel?.text = "Test"
        }
        cell.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.biosTableView.deselectRowAtIndexPath(indexPath, animated: true)
        let mdvc : MatchDetailsViewController = MatchDetailsViewController()
        mdvc.matchData = self.userMatches["matches"][indexPath.row]
        self.navigationController?.pushViewController(mdvc, animated: true)
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
        return Standard.screenHeight * 0.10
    }
    
    func loadUIElements() {
        self.activityIndicator.alpha = 1
        self.activityIndicator.startAnimating()
        if(NSAPI.getProfileAddedSetting()) {
            API.getUser({ (success, data) -> Void in
                if(success) {
                    for(var i = 0; i < data["users"].count; i++) {
                        if(data["users"][i]["number"].stringValue == API.number) {
                            self.currentUser = data["users"][i]
                            self.helloLabel.text = "Hello, " + self.currentUser["username"].stringValue
                            self.activityIndicator.alpha = 0
                            self.activityIndicator.stopAnimating()
                            break
                        }
                    }
                    
                    self.biosTableView.reloadData()
                    self.view.addSubview(self.helloLabel)
                    self.view.addSubview(self.biosTableView)
                    self.view.addSubview(self.saidHelloToLabel)
                    self.view.addSubview(self.dangerBox)
                    self.view.addSubview(self.dangerButton)
                }
                else {
                    print("Error - user data")
                }
            })
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
    
    func pushToDangerViewController(sender : UIButton) {
        let dvc : DangerViewController = DangerViewController()
        self.navigationController?.pushViewController(dvc, animated: true)
    }
    
}

