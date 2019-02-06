//
//  kPParentManagedObject.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/26/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
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

// PROTOCOL

protocol ParentManagedObject {
}

extension ParentManagedObject where Self: NSManagedObject {

    // Creates a new entity in database by passing its name and return NSManagedObject
    
    static func createNewEntity() -> Self {
        let object = NSEntityDescription.insertNewObject(forEntityName: Self.entityName(), into: _appDel.managedObjectContext) as! Self
        return object
    }
    
    // Creates a new entity in database by passing its name and return NSManagedObject, if object with that primary key already exist it will fetch that object and return.
    static func createNewEntity(key: String,value: NSString) -> Self {
        let predicate = NSPredicate(format: "%K = %@",key,value)
        let results = fetchDataFromEntity(predicate: predicate, sortDescs: nil)
        let entity: Self
        if results.isEmpty {
            entity = createNewEntity()
        } else {
            entity = results.first!
        }
        return entity
    }
    
    // Checks for entity with that primary key  if found object will get return or will return nil
    static func checkEntity(key: String,value:NSString) -> Self? {
        let predicate = NSPredicate(format: "%K = %@",key,value)
        let results = fetchDataFromEntity(predicate: predicate, sortDescs: nil)
        if results.isEmpty {
            return nil
        } else {
            return results.first
        }
    }
    
    // Returns NSEntityDescription optional value, by passing entity name.
    static func getExisting() -> NSEntityDescription? {
        let entityDesc = NSEntityDescription.entity(forEntityName: Self.entityName(), in: _appDel.managedObjectContext)
        return entityDesc
    }
    
    // Returns an array of existing values from given entity name, with peredicate and sort description.
    static func fetchDataFromEntity(predicate: NSPredicate? = nil,
                                    sortDescs: NSArray? = nil ) -> [Self] {
        let entityDesc = getExisting()
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        fetchRequest.entity = entityDesc
        if let _ = predicate {
            fetchRequest.predicate = predicate
        }
        if let _ = sortDescs {
            fetchRequest.sortDescriptors = sortDescs as? Array
        }
        do {
            let resultsObj = try _appDel.managedObjectContext.fetch(fetchRequest)
            if (resultsObj as! [Self]).count > 0 {
                return resultsObj as! [Self]
            } else {
                return []
            }
        } catch let error as NSError {
            print("Error in fetchedRequest : \(error.localizedDescription)")
            return []
        }
    }
    
    
    
    
}

