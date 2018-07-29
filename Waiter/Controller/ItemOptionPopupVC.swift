//
//  ItemOptionPopupVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 7/28/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

protocol ItemOptionDelegate {
    func addItemToCart(menuItem: CategoryItems)
}

class ItemOptionPopupVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var contentMainView: UIView!
    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var orderButton: UIButton!
    
    var menuItem: CategoryItems = CategoryItems()
    var delegate: ItemOptionDelegate?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        tableView.rowHeight = UITableViewAutomaticDimension
        tableView.estimatedRowHeight = 1000
        
        tableView.reloadData()
        
        itemImageView.backgroundColor = UIColor.red
        if menuItem.itemImage != "" {
            itemImageView.kf.setImage(with:URL(string:menuItem.itemImage))
        }
        
       // getItemOptions(itemID: menuItem.itemId)
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        contentMainView.layer.masksToBounds = true
        contentMainView.layer.cornerRadius = 10
        contentMainView.layer.borderColor = UIColor.white.cgColor
        contentMainView.layer.borderWidth = 10
        
        //itemImageView.addCornerRadiusCellItems()
        //orderButton.addCornerRadiusCellItems()
        
    }
    
    func getItemOptions(itemID: String) {
        if itemID != "" {
            self.startIndicator()
            DataService.instance.getItemOption(itemId: itemID) { (dict, error) in
                self.stopIndicator()
                self.menuItem.optionList = [ItemOption]()
                if let optionArray = dict {
                    self.menuItem.optionList = optionArray
                }
                self.tableView.reloadData()
            }
        }
    }
    
    
    @IBAction func dismissButton_Pressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func orderButton_Pressed(_ sender: Any) {
        self.dismiss(animated: true, completion: {
            if let delegate = self.delegate {
                delegate.addItemToCart(menuItem: self.menuItem)
            }
        })
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 2
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if section == 0 {
            return 1
        } else {
            return menuItem.optionList.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if indexPath.section == 0 {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemTitleCell", for: indexPath) as! MenuItemTitleCell
            cell.nameLabel.text = menuItem.itemName
            cell.priceLabel.text = menuItem.itemPrice
            
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: "MenuItemOptionCell", for: indexPath) as! MenuItemOptionCell
            
            
            
            let optionData = menuItem.optionList[indexPath.row]
            
            cell.nameLabel.text = optionData.optionName
            cell.priceLabel.text = optionData.optionPrice
            
            if optionData.isOptionSelected {
                cell.nameLabel.textColor = UIColor.white
                cell.priceLabel.textColor = UIColor.white
                cell.contentView.backgroundColor = UIColor.black
            } else {
                cell.nameLabel.textColor = UIColor.black
                cell.priceLabel.textColor = UIColor.black
                cell.contentView.backgroundColor = UIColor.clear
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if indexPath.section == 1 {
            menuItem.optionList[indexPath.row].isOptionSelected = !menuItem.optionList[indexPath.row].isOptionSelected
            tableView.reloadRows(at: [indexPath], with: .none)
        }
    }
}

