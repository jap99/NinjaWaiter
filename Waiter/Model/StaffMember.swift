//
//  StaffMember.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import Firebase
import FirebaseDatabase

class StaffMember {
    
    var email: String!
    var type: String!
    var uid = ""
    init() {}
    
    init(email: String, type: String) {
        self.email = email
        self.type = type
    }
    
    // only called to populate the table view in SettingsVC
    static func getStaffList(array: [[String: Any]],arrKey:[String]) -> [StaffMember] {
        var staffMembers: [StaffMember] = []
        for (index,a) in array.enumerated() {
            if let email = a["staffEmail"] as? String,
                let type = a["staffType"] as? String {
                var staff = StaffMember(email: email, type: type)
                staff.uid = arrKey[index]
                staffMembers.append(staff)
            }
        }
        return staffMembers
    }
    
    static func getStaffList(adminEmail: String, callback: ((_ staffMembers: [StaffMember]?, _ error: Error?) -> Void)?) {
        _ = Database.database().reference().child(FIR_ADMINISTRATORS).child(Auth.auth().currentUser!.uid).observeSingleEvent(of: .value) { (snapshot) in
           
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            }
            
            let restaurantUID = snapshot.value as! String
            Database.database().reference().child(FIR_RESTAURANTS).child(restaurantUID).observeSingleEvent(of: .value, with: { (snapshot) in
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
            })
        }
    }
}
