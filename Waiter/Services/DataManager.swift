//
//  DataManager.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/29/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

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
