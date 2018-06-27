//
//  ItemOptionCell.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/20/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class ItemOptionCell: UICollectionViewCell {
    
    @IBOutlet weak var addEditItemOptionsButton: UIButton!

    override func awakeFromNib() {
        super.awakeFromNib()

        self.contentView.bounds.size = CGSize(width: 122, height: 122)
        
    }

    //MARK: - ACTIONS

    func configureCell(indexPath: IndexPath) {
        
        self.addEditItemOptionsButton.setTitle("\(indexPath.row + 1)", for: .normal)

    }
 
    //            if isEmpty {
    //                cell.addEditItemOptionsButton.setTitleColor(customRed, for: .normal)
    //            } else {
    //                cell.addEditItemOptionsButton.setTitleColor(.white, for: .normal)
    //            }


    //MARK: - IBACTIONS

    @IBAction func addEditItemButton_Pressed(_ sender: Any) {
    }

    
    
}
