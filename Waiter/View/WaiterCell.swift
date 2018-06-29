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
        setupColoredCellBackgrounds(indexPath: indexPath)
    }
   
    func setupColoredCellBackgrounds(indexPath: IndexPath) {
        
        if indexPath.row % 2 == 0 {
            self.backgroundColor = .white
        } else {
            self.backgroundColor = customLightGray
        }
    }
    
}

