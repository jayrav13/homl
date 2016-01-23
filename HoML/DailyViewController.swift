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
    
    var date : String!
    
    var dailyMatches : JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = date
        
        // set up TableView
        tableView = UITableView(frame: self.view.frame)
        tableView.delegate = self
        tableView.dataSource = self
        tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.view.addSubview(tableView)
        
        dailyMatches = []
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if(dailyMatches.count != 0) {
            return dailyMatches.count
        } else {
            return 1
        }
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        if(dailyMatches.count != 0) {
            cell.textLabel?.text = self.dailyMatches["matches"][indexPath.row]["match"]["number"].stringValue
            cell.detailTextLabel?.text = self.dailyMatches["matches"][indexPath.row]["match"]["bio"].stringValue
        }
        else {
            cell.textLabel?.text = "Test"
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
        return (Standard.screenHeight - 44)/5
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
}
