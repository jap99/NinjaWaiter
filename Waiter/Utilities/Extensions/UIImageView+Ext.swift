//
//  UIImageView+Ext.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/25/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import UIKit


extension UIImageView {
    
    public func loadGif(name: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(name: name)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    @available(iOS 9.0, *)
    public func loadGif(asset: String) {
        DispatchQueue.global().async {
            let image = UIImage.gif(asset: asset)
            DispatchQueue.main.async {
                self.image = image
            }
        }
    }
    
    
}
