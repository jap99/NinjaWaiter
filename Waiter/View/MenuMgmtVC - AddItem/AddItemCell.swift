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

        configureInterfaceForSmallDevice() 
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
    }
    
    func configureInterfaceForSmallDevice() {
        if UIScreen.main.bounds.width < 1030 {
            let cellViews: [String: UIView] = ["c": categoryTitle, "bs": breakfastSwitch, "ls": lunchSwitch, "ds": dinnerSwitch]
            categoryTitle.translatesAutoresizingMaskIntoConstraints = false
            breakfastSwitch.translatesAutoresizingMaskIntoConstraints = false
            lunchSwitch.translatesAutoresizingMaskIntoConstraints = false
            dinnerSwitch.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[c]-70-[bs]-90-[ls]-60-[ds]-50-|", options: [], metrics: nil, views: cellViews),
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-20-[c]", options: [], metrics: nil, views: cellViews)
                ].flatMap{$0})
        }
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func breakfastSwitchAction(_ sender: UISwitch) {
        if let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[sender.tag].uid {
            addAndRemoveCategoryItem(switch:sender, categoryUID: uidOfCategorySelected, catName: "Breakfast")
        }
    }
    
    @IBAction func lunchSwitch(_ sender: UISwitch) {
        if let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[sender.tag].uid {
            addAndRemoveCategoryItem(switch:sender, categoryUID: uidOfCategorySelected, catName: "Lunch")
        }
    }
    
    @IBAction func dinnerSwitch(_ sender: UISwitch) {
        if let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[sender.tag].uid {
            addAndRemoveCategoryItem(switch:sender, categoryUID: uidOfCategorySelected, catName: "Dinner")
        }
    }
    
}
