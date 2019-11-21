//
//  Receipt.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/21/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import Foundation

class Receipt {
    
    var id: String!
    var customerID: String!
    var merchantID: String!
    var salesTax: Double!
    var totalCost: Double!
    var staffMember: StaffMember!
    var items: [Item]!
    
}
