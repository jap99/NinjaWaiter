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
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

    @IBAction func resetPasswordButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func deleteAccountButton_Pressed(_ sender: Any) {
    }
    
}
