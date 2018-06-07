//
//  CreateRestaurantView.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/23/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class CreateRestaurantView: UIView {

    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func loadViewFromNib() -> CreateRestaurantView {
        let view = Bundle.main.loadNibNamed("CreateRestaurantView", owner: self, options: nil)?.first as! CreateRestaurantView
 
        return view
    }
     
    
    // MARK: - IBACTIONS
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
        self.removeFromSuperview()
    }

    @IBAction func createButton_Pressed(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    
}
