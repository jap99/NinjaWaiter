//
//  Category.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/14/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class Category {
    
    var uid: String!
    var name: String!
    
    init() {}
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
    
    static func getCategoryList(array: [[String: Any]], arrKey: [String]) -> [Category] {
        
        var categories: [Category] = []
        
        for (_,a) in array.enumerated() {
            
            if let uid = a["uid"] as? String,
                let name = a["name"] as? String {
                let category = Category(uid: uid, name: name)
                categories.append(category)
            }
        }
        return categories
    }
    
    
    static func parseCategoryData(snapshot : DataSnapshot) -> [Category]{
        
        var arrCategory: [Category] = []
        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
            for snap in snapshot {
                let categoryUID = snap.key 
                let categoryName = snap.value as! String
                let category = Category(uid: categoryUID, name: categoryName)
                arrCategory.append(category)
            }
        }
        return arrCategory
    }
}

class CategoryData: NSObject {
    
  //static var arrayOfDictionaries = [[String: [String: AnyObject]]]()
    
    var itemPrice = "", itemName = "", itemImageURL = "", availabilityType = ""
   
  //  init(object: [String: [String: AnyObject]], availabilityType: String) {
        init(object:  [String: [String: [String: [String: AnyObject]]]]) {
    
   //     self.availabilityType = availabilityType
        
//        for (categoryUID, _) in object {
//            
//            for (itemUID, itemDetails) in (object[categoryUID])! {
//                
//                let data: [String: Item] = [
//                    categoryUID: Item(dictionary: itemDetails, itemId: itemUID)
//                ]
//                
//                CategoryData.arrayOfDictionaries.append(data)
//            }
//        }
        
        super.init()
    }
}
