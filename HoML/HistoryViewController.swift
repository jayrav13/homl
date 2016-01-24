//
//  HistoryViewController.swift
//  HoML
//
//  Created by Jay Ravaliya on 1/23/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class HistoryViewController : UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var meetLabel : UILabel!
    var tableView : UITableView!
    
    var matchDates: JSON!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.title = "History"
        self.view.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        
        // set up meet people label
        self.meetLabel = UILabel()
        self.meetLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.5, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.05)
        self.meetLabel.text = "Pass by some people to see their stories!"
        self.meetLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.meetLabel.adjustsFontSizeToFitWidth = true
        self.meetLabel.textAlignment = NSTextAlignment.Center
        
        // set up TableView
        self.tableView = UITableView(frame: self.view.frame)
        self.tableView.delegate = self
        self.tableView.dataSource = self
        self.tableView.registerClass(UITableViewCell.self, forCellReuseIdentifier: "cell")
        self.tableView.separatorStyle = UITableViewCellSeparatorStyle.None
        self.tableView.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        
        if(matchDates["dates"].count != 0) {
            self.view.addSubview(tableView)
        } else {
            self.view.addSubview(meetLabel)
        }
    }
    
    func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return matchDates["dates"].count
    }
    
    func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell : UITableViewCell = tableView.dequeueReusableCellWithIdentifier("cell")!
        cell = UITableViewCell(style: UITableViewCellStyle.Subtitle, reuseIdentifier: "cell")
        cell.accessoryType = UITableViewCellAccessoryType.DisclosureIndicator
        cell.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        cell.textLabel?.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        if(matchDates.count != 0) {
            cell.textLabel?.text = self.matchDates["dates"][indexPath.row]["date"].stringValue
        }
        return cell
    }
    
    func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        tableView.deselectRowAtIndexPath(indexPath, animated: true)
        let dvc : DailyViewController = DailyViewController()
        dvc.date = self.tableView.cellForRowAtIndexPath(indexPath)?.textLabel!.text
        API.getDateMatches(dvc.date) { (success, data) -> Void in
            dvc.dailyMatches = data
            self.navigationController?.pushViewController(dvc, animated: true)
        }
    }
    
    func tableView(tableView: UITableView, heightForRowAtIndexPath indexPath: NSIndexPath) -> CGFloat {
        return (Standard.screenHeight - 44)/10
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
}
