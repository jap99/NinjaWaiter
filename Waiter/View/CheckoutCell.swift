//
//  CheckoutCell.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit

class CheckoutCell: UITableViewCell {
    
    @IBOutlet weak var itemDescriptionLabel: UILabel!
    @IBOutlet weak var xButton: UIButton!
    @IBOutlet weak var itemPriceLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }
    
    func configureCell(indexPath: IndexPath, cartItem: CategoryItems) {
        var itemName = "\(cartItem.itemName)"
        var itemPrice = 0.0
        
        if let price = cartItem.itemPrice as? NSString {
            itemPrice = itemPrice + price.doubleValue
        }
        
        for option in cartItem.optionList {
            if option.isOptionSelected {
                itemName = "\(itemName)\n  + \(option.optionName)"
                if let price = option.optionPrice as? NSString {
                    itemPrice = itemPrice + price.doubleValue
                }
            }
        }
        
        xButton.accessibilityIdentifier = cartItem.itemId
        self.itemDescriptionLabel?.text = itemName
        self.itemPriceLabel?.text = "\(itemPrice)"
    }
}
