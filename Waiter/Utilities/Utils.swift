//
//  Utils.swift
//  Waiter
//
//  Created by Javid Poornasir on 7/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class Utils: NSObject {
    
    // MARK: - ALERTS
    
    class func showAlert(title: String, message: String, onSucces: (() -> Void)?) {
        if let topVC = UIApplication.getTopMostViewController() {
            let ac = UIAlertController(title: title, message: message, preferredStyle: .alert)
            let ok = UIAlertAction(title: "Okay", style: .default, handler: { (_) in
                if let onSucces = onSucces {
                    onSucces()
                }
            })
            ac.addAction(ok)
            topVC.present(ac, animated: true, completion: nil)
        }
    }
    
    
}
