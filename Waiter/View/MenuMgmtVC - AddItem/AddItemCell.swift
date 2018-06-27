//
//  ItemCell.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/12/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit

class AddItemCell: UITableViewCell {
    
    weak var parentVC: MenuManagementVC!
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var breakfastSwitch: UISwitch!
    @IBOutlet weak var lunchSwitch: UISwitch!
    @IBOutlet weak var dinnerSwitch: UISwitch!
    
    
    override func awakeFromNib() {
    }
    
    // MARK: - ACTIONS
    
    func addAndRemoveCategoryItem(switch: UISwitch, categoryUID: String, catName: String) {
        
        if let arrItem = parentVC.dictOfArrays[categoryUID] {
            
            if arrItem.contains(catName) {
                let index = arrItem.index(of:catName)
                parentVC.dictOfArrays[categoryUID]!.remove(at:index!)
            } else {
                parentVC.dictOfArrays[categoryUID]!.append(catName)
            }
        
        } else {
            parentVC.dictOfArrays[categoryUID]  = [catName]
        }
        print(parentVC.dictOfArrays)
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func breakfastSwitchAction(_ sender: UISwitch) {
        if let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[sender.tag].uid {
            let breakfast = "Breakfast"
            addAndRemoveCategoryItem(switch:sender, categoryUID: uidOfCategorySelected, catName: breakfast)
        }
    }
    
    @IBAction func lunchSwitch(_ sender: UISwitch) {
        if let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[sender.tag].uid {
            let lunch = "Lunch"
            addAndRemoveCategoryItem(switch:sender, categoryUID: uidOfCategorySelected, catName: lunch)
        }
    }
    
    @IBAction func dinnerSwitch(_ sender: UISwitch) {
        if let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[sender.tag].uid {
            let dinner = "Dinner"
            addAndRemoveCategoryItem(switch:sender, categoryUID: uidOfCategorySelected, catName: dinner)
        }
    }
    
}
