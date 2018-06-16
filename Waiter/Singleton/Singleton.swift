//
//  Singleton.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/16/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation

final class Singleton {
    
    static var sharedInstance = Singleton()
    
    private init () {}
    
    var categoriesItems: [Category] = [Category]()
    
}
