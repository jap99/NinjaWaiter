//
//  AppUser.swift
//  WaiterWallet
//
//  Created by Javid Poornasir on 11/22/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//


import UIKit
import FirebaseAuth


class AppUser {
    var email = ""
    var name = ""
    var type = UserType.client
    var uid = ""
    
    init() { }
    
    init(user: User) {
        self.email = user.email
        self.name = user.name
        self.uid = user.uid
    }
    
    
}

