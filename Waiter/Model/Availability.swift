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
    
    
    //    var categoryArray: [[String: [Item]]]
        var dinner = [[String: [[String: [String: AnyObject]]]]]()
        var lunch = [[String: [[String: [String: AnyObject]]]]]()
        var breakfast = [[String: [[String: [String: AnyObject]]]]]()
    
    init(dict: [DataSnapshot]) {
       
        let availabilityData: [DataSnapshot] = dict
        
        for aType in availabilityData { // breakfast, lunch, dinner
            
            print(aType)
            
            let availabilityType = aType.key // breakfast, lunch, dinner
            
            if let categoriesRoot = aType.value as? NSDictionary,
                
                let availabilityCategoriesAndChildren = categoriesRoot.value(forKey: "Categories") as? NSDictionary {
             
                print(availabilityCategoriesAndChildren)
                
                for c in availabilityCategoriesAndChildren {
                    
                    let categoryUID = c.key as! String
                    
                    if let categoryValue = c.value as? NSDictionary,
                        let cItems = categoryValue.value(forKey: "Items") as? NSDictionary {
                       
                        print(cItems)
                        
                        for itemUidObj in cItems {
                            
                            let itemUID = itemUidObj.key as! String
                            print(itemUidObj)
                            
                            if let itemDetailsObject = itemUidObj.value as? NSDictionary,
                                let itemNamePriceURL = itemDetailsObject.value(forKey: "ItemDetails") as? NSDictionary {
                                print(itemNamePriceURL)
                                print(itemDetailsObject)
                                
                                // ie. ["Breakfast": [categoryUID: [itemUID: itemDetails]]]
                                let availabilityTypeData: [[String: [[String: [String: AnyObject]]]]] = [[
                                    categoryUID: [[itemUID: itemNamePriceURL as! [String: AnyObject]]]
                                ]]
                                
                                if availabilityType == "Breakfast" {
                                    self.breakfast = availabilityTypeData
                                } else if availabilityType == "Lunch" {
                                    self.lunch = availabilityTypeData
                                } else {
                                    self.dinner = availabilityTypeData
                                }
                                
                               // let _ = CategoryData(object: dinnerData, availabilityType: availabilityType)
                            }
                        }
                    }
                }
            }
            
            //            if snap.key == "Lunch", let value = snap.value as? NSDictionary, let category = value.value(forKey: "Categories") as? NSDictionary {
            //                for cate in category {
            //                    let categoryUID = cate.key as! String
            //                    if let category1 = cate.value as? NSDictionary, let items = category1.value(forKey: "Items") as? NSDictionary {
            //
            //                        for item  in items {
            //                            let itemUID = item.key as! String
            //                            if let itemValues = item.value as? NSDictionary, let itemDetails = itemValues.value(forKey: "ItemDetails") as? NSDictionary {
            //
            //                                let itemData: [String: AnyObject] = [
            //                                    itemUID: itemDetails as AnyObject
            //                                ]
            //
            //                                let lunchData: [String: [String: AnyObject]] = [
            //                                    categoryUID: itemData
            //                                ]
            //
            //                                let _ = CategoryData(object: lunchData, availabilityType: "Lunch")
            //                            }
            //                        }
            //                    }
            //                }
            //            }
            //
            //            if snap.key == "Breakfast", let value = snap.value as? NSDictionary, let category = value.value(forKey: "Categories") as? NSDictionary {
            //
            //                for cate in category {
            //
            //                    let categoryUID = cate.key as! String
            //
            //                    if let category1 = cate.value as? NSDictionary, let items = category1.value(forKey: "Items") as? NSDictionary {
            //
            //                        for item  in items {
            //                            let itemUID = item.key as! String
            //                            if let itemValues = item.value as? NSDictionary, let itemDetails = itemValues.value(forKey: "ItemDetails") as? NSDictionary {
            //
            //                                let itemData: [String: AnyObject] = [
            //                                    itemUID: itemDetails as AnyObject
            //                                ]
            //
            //                                let breakfastData: [String: [String: AnyObject]] = [
            //                                    categoryUID: itemData
            //                                ]
            //
            //                                let _ = CategoryData(object: breakfastData, availabilityType: "Breakfast")
            //
            //                            }
            //                        }
            //                    }
            //                }
            //            }
        }
    }
}



