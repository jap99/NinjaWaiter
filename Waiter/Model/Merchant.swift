//
//  Merchant.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/21/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import Foundation


class Merchant {
    
    var id: String!
    var name: String!
    var email: String!
    var phone: String!
    var ein: String!
    var wallet: Wallet!
    var address: Address!
    
    var repAddress: Address!
    var repBirthday: Birthday!
    var repFirstName: String!
    var repLastName: String!
    var repEmail: String!
    var repTitle: String!
    var repLast4SSN: String!
    var repIsExecutive: Bool!
    
    var owners: [MerchantOwner]!
    
}
