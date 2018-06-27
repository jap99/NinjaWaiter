//
//  WaiterCell.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class WaiterCell: UITableViewCell {

    @IBOutlet weak var staffNumberLabel: UILabel!
    @IBOutlet weak var staffEmailLabel: UILabel!
    @IBOutlet weak var staffTypeLabel: UILabel!
    @IBOutlet weak var resetButton: UIButton!
    @IBOutlet weak var deleteAccountButton: UIButton!
    
    func setData(staffList: [StaffMember]?, indexPath: IndexPath) {
        
        if indexPath.section == 0 {
            
            if let staffList = staffList {
                
                let staff = staffList[indexPath.row]
                self.deleteAccountButton.isHidden = false
                self.resetButton.isHidden = false
                self.staffEmailLabel.isHidden = false
                self.staffTypeLabel.isHidden = false
                
                staffTypeLabel.text = staff.type
                staffEmailLabel.text = staff.email
                staffNumberLabel.text = "\(indexPath.row + 1)"
            }
        } else if indexPath.section == 1 {
            
            self.deleteAccountButton.isHidden = true
            self.resetButton.isHidden = true
            self.staffEmailLabel.isHidden = true
            self.staffTypeLabel.isHidden = true
            
            staffTypeLabel.text = ""
            staffEmailLabel.text = ""
            staffNumberLabel.text = "\(indexPath.row + 1 + (staffList?.count)!)"
        }
        
          if indexPath.row % 2 == 0 { self.backgroundColor = .white } else { self.backgroundColor = customLightGray }
        
        
    }
   
}
