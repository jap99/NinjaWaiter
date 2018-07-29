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
    
    var optionList: [ItemOption] = [ItemOption]()
    
    func convertFrom(item:ItemCoreData) {
        itemId = item.itemUID
        itemName = item.itemName
        itemImage = item.itemImageURL
        itemPrice = item.strPrice
        
    }
}


class ItemOption {
    var itemId = ""
    var optionId = ""
    var optionName = ""
    var optionPrice = ""
    var isOptionSelected = false
}

