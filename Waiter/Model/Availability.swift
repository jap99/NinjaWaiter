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


class CategoryItems {
    var itemId = ""
    var itemName = ""
    var itemImage = ""
    var itemPrice = ""
    var isSelected = false
    
    func convertFrom(item:ItemCoreData) {
        itemId = item.itemUID
        itemName = item.itemName
        itemImage = item.itemImageURL
        itemPrice = item.strPrice
        
    }
}

class CategoryDetail {
    
    var categoryId = ""
    var categoryName = ""
    var categoryItemList: [CategoryItems] = [CategoryItems]()
    
    func converFrom(cat:CategoryEntity) {
        categoryId = cat.categoryUID
        categoryName = cat.categoryName
        
        var arrItems = [CategoryItems]()
        for item in cat.itemList {
            if item is ItemCoreData {
                let itemObj =  CategoryItems()
                itemObj.convertFrom(item:item as! ItemCoreData)
                arrItems.append(itemObj)
            }
        }
        categoryItemList = arrItems
    }
}

class DataManager: NSObject {
    
    var ref: DatabaseReference!
    
    override init() {
        self.ref = Database.database().reference()
    }
    
    private static var sharedManager: DataManager = {
        let manager = DataManager()
        return manager
    }()
    
    class func shared() -> DataManager {
        return sharedManager
    }
    
    func getCategoryList(order: String,completion: @escaping ([CategoryDetail]) -> Void) {
        
        self.ref.child("Restaurants").child(RESTAURANT_UID).child("Menu").child("Availability").child(order).child("Categories").observe(.value) { (snapshot) in
            
            let response = snapshot.value as? [String: Any] ?? [:]
            
            var arrCategory = [CategoryDetail] ()
            
             for data in response {
                
                let Category = CategoryDetail()
                
                self.getCatName(key: data.key, completion: { (name) in
                
//                let name = self.ref.child("Restaurants").child("-LFabTDx_abAY83Brzrq").child("Menu").child("Category").value(forKey: data.key) as! String
                
                    Category.categoryId = data.key
                    Category.categoryName = name
                    
                    if let cat_dict = data.value as? [String:Any] {
                        
                        for items in cat_dict {
                            
                            if let itemobj = items.value as? [String:Any] {
                                
                                var arrDetail = [CategoryItems]()
                                
                                for item in itemobj {
                                    
                                    if let itemDetail = item.value as? [String:Any] {
                                        
                                        if let Detail = itemDetail["ItemDetails"] as? [String:Any] {
                                            
                                            let CatDetail = CategoryItems()
                                            CatDetail.itemId = item.key
                                            if let img_url = Detail["itemImageURL"] as? String {
                                                
                                                CatDetail.itemImage = img_url
                                                
                                            }
                                            if let name = Detail["itemName"] as? String {
                                                
                                                CatDetail.itemName = name
                                                
                                            }
                                            
                                            if let price = Detail["itemPrice"] as? String {
                                                
                                                CatDetail.itemPrice = price
                                                
                                            }
                                            arrDetail.append(CatDetail)
                                        } 
                                    }
                                }
                                Category.categoryItemList = arrDetail
                            }
                        }
                    }
                    
                    arrCategory.append(Category)
                    
                    if arrCategory.count == response.count {
                        
                        completion(arrCategory)
                    }
                })
            }
        }
    }
    
    func getCatName(key:String,completion: @escaping(String) -> Void) {
        
        var catName = ""
        
        self.ref.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).child(key).observe(.value) { (snapshot) in
            
            let response = snapshot.value as? String
            
            if let cat = response {
                
                catName = cat
            }
            
            completion(catName)
        }
    }
    
}



class Availability {
    
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
                                
                               // let _ = CategoryData(object: dinnerData, availabilityType: availabilityType)
                            }
                        }
                    }
                }
            }
        
        }
    }
}



