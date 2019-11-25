//
//  Array+ext.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/25/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

extension Array where Element: Numeric {
    
    func sum() -> Element {
        return self.reduce(0, {$0 + $1})        // how to use --->   [1.0, 2.0].sum()
    }
    
    
    
}



extension Array where Element == String {
    
    func concatenateStrings() -> String {
        return self.reduce("", {$0 + $1 + " "})         // how to use --->    ["Hello,", "how", "are", "you?"].concatengateStrings()
    }
    
    
    
}

