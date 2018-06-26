//
//  Dinner.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/26/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import CoreData

class Dinner: NSManagedObject, ParentManagedObject {
    @NSManaged var dinnerRelationship:CategoryEntity?
}
