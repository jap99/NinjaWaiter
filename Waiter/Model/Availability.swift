//
//  Availability.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/20/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
 
class Availability {
    
        var dinner = [[String: [[String: [String: AnyObject]]]]]()
        var lunch = [[String: [[String: [String: AnyObject]]]]]()
        var breakfast = [[String: [[String: [String: AnyObject]]]]]()
    
    init(dict: [DataSnapshot]) {
       
        let availabilityData: [DataSnapshot] = dict
        
        for aType in availabilityData { // breakfast, lunch, dinner
            
            let availabilityType = aType.key // breakfast, lunch, dinner
            
            if let categoriesRoot = aType.value as? NSDictionary,
                
                let availabilityCategoriesAndChildren = categoriesRoot.value(forKey: "Categories") as? NSDictionary {
                
                for c in availabilityCategoriesAndChildren {
                    
                    let categoryUID = c.key as! String
                    
                    if let categoryValue = c.value as? NSDictionary,
                        let cItems = categoryValue.value(forKey: "Items") as? NSDictionary {
                        
                        for itemUidObj in cItems {
                            
                            let itemUID = itemUidObj.key as! String
                            
                            if let itemDetailsObject = itemUidObj.value as? NSDictionary,
                                let itemNamePriceURL = itemDetailsObject.value(forKey: "ItemDetails") as? NSDictionary {
                                
                                var availabilityTypeData: [[String: [[String: [String: AnyObject]]]]] = [[String: [[String: [String: AnyObject]]]]]()
                                availabilityTypeData = [[
                                    categoryUID: [[itemUID: itemNamePriceURL as! [String: AnyObject]]]
                                ]]
                                
                                if availabilityType == "Breakfast" {
                                    self.breakfast = availabilityTypeData
                                
                                } else if availabilityType == "Lunch" {
                                    self.lunch = availabilityTypeData
                                
                                } else {
                                    self.dinner = availabilityTypeData
                                }
                            }
                        }
                    }
                }
            }
        }
    }
}



