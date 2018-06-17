
//
//  Settings.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/17/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation

import Firebase
import FirebaseDatabase

class Settings {
    
    var adminEmail : String!
    var startingNumber : String!
    var endingNumber : String!
    var restaurantName: String!
    
    init() {}
    
    init(adminEmail: String, startingNumber: String, endingNumber: String, restaurantName:String) {
        self.adminEmail = adminEmail
        self.startingNumber = startingNumber
        self.endingNumber = endingNumber
        self.restaurantName = restaurantName
    }
    
     static func parseSettingData(snapshot : DataSnapshot) -> [Settings] {
        
        var arrSetting : [Settings] = []
        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
            let restAadminEmail = snapshot[0].value as! String
            let restaurantName = snapshot[1].value as! String
            let tableStartNumber = snapshot[3].value as! String
            let tableEndNumber = snapshot[2].value as! String
            
                let setting = Settings(adminEmail: restAadminEmail, startingNumber: tableStartNumber, endingNumber: tableEndNumber, restaurantName: restaurantName)
                arrSetting.append(setting)
            
        }
        return arrSetting
    }
    
    
    
    
}
