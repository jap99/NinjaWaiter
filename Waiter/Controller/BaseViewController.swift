//
//  BaseViewController.swift
//  Waiter
//
//  Created by Javid Poornasir on 7/29/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import NVActivityIndicatorView


class BaseViewController: UIViewController, NVActivityIndicatorViewable {
    
    var activityIndicatorView = NVActivityIndicatorView(frame: CGRect.zero)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenBound = UIScreen.main.bounds
        let frame = CGRect(origin: CGPoint(x: screenBound.width/2-50, y: screenBound.height/2-50), size: CGSize(width: 60, height: 60))
        activityIndicatorView = NVActivityIndicatorView(frame: frame,
                                                        type: NVActivityIndicatorType(rawValue: 23)!)
        activityIndicatorView.color = UIColor.gray
        self.view.addSubview(activityIndicatorView)
        
        
    }
    
    func startIndicator() {
        self.view.isUserInteractionEnabled = false
        self.view.bringSubview(toFront: activityIndicatorView)
        activityIndicatorView.startAnimating()
    }
    
    func stopIndicator() {
        self.view.isUserInteractionEnabled = true
        activityIndicatorView.stopAnimating()
        self.view.sendSubview(toBack: activityIndicatorView)
    }
}
