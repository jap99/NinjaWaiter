//
//  UIImage+Ext.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/21/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import UIKit 


extension UIImage {
    
    func resize() -> UIImage {
        let height: CGFloat = 1000.0
        let ratio = self.size.width / self.size.height
        let width = height * ratio
        let newSize = CGSize(width: width, height: height)
        let newRectangle = CGRect(x: 0, y: 0, width: width, height: height)
        UIGraphicsBeginImageContext(newSize)
        self.draw(in: newRectangle)
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return resizedImage!
    }
    
    
    
}
