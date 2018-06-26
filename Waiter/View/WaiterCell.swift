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
    
    func setData(staff: StaffMember, indexPath: IndexPath) {
        
        staffTypeLabel.text = staff.type
        staffEmailLabel.text = staff.email
        staffNumberLabel.text = "\(indexPath.row + 1)"
    }
   
}
