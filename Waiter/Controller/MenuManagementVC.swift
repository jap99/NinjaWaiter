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
    
    var categories = [Category]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        getCategories()
        setupVC()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        showAddCategoryView(false)
    }

    // MARK: - SETUP
    
    func setupVC() {
        categoryTV.delegate = self; categoryTV.dataSource = self
        self.mainScrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
    }
    // MARK: - IBACTIONS
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC-ID") as! SettingsVC
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func settingsButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC-ID") as! SettingsVC
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addCategoryButton_Pressed(_ sender: UIButton) {
        showAddCategoryView(true)
    }
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
        showAddCategoryView(false)
    }

    @IBAction func addButton_Pressed(_ sender: Any) {
        saveCategory()
    }
    
    // MARK: - ACTIONS
    
    func getCategories() {
        DataService.instance.getCategories { (categories: [Category]?, error) in
            guard let error = error else {
                self.categories = categories!
                return
            }
            print(error)
        }
    }
    
    func saveCategory() {
        if let categoryName = foodTextField.text, categoryName.count > 0 {
            DataService.instance.saveCategory(categoryName: categoryName) { (success) in
                if success {
                    self.foodTextField.text = ""
                    self.addCategoryView.isHidden = true
                }
            }
        } else {
            showError_CategoryAddFailed()
        }
    }
    
    func showAddCategoryView(_ value: Bool) {
        self.addCategoryView.isHidden = !value
    }
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//
        if self.categoryTV == tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ADD_CATEGORY_CELL, for: indexPath) as! AddCategoryCell
 
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
    
    // ALERT CONTROLLERS
    
    func showError_CategoryAddFailed() {
        let alertController = UIAlertController(title: "Error", message: "There was an issue uploading your category. Please try again later.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            self.addCategoryView.isHidden = true
        })
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
}
