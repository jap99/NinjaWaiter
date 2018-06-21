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
    
//    var lunch: [String: NSDictionary]!
//    var breakfast: [String: NSDictionary]!
//    var dinner: [String: NSDictionary]!
    
    var dinner: [CategoryData] = []
    var lunch: [CategoryData] = []
    var breakfast: [CategoryData] = []
    
    
    init(dict:[DataSnapshot]) {
        
        for snap in dict {
           
            if snap.key == "Dinner", let value = snap.value as? NSDictionary, let category = value.value(forKey: "Categories") as? NSDictionary
            {
                for cate in category {
                    if let category1 = cate.value as? NSDictionary, let items = category1.value(forKey: "Items") as? NSDictionary {
                        for item  in items {
                            if let itemValues = item.value as? NSDictionary, let itemDetails = itemValues.value(forKey: "ItemDetails") as? NSDictionary {
                                let obj = CategoryData(object: itemDetails)
                                self.dinner.append(obj)
                            }
                        }
                    }
                }
            }
            
            if snap.key == "Lunch", let value = snap.value as? NSDictionary, let category = value.value(forKey: "Categories") as? NSDictionary
            {
                    for cate in category {
                        if let category1 = cate.value as? NSDictionary, let items = category1.value(forKey: "Items") as? NSDictionary {

                        for item  in items {
                            if let itemValues = item.value as? NSDictionary, let itemDetails = itemValues.value(forKey: "ItemDetails") as? NSDictionary {
                                let obj = CategoryData(object: itemDetails)
                                self.lunch.append(obj)
                                }
                            }
                        }
                    }
                }
            
                if snap.key == "Breakfast", let value = snap.value as? NSDictionary, let category = value.value(forKey: "Categories") as? NSDictionary {
                        for cate in category {
                            if let category1 = cate.value as? NSDictionary, let items = category1.value(forKey: "Items") as? NSDictionary {

                                for item  in items {
                                    if let itemValues = item.value as? NSDictionary, let itemDetails = itemValues.value(forKey: "ItemDetails") as? NSDictionary {
                                        let obj = CategoryData(object: itemDetails)
                                        self.breakfast.append(obj)
                                    }
                                }
                            }
                        }
                    }
            
            }
    }
}
class CategoryData: NSObject {
    var
    itemPrice = "",
    itemName = "",
    itemImageURL = ""
    init(object : NSDictionary) {
        if let itemPrice = object.value(forKey: "itemPrice") as? String {
            self.itemPrice = itemPrice
        }
        if let itemName = object.value(forKey: "itemName") as? String {
            self.itemName = itemName
        }
        if let itemImageURL = object.value(forKey: "itemImageURL") as? String {
            self.itemImageURL = itemImageURL
        }
        
        super.init()
    }
}


