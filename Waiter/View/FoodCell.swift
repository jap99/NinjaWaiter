//
//  FoodCell.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit

class FoodCell: UICollectionViewCell {
    
    @IBOutlet weak var fooddTitleBgView: UIView!
    @IBOutlet weak var foodNameLabel: UILabel!
    @IBOutlet weak var foodImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        self.contentView.layer.masksToBounds = true
        fooddTitleBgView.addCornerRadiusCellItems()
        foodImageView.addCornerRadiusCellItems()
        
    }
    
    func giveBorder(selected: Bool) {
        
        if selected {
            self.contentView.layer.backgroundColor = customRed.cgColor
            
        } else {
            
            self.contentView.layer.backgroundColor = UIColor.white.cgColor
        }
    }
}



class MenuItemTitleCell: UITableViewCell {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var priceLabel: UILabel!
    
}


class MenuItemOptionCell: MenuItemTitleCell {}
