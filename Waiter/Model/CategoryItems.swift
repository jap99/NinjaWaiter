//
//  CategoryItems.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/29/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation

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
