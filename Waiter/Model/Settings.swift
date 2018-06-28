
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
    
    static var shared = Settings()
    
    var adminEmail: String!
    var startingNumber: Int?
    var endingNumber: Int?
    var restaurantName: String!
    var totalTable = 0
    
    var discount: Int?
    var serviceCharge: Int?
    var tax1Name: String?
    var tax1Percent: Int?
    var tax2Name: String?
    var tax2Percent: Int?
    
    init() {}
    
    
    
    init(adminEmail: String, startingNumber: Int?, endingNumber: Int?, restaurantName: String, discount: Int?, serviceCharge: Int?, tax1Name: String?, tax2Name: String?, tax1Percent: Int?, tax2Percent: Int?) {
        
        self.adminEmail = adminEmail; self.restaurantName = restaurantName
        
        if let startingNumber = startingNumber, let endingNumber = endingNumber { self.totalTable = endingNumber - startingNumber + 1 }
        if let discount = discount { self.discount = discount }
        if let serviceCharge = serviceCharge { self.serviceCharge = serviceCharge }
        if let tax1Name = tax1Name, let tax1Percent = tax1Percent { self.tax1Name = tax1Name; self.tax1Percent = tax1Percent }
        if let tax2Name = tax2Name, let tax2Percent = tax2Percent { self.tax2Name = tax2Name; self.tax2Percent = tax2Percent }
    }
    
    
    
     func parseSettingData(snapshot: DataSnapshot) -> [Settings] {
        
        var arrSetting: [Settings] = []
        
        if let snap = snapshot.value as? [String: AnyObject] {
           
            if let restAdminEmail = snap["adminEmail"] as? String, let restaurantName = snap["restaurantName"] as? String {
                
                let settings = Settings()
                
                if let discount = snap["discountText"] as? String { settings.discount = Int(discount) }
                if let serviceCharge = snap["serviceChargeText"] as? String { settings.serviceCharge = Int(serviceCharge) }
                if let tax1Name = snap["tax1NameText"] as? String { settings.tax1Name = tax1Name }
                if let tax1Percent = snap["taxPercentage1NameText"] as? String { settings.tax1Percent = Int(tax1Percent) }
                if let tax2Name = snap["tax2NameText"] as? String { settings.tax2Name = tax2Name }
                if let tax2Percent = snap["taxPercentage2NameText"] as? String { settings.tax2Percent = Int(tax2Percent) }
                
                if let tableStartNumber = snap["tableStartNumber"] as? String, let tableEndNumber = snap["tableEndNumber"] as? String {
                    settings.startingNumber = Int(tableStartNumber); settings.endingNumber = Int(tableEndNumber);
                }
                
                let setting = Settings(adminEmail: restAdminEmail,
                                       startingNumber: settings.startingNumber,
                                       endingNumber: settings.endingNumber,
                                       restaurantName: restaurantName,
                                       discount: settings.discount,
                                       serviceCharge: settings.serviceCharge,
                                       tax1Name: settings.tax1Name,
                                       tax2Name: settings.tax2Name,
                                       tax1Percent: settings.tax1Percent,
                                       tax2Percent: settings.tax2Percent
                )
                
                arrSetting.append(setting)
            }
        }
        return arrSetting
    }
}
