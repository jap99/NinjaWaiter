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
    
    static var ref: DatabaseReference!
    
    static func getStaffList(callback: ((_ staffMembers: [StaffMember]?, _ error: Error?) -> Void)?) {
        // only need to fetch once so use single event
        ref = Database.database().reference().child(FIR_ADMINISTRATORS)
        StaffMember.ref.observeSingleEvent(of: .value) { (snapshot) in
            if !snapshot.exists() { return }
            let dat = snapshot.children
//            if let userName = snapshot.value!["full_name"] as? String {
//                print(userName)
//            }
//            if let email = snapshot.value!["email"] as? String {
//                print(email)
//            }
        }

    }
}
