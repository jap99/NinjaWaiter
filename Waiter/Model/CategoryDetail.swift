//
//  CategoryDetail.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/29/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation

class CategoryDetail {
    
    var categoryId = ""
    var categoryName = ""
    var categoryItemList: [CategoryItems] = [CategoryItems]()
    
    func converFrom(cat: CategoryEntity) {
        
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
