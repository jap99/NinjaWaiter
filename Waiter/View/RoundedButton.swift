//
//  RoundButton.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/15/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

@IBDesignable
class RoundedButton: UIButton {
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.layer.cornerRadius = 7
    }
    
}
