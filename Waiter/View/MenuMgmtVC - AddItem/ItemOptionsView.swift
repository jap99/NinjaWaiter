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
    
    @IBAction func cancelButton_Pressed(_ sender: UIButton) {
        print("CANCEL BUTTON PRESSED")
    }
    
    @IBAction func saveButton_Pressed(_ sender: UIButton) {
        print("SAVE BUTTON PRESSED")
    }
    
}
