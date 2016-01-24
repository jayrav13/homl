//
//  API.swift
//  HoML
//
//  Created by Jay Ravaliya on 1/22/16.
//  Copyright © 2016 JRav. All rights reserved.
//

import Foundation
import Alamofire
import SwiftyJSON
import CoreLocation
import UIKit

class API {
    
    static let baseURL = "http://45.79.141.223/"
    static let number = (UIDevice.currentDevice().identifierForVendor?.UUIDString)!
    
    static func getHeartbeat(completion : (success : Bool, data : JSON) -> Void) -> Void {
        
        Alamofire.request(Method.GET, self.baseURL).responseJSON { (response) -> Void in
            
            if(response.response?.statusCode == 200) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
    static func sendLocation(latitude : CLLocationDegrees, longitude : CLLocationDegrees, completion : (success : Bool, data : JSON) -> Void) -> Void {
        
        let parameters : [String : AnyObject] = [
            "lat" : latitude,
            "long" : longitude,
            "user_id" : self.number
        ]
        
        Alamofire.request(Method.POST, baseURL + "locations", parameters: parameters, encoding: ParameterEncoding.JSON, headers: nil).responseJSON { (response) -> Void in
            
            if(response.response?.statusCode == 200) {
                // print("\(latitude),\(longitude)")
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
    static func createUser(age : Int, gender : String, bio : String, story : String, username : String, completion : (success : Bool, data : JSON) -> Void) -> Void {
        
        var parameters : [String : AnyObject] = [
            "number" : self.number,
            "age" : age,
            "gender" : gender,
            "bio" : bio,
            "story" : story
        ]
        
        if(username.characters.count > 0) {
            parameters["username"] = username
        }
        
        Alamofire.request(Method.POST, baseURL + "users", parameters: parameters, encoding: ParameterEncoding.JSON, headers: nil).responseJSON { (response) -> Void in
            
            if(response.response?.statusCode == 200) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
    static func getMatches(completion : (success : Bool, data : JSON) -> Void) -> Void {
        
        Alamofire.request(Method.GET, baseURL + "match/" + self.number).responseJSON { (response) -> Void in
            
            if(response.result.isSuccess) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
    static func getUser(completion : (success : Bool, data : JSON) -> Void) -> Void {
        
        /*let parameters : [String : AnyObject] = [
            "number" : self.number
        ]*/
        
        /*Alamofire.request(Method.GET, self.baseURL + "users", parameters: parameters, encoding: ParameterEncoding.JSON, headers: nil).responseJSON { (response) -> Void in
            
            if(response.response?.statusCode == 200) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }*/
        
        Alamofire.request(Method.GET, self.baseURL + "users").responseJSON { (response) -> Void in
            
            if(response.response?.statusCode == 200) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
    static func getDates(completion : (success : Bool, data : JSON) -> Void) -> Void {
        
        Alamofire.request(Method.GET, baseURL + "match/" + self.number + "?dates").responseJSON { (response) -> Void in
            
            if(response.result.isSuccess) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
    static func getDateMatches(date: String, completion : (success : Bool, data : JSON) -> Void) -> Void {
        
        Alamofire.request(Method.GET, baseURL + "match/" + self.number + "?date=" + date).responseJSON { (response) -> Void in
            
            if(response.result.isSuccess) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
}

class Standard {
    
    static let screenHeight = UIScreen.mainScreen().bounds.height
    static let screenWidth = UIScreen.mainScreen().bounds.width
    
}

class NSAPI {
    
    static func getProfileAddedSetting() -> Bool {
        return (NSUserDefaults.standardUserDefaults().boolForKey("profileSet"))
    }
    
    static func setProfileAddedSetting(setting : Bool) {
        NSUserDefaults.standardUserDefaults().setBool(setting, forKey: "profileSet")
    }
    
    static func getUserName() -> String {
        return NSUserDefaults.standardUserDefaults().stringForKey("username")!
    }
    
    static func setUserName(username : String) {
        NSUserDefaults.standardUserDefaults().setObject(username, forKey: "username")
    }
    
}