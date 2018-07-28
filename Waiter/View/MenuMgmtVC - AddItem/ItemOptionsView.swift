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
    
    var itemId = ""
    var optionId = ""
    var isEditingMode = false
    
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
    
    func updateFields(optionData: [String: AnyObject]?, optionIndex: Int, selectedItemId:
        String) {
        self.itemId = selectedItemId
        if let optionData = optionData {
            if let optionId = optionData["key"] as? String {
                self.optionId = optionId
            }
            
            if self.optionId != "" {
                isEditingMode = true
                topLabel.text = "Edit Option \(optionIndex)"
                
                if let optionValue = optionData["value"] as? [String:AnyObject] {
                    if let optionTitle = optionValue["optionTitle"] as? String {
                        optionName.text = optionTitle
                    }
                    
                    if let optionPrice = optionValue["optionPrice"] as? String {
                        self.optionPrice.text = optionPrice
                    }
                }
                
            }
        }
        
        if !isEditingMode {
            topLabel.text = "Add New Option"
            self.optionId = "itemOption\(optionIndex)"
        }
    }
    
    @IBAction func cancelButton_Pressed(_ sender: UIButton) {
        removeView()
    }
    
    func removeView() {
        if let pView = self.superview {
            pView.removeFromSuperview()
        }
        self.removeFromSuperview()
    }
    
    @IBAction func saveButton_Pressed(_ sender: UIButton) {
        print("SAVE BUTTON PRESSED")
        
        if let optionName = optionName.text, let optionPrice = optionPrice.text, optionName != "" && optionPrice != "" {
            var optionData = [String: AnyObject]()
            optionData["optionTitle"] = optionName as AnyObject
            optionData["optionPrice"] = optionPrice as AnyObject
            DataService.instance.addEditItemOption(itemId: itemId, optionId: optionId, optionValue: optionData)
            
            Utils.showAlert(title: "Success", message: "Updated Successfully", onSucces: {() in
                self.removeView()
            })
        } else {
            Utils.showAlert(title: "Alert", message: "Item name & price required", onSucces:nil)
        }
        
        
    }
    
}
