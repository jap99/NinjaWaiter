//
//  SectionCell.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit

class SectionCell: UICollectionViewCell {
    
    @IBOutlet weak var foodNameLabel: UIButton!
    @IBOutlet weak var selectorView: UIView!
    @IBOutlet weak var roundCornerView: UIView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        roundCornerView.addCornerRadiusToNavBarButton()
    }
    
    func configureCell() {
        
    }
    
    
    
}
