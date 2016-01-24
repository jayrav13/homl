//
//  DailyViewController.swift
//  HoML
//
//  Created by Alec Huang on 1/23/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class DailyViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var tableView : UITableView!
    var dailySummaryButton : UIButton!
    
    var date : String!
    
    var dailyMatches : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = date
        self.view.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        
        self.dailySummaryButton = UIButton()
        self.dailySummaryButton.frame = CGRect(x: Standard.screenWidth * 0.34, y: Standard.screenHeight * 0.125, width: Standard.screenWidth * 0.32, height: Standard.screenHeight * 0.05)
        self.dailySummaryButton.backgroundColor = UIColor(red: 220/255, green: 240/255, blue: 220/255, alpha: 1)
        self.dailySummaryButton.setTitle("DAILY SUMMARY", forState: UIControlState.Normal)
        self.dailySummaryButton.setTitleColor(UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1), forState: UIControlState.Normal)
        self.dailySummaryButton.titleLabel?.font = UIFont(name: "OpenSans-Semibold", size: 14)
        self.dailySummaryButton.layer.cornerRadius = 5
        self.dailySummaryButton.layer.masksToBounds = true
        self.dailySummaryButton.layer.borderWidth = 1
        self.dailySummaryButton.layer.borderColor = UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1).CGColor
        self.dailySummaryButton.addTarget(self, action: "pushToDailySummaryViewController:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.dailySummaryButton)
        
        // set up TableView
        self.tableView = UITableView()
        self.tableView.frame = CGRect(x: 0, y: Standard.screenHeight * 0.2, width: Standard.screenWidth, height: Standard.screenHeight * 0.8)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        self.view.addSubview(self.tableView)
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return dailyMatches["matches"].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        cell.textLabel?.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        if(dailyMatches.count != 0) {
            cell.textLabel?.text = self.dailyMatches["matches"][indexPath.row]["match"]["bio"].stringValue
        }
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let mdvc : MatchDetailsViewController = MatchDetailsViewController()
        mdvc.matchData = self.dailyMatches["matches"][indexPath.row]
        self.navigationController?.pushViewController(mdvc, animated: true)
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (Standard.screenHeight - 44)/10
    }
    
    func pushToDailySummaryViewController(sender : UIButton) {
        let dsvc : DailySummaryViewController = DailySummaryViewController()
        dsvc.date = self.date
        dsvc.dailyMatches = self.dailyMatches
        self.navigationController?.pushViewController(dsvc, animated: true)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
