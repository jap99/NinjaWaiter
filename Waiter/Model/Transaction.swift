//
//  Transaction.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/21/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import Foundation


class Transaction {
    
    var id: String!
    var receipt: Receipt!
    var status: TransactionStatus = .saleStarted
    var amount: Double = 0.00
    var tip: Double = 0.00
    
}
