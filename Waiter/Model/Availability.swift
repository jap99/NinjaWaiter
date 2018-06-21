//
//  Availability.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/20/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage

class Availability {
    
    var lunch: [String: NSDictionary]!
    var breakfast: [String: NSDictionary]!
    var dinner: [String: NSDictionary]!
     
    init(dict:[DataSnapshot]) {
        for snap in dict {
            if snap.key == "Dinner" , let value = snap.value as? NSDictionary  {
                self.dinner = [snap.key:value]
            }
            if snap.key == "Lunch" , let value = snap.value as? NSDictionary  {
                self.dinner = [snap.key:value]
            }
            if snap.key == "Breakfast" , let value = snap.value as? NSDictionary  {
                self.dinner = [snap.key:value]
            }
           
        }
    }
}

