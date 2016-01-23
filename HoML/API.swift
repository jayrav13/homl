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
    
    static let baseURL = "http://koolaid.ngrok.io/"
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
            "latitude" : latitude,
            "longitude" : longitude,
            "number" : self.number
        ]
        
        Alamofire.request(Method.POST, baseURL + "location", parameters: parameters, encoding: ParameterEncoding.JSON, headers: nil).responseJSON { (response) -> Void in
            
            if(response.response?.statusCode == 200) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
    static func createUser(age : Int, gender : String, bio : String, story : String, completion : (success : Bool, data : JSON) -> Void) -> Void {
        
        let parameters : [String : AnyObject] = [
            "number" : self.number,
            "age" : age,
            "gender" : gender,
            "bio" : bio,
            "story" : story
        ]
        
        Alamofire.request(Method.POST, baseURL + "users", parameters: parameters, encoding: ParameterEncoding.JSON, headers: nil).responseJSON { (response) -> Void in
            
            if(response.response?.statusCode == 200) {
                completion(success: true, data: JSON(response.result.value!))
            }
            else {
                completion(success: false, data: nil)
            }
            
        }
        
    }
    
}