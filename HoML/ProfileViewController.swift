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

class ProfileViewController : UIViewController, UIPickerViewDataSource, UIPickerViewDelegate, UITextFieldDelegate {
    
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
    
    var storyTextLabel : UILabel!
    var storyTextField : UITextField!
    
    var containerView : UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = UIColor(red: 59/255, green: 75/255, blue: 56/255, alpha: 1)
        self.title = "Profile"
        self.containerView = UIView(frame: self.view.frame)
        
        self.saveBarButtonItem = UIBarButtonItem(title: "Save", style: UIBarButtonItemStyle.Plain, target: self, action: "saveButtonPressed:")
        self.navigationItem.rightBarButtonItem = self.saveBarButtonItem
        
        let usernameRect : CGRect = CGRect(x: Standard.screenWidth * 0.25, y: Standard.screenHeight * 0.15, width: Standard.screenWidth * 0.50, height: Standard.screenHeight * 0.05)
        
        self.genderTextLabel = UILabel()
        self.genderTextLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.2, width: Standard.screenWidth * 0.3, height: Standard.screenHeight * 0.05)
        self.genderTextLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.genderTextLabel.text = "Gender"
        self.genderTextLabel.textAlignment = NSTextAlignment.Center
        self.containerView.addSubview(self.genderTextLabel)
        
        self.genderSegmentedControl = UISegmentedControl(items: ["M","F","O"])
        self.genderSegmentedControl.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.25, width: Standard.screenWidth * 0.3, height: Standard.screenHeight * 0.05)
        self.genderSegmentedControl.tintColor = UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)
        self.genderSegmentedControl.backgroundColor = UIColor(red: 220/255, green: 240/255, blue: 220/255, alpha: 1)
        self.genderSegmentedControl.layer.masksToBounds = true
        self.genderSegmentedControl.layer.cornerRadius = 5
        self.containerView.addSubview(self.genderSegmentedControl)
        
        self.ageTextLabel = UILabel()
        self.ageTextLabel.frame = CGRect(x: Standard.screenWidth * 0.6, y: Standard.screenHeight * 0.2, width: Standard.screenWidth * 0.3, height: Standard.screenHeight * 0.05)
        self.ageTextLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.ageTextLabel.text = "Age"
        self.ageTextLabel.textAlignment = NSTextAlignment.Center
        self.containerView.addSubview(self.ageTextLabel)
        
        self.ageSelectionButton = UIButton(type: UIButtonType.System)
        self.ageSelectionButton.frame = CGRect(x: Standard.screenWidth * 0.65, y: Standard.screenHeight * 0.25, width: Standard.screenWidth * 0.2, height: Standard.screenHeight * 0.05)
        self.ageSelectionButton.setTitle("Select...", forState: UIControlState.Normal)
        self.ageSelectionButton.backgroundColor = UIColor(red: 220/255, green: 240/255, blue: 220/255, alpha: 1)
        self.ageSelectionButton.layer.borderWidth = 1
        self.ageSelectionButton.layer.cornerRadius = 5
        self.ageSelectionButton.layer.borderColor = UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1).CGColor
        self.ageSelectionButton.tintColor = UIColor(red: 57/255, green: 181/255, blue: 74/255, alpha: 1)
        self.ageSelectionButton.addTarget(self, action: "ageSelected:", forControlEvents: UIControlEvents.TouchUpInside)
        self.containerView.addSubview(self.ageSelectionButton)
        

        
        self.bioTextLabel = UILabel()
        self.bioTextLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.4, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.05)
        self.bioTextLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.bioTextLabel.text = "Tell us about yourself"
        self.containerView.addSubview(self.bioTextLabel)
        
        self.bioTextField = UITextField()
        self.bioTextField.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.45, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.05)
        self.bioTextField.backgroundColor = UIColor(red: 220/255, green: 240/255, blue: 220/255, alpha: 1)
        self.bioTextField.placeholder = "40 characters max"
        self.bioTextField.delegate = self
        self.bioTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.containerView.addSubview(self.bioTextField)
        
        self.storyTextLabel = UILabel()
        self.storyTextLabel.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.55, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.05)
        self.storyTextLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
        self.storyTextLabel.text = "Tell us a story"
        self.containerView.addSubview(self.storyTextLabel)
        
        self.storyTextField = UITextField()
        self.storyTextField.frame = CGRect(x: Standard.screenWidth * 0.1, y: Standard.screenHeight * 0.6, width: Standard.screenWidth * 0.8, height: Standard.screenHeight * 0.3)
        self.storyTextField.backgroundColor = UIColor(red: 220/255, green: 240/255, blue: 220/255, alpha: 1)
        self.storyTextField.placeholder = "Hear me roar!"
        self.storyTextField.textAlignment = NSTextAlignment.Center
        self.storyTextField.delegate = self
        self.storyTextField.borderStyle = UITextBorderStyle.RoundedRect
        self.containerView.addSubview(self.storyTextField)
        
        self.ageSelectionPickerView = UIPickerView()
        self.ageSelectionPickerView.frame = CGRect(x: 0, y: Standard.screenHeight, width: Standard.screenWidth, height: 216)
        self.ageSelectionPickerView.dataSource = self
        self.ageSelectionPickerView.delegate = self
        self.ageSelectionPickerView.backgroundColor = UIColor.whiteColor()
        self.ageSelectionPickerView.alpha = 1.0
        self.ageSelectionPickerView.opaque = false
        self.containerView.addSubview(self.ageSelectionPickerView)
        
        self.ageSelectionPickerViewIsShowing = false
        
        if(userData != nil) {
            // SOMETHING
        }
        
        if(NSAPI.getProfileAddedSetting()) {
            self.usernameTextLabel = UILabel()
            self.usernameTextLabel.frame = usernameRect
            self.usernameTextLabel.text = "Hello, " + self.userData["username"].stringValue
            self.usernameTextLabel.textAlignment = NSTextAlignment.Center
            self.usernameTextLabel.textColor = UIColor(red: 151/255, green: 189/255, blue: 142/255, alpha: 1)
            self.containerView.addSubview(self.usernameTextLabel)
            
            let pickerValues = ["M","F","O"]
            self.genderSegmentedControl.selectedSegmentIndex = pickerValues.indexOf(self.userData["gender"].stringValue)!
            self.ageSelectionPickerView.selectRow(Int(self.userData["age"].doubleValue) - 18, inComponent: 0, animated: true)
            self.ageSelectionButton.setTitle(String(Int(self.userData["age"].doubleValue)), forState: UIControlState.Normal)
            self.bioTextField.text = self.userData["bio"].stringValue
            self.storyTextField.text = self.userData["story"].stringValue
        }
        else {
            self.usernameTextField = UITextField()
            self.usernameTextField.frame = usernameRect
            self.usernameTextField.placeholder = "username"
            self.usernameTextField.borderStyle = UITextBorderStyle.RoundedRect
            self.usernameTextField.textAlignment = NSTextAlignment.Center
            self.containerView.addSubview(self.usernameTextField)
        }
        
        
        
        self.view.addSubview(self.containerView)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func touchesBegan(touches: Set<UITouch>, withEvent event: UIEvent?) {
        self.view.endEditing(true)
        self.hidePickerView()
    }
    
    func hidePickerView() {
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.ageSelectionPickerView.frame = CGRect(x: 0, y: Standard.screenHeight, width: Standard.screenWidth, height: 216)
            
            }) { (myBool : Bool) -> Void in
                
                self.ageSelectionPickerViewIsShowing = false
                
        }
    }
    
    func showPickerView() {
        UIView.animateWithDuration(0.4, delay: 0.0, options: UIViewAnimationOptions.CurveEaseIn, animations: { () -> Void in
            
            self.ageSelectionPickerView.frame = CGRect(x: 0, y: Standard.screenHeight - 216, width: Standard.screenWidth, height: 216)
            
            }) { (myBool : Bool) -> Void in
                
                self.ageSelectionPickerViewIsShowing = true
                
        }
    }
    
    func saveButtonPressed(sender : UIButton) {
        if(NSAPI.getProfileAddedSetting()) {
            let pickerValues = ["M", "F", "O"]
            API.createUser(Int((self.ageSelectionButton.titleLabel?.text)!)!, gender: pickerValues[self.genderSegmentedControl.selectedSegmentIndex], bio: self.bioTextField.text!, story: self.storyTextField.text!, username : "", completion: { (success, data) -> Void in
                
                if(success) {
                    self.navigationController?.popToRootViewControllerAnimated(true)
                }
                else {
                    // Error
                }
                
            })
        }
        else {
            if((usernameTextField.text?.characters.count) > 0) {
                NSAPI.setProfileAddedSetting(true)
                
                let pickerValues = ["M", "F", "O"]
                
                API.createUser(Int((self.ageSelectionButton.titleLabel?.text)!)!, gender: pickerValues[self.genderSegmentedControl.selectedSegmentIndex], bio: self.bioTextField.text!, story: self.storyTextField.text!, username : self.usernameTextField.text!, completion: { (success, data) -> Void in
                    
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
        self.showPickerView()
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
    
    var frame : CGRect!
    
    func textFieldDidBeginEditing(textField: UITextField) {
        
        print("Begin!")
        if(self.ageSelectionPickerViewIsShowing == true) {
            self.hidePickerView()
        }
        
    }
    
    func textFieldDidEndEditing(textField: UITextField) {
        print("End!")
        self.containerView.frame = self.view.frame
    }
    
    func keyboardWillShow(notification: NSNotification) {
        
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.containerView.frame.origin.y -= keyboardSize.height
        }
        
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if let keyboardSize = (notification.userInfo?[UIKeyboardFrameBeginUserInfoKey] as? NSValue)?.CGRectValue() {
            self.containerView.frame.origin.y += keyboardSize.height
        }
    }
    
}
