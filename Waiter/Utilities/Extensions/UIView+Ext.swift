//
//  UIView+Ext.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/25/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import UIKit




extension UIView {
    
    func addCornerRadiusToNavBarButton() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    func addCornerRadiusCellItems() {
        self.layer.masksToBounds = true
        self.layer.cornerRadius = 10
    }
    
    
}

