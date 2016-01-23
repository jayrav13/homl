//
//  ProfileViewController.swift
//  HoML
//
//  Created by Jay Ravaliya on 1/23/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import Foundation
import UIKit
import SwiftyJSON

class ProfileViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    
    var username : String!
    var userData : JSON!
    var usernameTextField : UITextField!
    var usernameTextLabel : UILabel!
    
    var saveBarButtonItem : UIBarButtonItem!
    
    var genderTextLabel : UILabel!
    var genderSegmentedControl : UISegmentedControl!
    
    var ageTextLabel : UILabel!
    var ageSelectionButton : UIButton!
    var ageSelectionPickerView : UIPickerView!
    var ageSelectionPickerViewIsShowing : Bool!
    
    var bioTextLabel : UILabel!
    var bioTextField : UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor.whiteColor()
        self.title = "Profile"
        
        self.saveBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveButtonPressed:")
        self.navigationItem.rightBarButtonItem = self.saveBarButtonItem
        
        let usernameRect : CGRect = CGRect(x: Standard.screenWidth * 0.25, y: Standard.screenHeight * 0.20, width: Standard.screenWidth * 0.50, height: Standard.screenHeight * 0.05)
        
        if(NSAPI.getProfileAddedSetting()) {
            self.usernameTextLabel = UILabel()
            self.usernameTextLabel.frame = usernameRect
            self.usernameTextLabel.text = self.username
            self.view.addSubview(self.usernameTextLabel)
        }
        else {
            self.usernameTextField = UITextField()
            self.usernameTextField.frame = usernameRect
            self.usernameTextField.placeholder = "username"
            self.usernameTextField.borderStyle = UITextBorderStyle.RoundedRect
            self.usernameTextField.textAlignment = NSTextAlignment.Center
            self.view.addSubview(self.usernameTextField)
        }
        
        self.genderTextLabel = UILabel()
        self.genderTextLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.30, width: Standard.screenWidth * 0.3, height: Standard.screenHeight * 0.05)
        self.genderTextLabel.text = "Gender"
        self.genderTextLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.genderTextLabel)
        
        self.genderSegmentedControl = UISegmentedControl(items: ["M","F","O"])
        self.genderSegmentedControl.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.40, width: Standard.screenWidth * 0.3, height: Standard.screenHeight * 0.05)
        self.view.addSubview(self.genderSegmentedControl)
        
        self.ageTextLabel = UILabel()
        self.ageTextLabel.frame = CGRect(x: Standard.screenWidth * 0.6, y: Standard.screenHeight * 0.30, width: Standard.screenWidth * 0.3, height: Standard.screenHeight * 0.05)
        self.ageTextLabel.text = "Age"
        self.ageTextLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.ageTextLabel)
        
        self.ageSelectionButton = UIButton(type: UIButtonType.System)
        self.ageSelectionButton.frame = CGRect(x: Standard.screenWidth * 0.6, y: Standard.screenHeight * 0.40, width: Standard.screenWidth * 0.3, height: Standard.screenHeight * 0.05)
        self.ageSelectionButton.setTitle("Select...", forState: UIControlState.Normal)
        self.ageSelectionButton.addTarget(self, action: "ageSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        self.view.addSubview(self.ageSelectionButton)
        
        self.ageSelectionPickerView = UIPickerView()
        self.ageSelectionPickerView.frame = CGRect(x: 0, y: Standard.screenHeight, width: Standard.screenWidth, height: 216)
        self.ageSelectionPickerView.dataSource = self
        self.ageSelectionPickerView.delegate = self
        self.ageSelectionPickerView.backgroundColor = UIColor.whiteColor()
        self.ageSelectionPickerView.alpha = 1.0
        self.ageSelectionPickerView.opaque = false
        self.view.addSubview(self.ageSelectionPickerView)
        
        self.ageSelectionPickerViewIsShowing = false
        
        self.bioTextLabel = UILabel()
        self.bioTextLabel.frame = CGRect(x: 0, y: Standard.screenHeight * 0.5, width: Standard.screenWidth, height: Standard.screenHeight * 0.05)
        self.bioTextLabel.text = "tell the world about yourself."
        self.bioTextLabel.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.bioTextLabel)
        
        self.bioTextField = UITextField()
        self.bioTextField.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.55, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.05)
        self.bioTextField.placeholder = "bio"
        self.bioTextField.textAlignment = NSTextAlignment.Center
        self.view.addSubview(self.bioTextField)
        
        if(userData != nil) {
            // SOMETHING
        }
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.ageSelectionPickerView.frame = CGRect(x: 0, y: Standard.screenHeight, width: Standard.screenWidth, height: 216)
            
            }) { (myBool : Bool) -> Void in
                
                self.ageSelectionPickerViewIsShowing = false
                
        }
    }
    
    func saveButtonPressed(sender : UIButton) {
        if(NSAPI.getProfileAddedSetting()) {
            // Editing
        }
        else {
            if((usernameTextField.text?.characters.count) > 0) {
                NSAPI.setProfileAddedSetting(true)
                
                let pickerValues = ["M", "F", "O"]
                
                API.createUser(Int((self.ageSelectionButton.titleLabel?.text)!)!, gender: pickerValues[self.genderSegmentedControl.selectedSegmentIndex], bio: self.bioTextField.text!, story: "pending", completion: { (success, data) -> Void in
                    
                    if(success) {
                        self.navigationController?.popToRootViewControllerAnimated(true)
                    }
                    else {
                        // Error
                    }
                    
                })
            }
            else {
                // Error
            }
        }
        
    }
    
    func ageSelected(sender : UIButton) {
        if(sender.titleLabel?.text == "Select...") {
            sender.setTitle("18", forState: UIControlState.Normal)
        }
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.ageSelectionPickerView.frame = CGRect(x: 0, y: Standard.screenHeight - 216, width: Standard.screenWidth, height: 216)
            
            }) { (myBool : Bool) -> Void in
                
                // self.pickerViewIsVisible = true
                
        }
    }
    
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return 85
    }
    
    func pickerView(pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return String(row + 18)
    }
    
    func pickerView(pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        self.ageSelectionButton.setTitle(String(row + 18), forState: UIControlState.Normal)
    }
    
}
