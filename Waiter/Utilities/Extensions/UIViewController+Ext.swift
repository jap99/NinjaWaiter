//
//  UIViewController+Ext.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/25/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import UIKit

extension UIViewController {
    
    func hideKeyboardWhenTappedAround() {
        let tap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UIViewController.dismissKeyboard))
        view.addGestureRecognizer(tap)
    }
    
    @objc func dismissKeyboard() {
        view.endEditing(true)
    }
    
    
}

 
