//
//  DangerViewController.swift
//  HoML
//
//  Created by Jay Ravaliya on 1/23/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import Foundation
import VBPieChart
import CoreLocation

class DangerViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var chart : VBPieChart!
    var latitude : CLLocationDegrees!
    var longitude : CLLocationDegrees!
    
    var tableView : UITableView!
    
    let colors : [UIColor] = [
        UIColor.redColor(),
        UIColor.purpleColor(),
        UIColor.blueColor(),
        UIColor.blackColor(),
        UIColor.brownColor(),
        UIColor.cyanColor(),
        UIColor.darkGrayColor(),
        UIColor.darkTextColor(),
        UIColor.grayColor(),
        UIColor.greenColor(),
        UIColor.lightGrayColor(),
        UIColor.lightTextColor(),
        UIColor.magentaColor(),
        UIColor.orangeColor(),
        UIColor.yellowColor()
    ]
    
    var chartValues : [[String : AnyObject]]!
    var usedColors : [UIColor]!
    
    var label : UILabel!
    
    override func viewDidLoad() {
        chart = VBPieChart()
        
        latitude = 39.942265
        longitude = -75.158698
        super.viewDidLoad()
        self.title = "DangerView"
        self.view.backgroundColor = UIColor.whiteColor()
        self.view.addSubview(chart);
        
        chart.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.1, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.5)
        chart.holeRadiusPrecent = 0.3;
        
        chartValues = []
        API.sendLocation(latitude, longitude: longitude) { (success, data) -> Void in
            
            var currentColors = self.colors
            self.usedColors = []
            
            for(key, value) in data["results"] {
                
                let data : [String : AnyObject] = [
                    "name" : key,
                    "value" : value.doubleValue,
                    "color" : currentColors[0]
                ]
                
                self.usedColors.append(currentColors[0])
                currentColors.removeAtIndex(0)
                if(currentColors.count == 0) {
                    currentColors = self.colors
                }
                self.chartValues.append(data)

            }
            self.chart.setChartValues(self.chartValues as [AnyObject], animation:true);
            self.tableView.reloadData()
            
            self.label = UILabel()
            self.label.frame = CGRect(x: Standard.screenWidth * 0.47, y: Standard.screenWidth * 0.64, width: Standard.screenWidth * 0.06, height: Standard.screenWidth * 0.05)
            self.label.text = "26"
            self.label.textAlignment = NSTextAlignment.Center
            self.label.font = UIFont.boldSystemFontOfSize(18)
            
            self.view.addSubview(self.label)
        }
        
        self.tableView = UITableView()
        self.tableView.frame = CGRect(x: 0, y: Standard.screenHeight * 0.6, width: Standard.screenWidth, height: Standard.screenHeight * 0.3)
        self.tableView.dataSource = self
        self.tableView.delegate = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(self.tableView)
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView!.dequeueReusableCellWithIdentifier("cell")
        cell = UITableViewCell(style: UITableViewCellStyle.Value1, reuseIdentifier: "cell")
        cell?.textLabel?.text = String((self.chartValues[indexPath.row]["name"])!)
        cell?.textLabel?.textColor = self.colors[indexPath.row]
        cell?.detailTextLabel?.text = String(self.chartValues[indexPath.row]["value"]!)
        cell?.detailTextLabel?.textColor = self.colors[indexPath.row]
        return cell!
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        self.tableView.deselectRowAtIndexPath(indexPath, animated: true)
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return chartValues.count
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
    }
    
    deinit {
        
    }
    
}