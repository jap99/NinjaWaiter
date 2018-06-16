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
        
        self.layer.cornerRadius = 6
    }
    
//    @IBInspectable var cornerRadius: CGFloat = 6 {
//        didSet {
//
//            layer.cornerRadius = cornerRadius
//            layer.masksToBounds = cornerRadius > 0
//        }
//    }
    
//    @IBInspectable var btnHeight: CGFloat = 30 {
//        didSet{
//            frame.size.height = 30
//        }
//    }
    
//    @IBInspectable var borderWidth: CGFloat = 0 {
//        didSet{
//            layer.borderWidth = borderWidth
//        }
//    }
    
//    @IBInspectable var borderColor: UIColor? {
//        didSet {
//            layer.borderColor = borderColor?.cgColor
//        }
//    }
//
//    @IBInspectable var bgColor: UIColor? {
//        didSet {
//            backgroundColor = bgColor
//        }
//    }
}
