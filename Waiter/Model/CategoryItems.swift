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
    
    func copyObject() -> CategoryItems {
        var categoryItems = CategoryItems()
        categoryItems.itemId = itemId
        categoryItems.itemName = itemName
        categoryItems.itemImage = itemImage
        categoryItems.itemPrice = itemPrice
        categoryItems.isSelected = true
        
        for option in optionList {
            if option.isOptionSelected {
                var item = ItemOption()
                item.itemId = option.itemId
                item.optionId = option.optionId
                item.optionName = option.optionName
                item.optionPrice = option.optionPrice
                item.isOptionSelected = true
                categoryItems.optionList.append(item)
            }
        }
        
        return categoryItems
    }
    
}


class ItemOption {
    var itemId = ""
    var optionId = ""
    var optionName = ""
    var optionPrice = ""
    var isOptionSelected = false
}

