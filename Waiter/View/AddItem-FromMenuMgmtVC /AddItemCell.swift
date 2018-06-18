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
    
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var breakfastSwitch: UISwitch!
    @IBOutlet weak var lunchSwitch: UISwitch!
    @IBOutlet weak var dinnerSwitch: UISwitch!
    
    override func awakeFromNib() {
//        breakfastSwitch.isOn = false
//        lunchSwitch.isOn = false
//        dinnerSwitch.isOn = false
    }
    
    @IBAction func breakfastSwitchAction(_ sender: UISwitch) {
       // let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[indexPath.row].uid
    }
    // check if any switches have been switched on since the user clicked on the save button; if no switches are on then tell user they can't create an item unless all fields have been entered. if at least one switch is on, then take the UID of that where that switch is that was selected
    @IBAction func lunchSwitch(_ sender: Any) {
        // let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[indexPath.row].uid
    }
    
    @IBAction func dinnerSwitch(_ sender: Any) {
         //let uidOfCategorySelected = Singleton.sharedInstance.categoriesItems[indexPath.row].uid
    }
    
}
