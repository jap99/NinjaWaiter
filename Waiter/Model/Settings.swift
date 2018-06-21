
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
    
    var adminEmail: String!
    var startingNumber: String!
    var endingNumber: String!
    var restaurantName: String!
    var totalTable: Int!
    
    var discount: Int?
    var serviceCharge: Int?
    var tax1String: String?
    var tax1Int: Int?
    var tax2String: String?
    var tax2Int: Int?
    
    init() {}
    
    init(adminEmail: String, startingNumber: String, endingNumber: String, restaurantName: String) {
        
        self.adminEmail = adminEmail
        self.startingNumber = startingNumber
        self.endingNumber = endingNumber
        self.restaurantName = restaurantName
        if let startingNumber = Int(startingNumber), let endingNumber = Int(endingNumber) {
            self.totalTable = endingNumber - startingNumber
        }
    }
    
     static func parseSettingData(snapshot: DataSnapshot) -> [Settings] {
        
        var arrSetting: [Settings] = []
        
        if let snap = snapshot.value as? [String: AnyObject] {
            if let restAdminEmail = snap["adminEmail"] as? String,
            let restaurantName = snap["restaurantName"] as? String,
            let tableStartNumber = snap["tableStartNumber"] as? String,
                let tableEndNumber = snap["tableEndNumber"] as? String /*,
            let discount = snap["discountText"] as? String,
            let serviceCharge = snap["serviceChargeText"] as? String,
            let tax1Name = snap["tax1NameText"] as? String,
            let tax1Percent = snap["taxPercentage1NameText"] as? String,
            let tax2Name = snap["tax2NameText"] as? String,
            let tax2Percent = snap["taxPercentage2NameText"] as? String*/ {
                
                let setting = Settings(adminEmail: restAdminEmail, startingNumber: tableStartNumber, endingNumber: tableEndNumber, restaurantName: restaurantName)
                arrSetting.append(setting)
            }
             
        }
        return arrSetting
    }
    
    
    
    
}
