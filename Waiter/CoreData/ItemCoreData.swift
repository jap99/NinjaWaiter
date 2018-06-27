//
//  Item.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/26/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import CoreData

class ItemCoreData: NSManagedObject, ParentManagedObject {
    
    @NSManaged var categoryUID:String
    @NSManaged var itemImageURL:String
    @NSManaged var itemName:String
    @NSManaged var itemUID:String
    @NSManaged var itemPrice:Double
    
}