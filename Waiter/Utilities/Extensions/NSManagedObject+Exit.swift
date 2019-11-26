//
//  NSManagedObject+Exit.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/25/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//


import CoreData


extension NSManagedObject {
    
    class func entityName() -> String {
        return "\(self.classForCoder())"
    }
    
    class func deleteRemovedObject(oldObjs: [NSManagedObject], newObjs:[NSManagedObject]){
        var setOld = Set(oldObjs)
        let setNew = Set(newObjs)
        setOld.subtract(setNew)
        for obj in setOld{
            _appDel.managedObjectContext.delete(obj)
        }
        _appDel.saveContext()
    }
}

