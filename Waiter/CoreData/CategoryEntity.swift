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
}


class CategoryEntity: NSManagedObject, ParentManagedObject {
    
    @NSManaged var categoryUID:String
    @NSManaged var categoryName:String
    @NSManaged var itemUID:String
    @NSManaged var categroyType:String
    @NSManaged var breakfastRelationship:Breakfast?
    @NSManaged var lunchRelationship:Lunch?
    @NSManaged var dinnerRelationship:Dinner?
    
    func updateWith(cat:CategoryDetail,type:CategoryType) {
        categoryUID = cat.categoryId
        categoryName = cat.categoryName
        categroyType = type.rawValue
    }
    
}
