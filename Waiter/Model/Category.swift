//
//  Category.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/14/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase


class Category {
    
    var uid: String!
    var name: String!
    
    init() {}
    
    init(uid: String, name: String) {
        self.uid = uid
        self.name = name
    }
    
    // only called to populate the table view in SettingsVC
    static func getCategoryList(array: [[String: Any]], arrKey:[String]) -> [Category] {
        
        var categories: [Category] = []
        
        for (_,a) in array.enumerated() {
            
            if let uid = a["uid"] as? String,
                let name = a["name"] as? String {
                let category = Category(uid: uid, name: name)
                categories.append(category)
            }
        }
        //print(categories.count)
        return categories
    }
    
    /**
     This method parse the data which is receive from Firbase response and set the Uid and Name of Category Item.
     - parameter snapshot: Its a DataSnapshot type of object which contains response of categories data.
     - returns [Category]: This method is return Category object.
    */
    static func parseCategoryData(snapshot : DataSnapshot) -> [Category]{
        
        var arrCategory: [Category] = []
        if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
            for snap in snapshot {
                let categoryUID = snap.key
                let categoryName = snap.value as! String
                let category = Category(uid: categoryUID, name: categoryName)
                arrCategory.append(category)
            }
        }
        return arrCategory
    }
    
    static func getCategoryList(callback: ((_ staffMembers: [StaffMember]?, _ error: Error?) -> Void)?) {
        _ = Database.database().reference().child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).observeSingleEvent(of: .value) { (snapshot) in
            
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            }
            
            var isSuccess = false
            if let dictionary = snapshot.value as? [String: Any] {
                if let staffDictionary = dictionary["Staff"] as? [String: Any] {
                    let keyList = staffDictionary.keys
                    var allkeys = [String]()
                    var staffDictionaryArray: [[String: Any]] = []
                    for key in keyList {
                        if let staffMemberDictionary = staffDictionary[key] as? [String: Any] {
                            allkeys.append(key)
                            staffDictionaryArray.append(staffMemberDictionary)
                        }
                    }
                    let staffMembers = StaffMember.getStaffList(array:staffDictionaryArray , arrKey:allkeys)
                    //let staffMembers = StaffMember.getStaffList(array: staffDictionaryArray,keyList)
                    isSuccess = true
                    callback?(staffMembers, nil)
                }
            }
            if(!isSuccess) {
                callback?(nil, nil)
            }
        }
    }
    
}
