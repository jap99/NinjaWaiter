//
//  Lunch.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/26/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import CoreData

class Lunch: NSManagedObject, ParentManagedObject {
    
    @NSManaged var lunchRelationship:CategoryEntity?
}
