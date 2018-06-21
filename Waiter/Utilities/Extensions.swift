//
//  Extensions.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/8/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
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

 

extension NSDictionary{
    
    func getDoubleValue(key: String) -> Double{
        
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.doubleValue
            }else if let str = any as? NSString{
                return str.doubleValue
            }
        }
        return 0
    }
    
    func getFloatValue(key: String) -> Float{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.floatValue
            }else if let str = any as? NSString{
                return str.floatValue
            }
        }
        return 0
    }
    
    func getIntValue(key: String) -> Int{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.intValue
            }else if let str = any as? NSString{
                return str.integerValue
            }
        }
        return 0
    }
    
    func getInt32Value(key: String) -> Int32{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.int32Value
            }else if let str = any as? NSString{
                return str.intValue
            }
        }
        return 0
    }
    
    func getInt16Value(key: String) -> Int16{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.int16Value
            }else if let str = any as? NSString{
                return Int16(str.intValue)
            }
        }
        return 0
    }
    
    func getStringValue(key: String) -> String{
        if let any = object(forKey: key){
            if let number = any as? NSNumber{
                return number.stringValue
            }else if let str = any as? String{
                return str
            }
        }
        return ""
    }
    
    func getBooleanValue(key: String) -> Bool {
        if let any = object(forKey: key) {
            if let num = any as? NSNumber {
                return num.boolValue
            } else if let str = any as? NSString {
                return str.boolValue
            }
        }
        return false
    }
}
