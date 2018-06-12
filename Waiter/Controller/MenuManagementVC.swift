//
//  MenuManagementVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/9/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class MenuManagementVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    @IBOutlet weak var menuManagementButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    // TABLE VIEW
    @IBOutlet weak var categoryTV: UITableView!
    @IBOutlet weak var itemTV: UITableView!
    
    // SCROLL VIEW
    
    @IBOutlet weak var mainScrollview: UIScrollView!
    
    @IBOutlet weak var saveCategoryButton: UIButton!
    @IBOutlet weak var saveItemButton: UIButton!
    
    // ADD CATEGORY VIEW
    
    @IBOutlet weak var addCategoryView: UIView!
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    // ADD ITEM VIEW
    
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!

    // ITEM OPTIONS
    
    @IBOutlet weak var itemOneButton: UIButton!
    @IBOutlet weak var itemTwoButton: UIButton!
    @IBOutlet weak var itemThreeButton: UIButton!
    @IBOutlet weak var itemFourButton: UIButton!
    @IBOutlet weak var itemFiveButton: UIButton!
    @IBOutlet weak var itemSixButton: UIButton!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
        setupVC()
    }

    // MARK: - SETUP
    
    func setupVC() {
        categoryTV.delegate = self; categoryTV.dataSource = self
        self.mainScrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
//        itemTV.delegate = self; itemTV.dataSource = self
    }
    // MARK: - IBACTIONS
    
    @IBAction func backButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func settingsButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func menuManagementButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func addCategoryButton_Pressed(_ sender: UIButton) {
        if(sender.tag == 0)
        {
            self.addCategoryView.isHidden = false
        }else{
            self.addCategoryView.isHidden = true
        }
    }
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
    }

    @IBAction func addButton_Pressed(_ sender: Any) {
    }
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        let cell = tableView.dequeueReusableCell(withIdentifier: ADD_CATEGORY_CELL, for: indexPath) as! AddCategoryCell
//        let cell:AddCategoryCell = self.categoryTV.dequeueReusableCell(withIdentifier: ADD_CATEGORY_CELL, for: indexPath) as! AddCategoryCell
//
//        return cell
        
        if self.categoryTV == tableView {
            let cell = tableView.dequeueReusableCell(withIdentifier: ADD_CATEGORY_CELL, for: indexPath) as! AddCategoryCell

            // set the text from the data model
//            cell.textLabel?.text = "cell lable categoryTV"
            return cell
        }else{
            var cell:UITableViewCell = UITableViewCell()
            // create a new cell if needed or reuse an old one
            cell = tableView.dequeueReusableCell(withIdentifier: ADD_ITEM_CELL) as! UITableViewCell

            // set the text from the data model
            cell.textLabel?.text = "cell lable itemTV"
            return cell
        }
        
        
    }
}
