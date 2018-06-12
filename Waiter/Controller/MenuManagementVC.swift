//
//  MenuManagementVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/9/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class MenuManagementVC: UIViewController,UITableViewDelegate,UITableViewDataSource {
    
    
    

    @IBOutlet weak var menuManagementButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    @IBOutlet weak var categoryTV: UITableView!
    @IBOutlet weak var itemTV: UITableView!
    
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
        itemTV.delegate = self; itemTV.dataSource = self
    }
    // MARK: - IBACTIONS
    
    @IBAction func backButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func settingsButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func menuManagementButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func addCategoryButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
    }

    @IBAction func addButton_Pressed(_ sender: Any) {
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 5
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell:UITableViewCell = UITableViewCell()
        if(self.categoryTV == tableView)
        {
            // create a new cell if needed or reuse an old one
            cell = tableView.dequeueReusableCell(withIdentifier: ADD_CATEGORY_CELL) as! UITableViewCell
            
            // set the text from the data model
            cell.textLabel?.text = "cell lable categoryTV"
        }else{
            // create a new cell if needed or reuse an old one
            cell = tableView.dequeueReusableCell(withIdentifier: ADD_ITEM_CELL) as! UITableViewCell
            
            // set the text from the data model
            cell.textLabel?.text = "cell lable itemTV"
        }
        
        return cell
    }
}
