//
//  ItemOptionsView.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/12/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit

class ItemOptionsView: UIView {
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var optionName: UITextField!
    @IBOutlet weak var optionPrice: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var saveButton: UIButton!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        
    }
    
    func addShadow() {
        self.layer.masksToBounds = true
        self.layer.borderWidth = 3
        self.layer.borderColor = UIColor.lightGray.cgColor
        self.layer.cornerRadius = 10.0
        
        self.layer.shadowColor = UIColor.black.cgColor
        self.layer.shadowRadius = 10
        self.layer.shadowOffset = CGSize(width: -1, height: -1)
        
        optionName.layer.masksToBounds = true
        optionName.layer.borderWidth = 1
        optionName.layer.borderColor = UIColor.lightGray.cgColor
        optionName.layer.shadowColor = UIColor.black.cgColor
        optionName.layer.cornerRadius = 6.0
        //optionName.layer.shadowRadius = 5
        //optionName.layer.shadowOffset = CGSize(width: -1, height: -1)
        
        optionPrice.layer.masksToBounds = true
        optionPrice.layer.borderWidth = 1
        optionPrice.layer.borderColor = UIColor.lightGray.cgColor
        optionPrice.layer.cornerRadius = 6.0
        //optionPrice.layer.shadowColor = UIColor.black.cgColor
        //optionPrice.layer.shadowRadius = 5
        optionPrice.layer.shadowOffset = CGSize(width: -1, height: -1)
        
    }
    
    @IBAction func cancelButton_Pressed(_ sender: UIButton) {
        if let pView = self.superview {
            pView.removeFromSuperview()
        }
        self.removeFromSuperview()
        //print("CANCEL BUTTON PRESSED")
    }
    
    @IBAction func saveButton_Pressed(_ sender: UIButton) {
        print("SAVE BUTTON PRESSED")
        
       // DataService.instance.saveItemOption(itemUID: <#T##String#>, completion: <#T##(Bool) -> ()#>)
    }
    
}
