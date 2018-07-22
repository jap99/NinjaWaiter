//
//  CategoryCell.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/9/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class AddCategoryCell: UITableViewCell {

    @IBOutlet weak var categoryNumber: UIButton!
    @IBOutlet weak var categoryTitle: UILabel!
    @IBOutlet weak var renameButton: UIButton!
    @IBOutlet weak var deleteButton: UIButton!
    
    override func awakeFromNib() {
            configureInterfaceForSmallDevice()
    }
    
    func configureInterfaceForSmallDevice() {
        if UIScreen.main.bounds.width < 1030 {
            let cellViews: [String: UIView] = ["s": categoryNumber, "t": categoryTitle, "r": renameButton, "d": deleteButton]
            categoryNumber.translatesAutoresizingMaskIntoConstraints = false
            categoryTitle.translatesAutoresizingMaskIntoConstraints = false
            renameButton.translatesAutoresizingMaskIntoConstraints = false
            deleteButton.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-30-[s]-70-[t]-90-[r]-60-[d]-35-|", options: [], metrics: nil, views: cellViews) 
                ].flatMap{$0})
        }
    }
}
