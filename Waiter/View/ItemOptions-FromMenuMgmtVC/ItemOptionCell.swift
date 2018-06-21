//
//  ItemOptionCell.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/20/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class ItemOptionCell: UICollectionViewCell {
    
    // Identifier is ItemOptionCell
        // Located in MenuManagemntVC
    
    @IBOutlet weak var itemOptionsImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        itemOptionsImageView.isUserInteractionEnabled = true
    }
    
    @IBAction func addEditItemButton_Pressed(_ sender: Any) {
    
    }
    
}
