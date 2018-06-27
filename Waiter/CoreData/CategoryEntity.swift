//
//  Category.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/26/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import CoreData

enum CategoryType:String {
    case lunch = "Lunch"
    case dinner = "Dinner"
    case breakfast = "Breakfast"
    case none = "none"
    
    static func getType(raw:Int) -> CategoryType {
        switch raw {
        case 0:
            return CategoryType.breakfast
        case 1:
            return CategoryType.lunch
        case 2:
            return CategoryType.dinner
        default:
            return CategoryType.none
        }
    }
}


class CategoryEntity: NSManagedObject, ParentManagedObject {
    
    @NSManaged var categoryUID:String
    @NSManaged var categoryName:String
    @NSManaged var itemUID:String
    @NSManaged var categroyType:String
    @NSManaged var itemList:NSSet
    
    
    func updateWith(cat:CategoryDetail,type:CategoryType) {
        categoryUID = cat.categoryId
        categoryName = cat.categoryName
        categroyType = type.rawValue
        
        var arrItems = [ItemCoreData]()
        for item in cat.categoryItemList {
            let newItem = ItemCoreData.createNewEntity(key:"itemUID", value:item.itemId as NSString)
            newItem.updateWith(item:item)
            newItem.categoryUID = cat.categoryId
            newItem.category = self
            arrItems.append(newItem)
            //print(newItem.itemName, newItem.itemUID)
        }
        itemList = NSSet(array:arrItems)
        _appDel.saveContext()
    }
    
}
