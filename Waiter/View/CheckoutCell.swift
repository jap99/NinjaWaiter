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
    
    func configureCell(indexPath: IndexPath, cartDictionaries: [[String: AnyObject]]) {
        print("*******************")
        print(cartDictionaries)
        print("*******************")
        
            for (key, value) in cartDictionaries[indexPath.row] {
                let name = key
                let price = value
                print(key)
                print(value)
                print("----------")
                self.itemDescriptionLabel?.text = name
                self.itemPriceLabel?.text = "\(price)"
            }
            print("PRINTING CART ARRAY OF DICTIONARIES: \(cartDictionaries)")
        
    }
}
