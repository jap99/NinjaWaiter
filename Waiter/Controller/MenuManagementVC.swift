//
//  MenuManagementVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/9/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import FirebaseStorage

class MenuManagementVC: UIViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource {
    
    // NAVIGATION BAR BUTTONS
    
    @IBOutlet weak var menuManagementButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    
    // SAVE SUCCESSFUL VIEWS - popups
    @IBOutlet weak var categorySavedSuccess_View: UIView!
    @IBOutlet weak var itemSavedSuccess_View: UIView!
    @IBOutlet weak var itemEditedSuccessfully_View: UIView!
    
    
    // (ADD) CATEGORY BUTTON & ITEM BUTTON
    
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var addImageButton: UIButton!
    
    // TABLE VIEWS
    
    @IBOutlet weak var categoryTV: UITableView!
    @IBOutlet weak var itemTV: UITableView!
    
    // THE SCROLL VIEW
    
    @IBOutlet weak var mainScrollview: UIScrollView!
    
    // (SAVE) CATEGORY BUTTON & ITEM BUTTON
    
    @IBOutlet weak var saveCategoryButton: UIButton!
    @IBOutlet weak var saveItemButton: UIButton!
    
    // THE 'ADD CATEGORY' POPOUP VIEW
    
    @IBOutlet weak var addCategoryView: UIView!
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    @IBOutlet weak var plusSignCategoryImageView: UIImageView!
    
    // ADD ITEM - VIEW
    @IBOutlet weak var addItemView: CreateItem!
    @IBOutlet weak var itemNameTextField: UITextField!
    @IBOutlet weak var itemPriceTextField: UITextField!
    @IBOutlet weak var plusSignItemImageView: UIImageView!
    
    // COLLECTION VIEW
    
    @IBOutlet weak var itemCV: UICollectionView!
    
    // EDIT MENU ITEMS
    // ItemOptionCell
    @IBOutlet weak var allButton: UIButton!
    @IBOutlet weak var allView: UIView!
    @IBOutlet weak var byCategoryButton: UIButton!
    @IBOutlet weak var byCategoryView: UIView!
    @IBOutlet weak var byCategoryImageView: UIImageView!
    @IBOutlet weak var editMenuItemsCV: UICollectionView!
    
    // VARIABLES
    
    var categories = [Category]()
    var dictOfArrays = [String: [String]]()
    var index = 0
    var imagePicker: UIImagePickerController?
    var textField : UITextField?
    
    // V D L
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        getCategories()
        setupVC()
    }
    
    // V D A
    
    override func viewDidAppear(_ animated: Bool) {
        showAddCategoryView(false)
        
        itemCV.reloadData();  itemTV.reloadData()
    }
    
    // V W A
    
    override func viewWillAppear(_ animated: Bool) {
        itemSavedSuccess_View.isHidden = true
        categorySavedSuccess_View.isHidden = true
        itemEditedSuccessfully_View.isHidden = true 
    }
    
    // MARK: - SETUP
    
    func setupVC() {
        
        mainScrollview.contentSize = CGSize(width: self.view.frame.size.width, height: 700)
        
        // category tv
        categoryTV.delegate = self; categoryTV.dataSource = self
        categoryTV.backgroundColor = .white
        categoryTV.separatorStyle = .none
        
        // item tv
        itemTV.backgroundColor = .white
        itemTV.separatorStyle = .none
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 100, height: 100)
        layout.scrollDirection = .horizontal
        layout.minimumLineSpacing = 50
        layout.minimumInteritemSpacing = 20
        
        // item cv
        
        itemCV.delegate = self; itemCV.dataSource = self
        itemCV.allowsSelection = true
        itemCV.allowsMultipleSelection = false
        
        
        // create item - section
        itemNameTextField.layer.borderWidth = 1.0
        itemNameTextField.layer.borderColor = UIColor.lightGray.cgColor
        itemPriceTextField.layer.borderWidth = 1.0
        itemPriceTextField.layer.borderColor = UIColor.lightGray.cgColor
        
        // add - edit section
        byCategoryView.layer.cornerRadius = 7
        allView.layer.cornerRadius = 7
        
        // item - image picker
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
        
        hideKeyboardWhenTappedAround()
    }
    // MARK: - IBACTIONS
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func settingsButton_Pressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    // CATEGORIES SECTION
    
    @IBAction func addCategoryButton_Pressed(_ sender: UIButton) {
        showAddCategoryView(true)
    }
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
        showAddCategoryView(false)
    }
    
    @IBAction func addButton_Pressed(_ sender: Any) {
        saveCategory()
    }
    
    // ITEM SECTION
    
    @IBAction func addItemButton_Pressed(_ sender: Any) {
        //        self.addItemView = CreateItem.loadViewFromNib(viewController: self)
        //        self.view.addSubview(addItemView)
        
        present(imagePicker!, animated: true, completion: nil)
        
    }
    
    @IBAction func saveButton_Pressed(_ sender: Any) { // save item
        
        let dictOfArraysIsNotEmpty: Bool =  dictOfArrays.filter { $0.value.count > 0 }.count > 0
        
        let lunch = dictOfArrays.filter { $0.value.contains("Lunch") }.map{$0.key}
        let dinner = dictOfArrays.filter { $0.value.contains("Dinner") }.map{$0.key}
        let breakFast = dictOfArrays.filter { $0.value.contains("Breakfast") }.map{$0.key}
        
        print("lunch: \(lunch)")
        print("dinner: \(dinner)")
        print("breakFast: \(breakFast)")
        
        if let name = itemNameTextField.text, let price = itemPriceTextField.text, dictOfArraysIsNotEmpty {
            
            DataService.instance.saveItem(itemName: name, itemPrice: price, itemImage: self.addImageButton.currentBackgroundImage, categoryDictOfArray:  dictOfArrays) { (success) in
                
                if success {
                    
                    self.itemSavedSuccess_View.isHidden = false
                    self.itemNameTextField.text = ""
                    self.itemPriceTextField.text = ""
                    self.addImageButton.setBackgroundImage(nil, for: .normal)
                    self.addImageButton.backgroundColor = customRed
                    self.itemTV.reloadData()
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.itemSavedSuccess_View.isHidden = true
                    })
                    // after save is successfull, turn off all switches again, make text fields empty again, make itemImageView nil again
                }
            }
        }
    }
    
    // ADD / EDIT MENU ITEMS
    
    @IBAction func allButton_Pressed(_ sender: Any) {
        
    }
    
    @IBAction func byCategoryButton_Pressed(_ sender: Any) {
        
    }
    
    
    // MARK: - ACTIONS
    
    func getCategories() {
        
        DataService.instance.getCategories { (categories: [Category]?, error) in
            
            guard let error = error else {
                
                if let c = categories {
                    self.categories = c
                    self.categoryTV.reloadData()
                    self.itemTV.reloadData()
                    return
                }
                return
            }
            print(error.localizedDescription)
        }
    }
    
    func saveCategory() {
        
        if let categoryName = foodTextField.text, categoryName.count > 0 {
            
            DataService.instance.saveCategory(categoryName: categoryName) { (success) in
                
                if success {
                    
                    self.foodTextField.text = ""
                    self.addCategoryView.isHidden = true
                    self.categorySavedSuccess_View.isHidden = false
                    
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.categorySavedSuccess_View.isHidden = true
                    })
                    
                }
            }
            
        } else {
            
            showError_CategoryAddFailed()
        }
    }
    
    func showAddCategoryView(_ value: Bool) {
        
        self.addCategoryView.isHidden = !value
    }
    
    @objc func switchValueDidChange(_ sender: UISwitch) {
        
    }
    
    
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        if self.categoryTV == tableView {
            
            return self.categories.count
            
        } else {
            
            return self.categories.count
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if self.categoryTV == tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ADD_CATEGORY_CELL, for: indexPath) as! AddCategoryCell
            
            if self.categories.count > 0 {
                
                cell.categoryTitle.text = self.categories[indexPath.row].name
                cell.renameButton.tag = indexPath.row
                cell.deleteButton.tag = indexPath.row 
                cell.renameButton.addTarget(self, action: #selector(renameCategoryFunc), for: .allEvents)
                cell.deleteButton.addTarget(self, action: #selector(deleteCategoryFunc), for: .allEvents)
            }
            
            if indexPath.row % 2 == 0 {     // For background color
                
                cell.backgroundColor = .white
            } else {
                
                cell.backgroundColor = customLightGray
            }
            
            return cell
            
        } else {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: ADD_ITEM_CELL, for: indexPath) as! AddItemCell
            cell.parentVC = self
            cell.breakfastSwitch.tag = indexPath.row
            cell.lunchSwitch.tag = indexPath.row
            cell.dinnerSwitch.tag = indexPath.row
            if self.categories.count > 0 {
                
                cell.categoryTitle.text = self.categories[indexPath.row].name
                
            }
            
            if indexPath.row % 2 == 0 {     // For background color
                
                cell.backgroundColor = .white
                
            } else {
                
                cell.backgroundColor = customLightGray
            }
            
            return cell
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        if itemTV == tableView {
            
            let cell = tableView.dequeueReusableCell(withIdentifier: "AddItemCell", for: indexPath) as! AddItemCell
            
            let selectedIndexUID = Singleton.sharedInstance.categoriesItems[indexPath.row].uid
            
            var arrayOfAvailability = [String]()
            
            if cell.breakfastSwitch.isOn {
                arrayOfAvailability.append("Breakfast")
            } else {
                //remove it from array
            }
            
            if cell.lunchSwitch.isOn {
                arrayOfAvailability.append("Lunch")
            } else {
                //remove it from array
            }
            
            if cell.dinnerSwitch.isOn {
                arrayOfAvailability.append("Dinner")
                cell.dinnerSwitch.isOn = true
            } else {
                //remove it from array
            }
        }
    }
    
    // MARK: - COLLECTION VIEW
    
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            
            if collectionView == itemCV {
                return 6
            } else {
                return 0
            }
            
        }
    
        func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
            if collectionView == itemCV {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemOptionCell", for: indexPath) as! ItemOptionCell
                
                cell.configureCell(indexPath: indexPath)
                
                return cell
            } else {
                return UICollectionViewCell()
            }
            
        }
    
    // MARK: - IMAGE PICKER
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String : Any]) {
        
        if picker == imagePicker, let img = info[UIImagePickerControllerOriginalImage] as? UIImage {
            
            self.addImageButton.isEnabled = true
            self.addImageButton.backgroundColor = .clear
            self.addImageButton.setBackgroundImage(img, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
    }
    // MARK: - ALERT CONTROLLERS
    
    func showError_CategoryAddFailed() {
        let alertController = UIAlertController(title: "Error", message: "There was an issue uploading your category. Please try again later.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { (action: UIAlertAction) in
            self.addCategoryView.isHidden = true
        })
        
        alertController.addAction(okAction)
        
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func renameCategoryFunc(sender: UIButton) {
        
        let  ac = UIAlertController(title: "Rename Category", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let  okAction = UIAlertAction(title: "Okay", style: .default) { (action) in
            
            DataService.instance.renameCategory(categoryUID: (self.categories[sender.tag].uid)!, updatedName: ac.textFields![0].text!, completion: { (update) in
            })
        }
        ac.addTextField { (textfield) in
            textfield.text = self.categories[sender.tag].name
            print(self.categories[sender.tag].uid)
        }
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
        
    }
    
    @objc func deleteCategoryFunc(sender: UIButton) {
        
        DataService.instance.deleteCategory(categoryUID: (self.categories[sender.tag].uid)!) { (success) in
            
            if success {
                
                self.successfullyDeletedCategory_Alert()
            
            } else {
                
                self.errorDeletingCategory_Alert()
            }
        }
        
    }
    
    func successfullyDeletedCategory_Alert() {
        
        let ac = UIAlertController(title: "Success", message: "You have successfully deleted a category from the database.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                
                ac.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func errorDeletingCategory_Alert() {
        
        let ac = UIAlertController(title: "Error", message: "There was an error deleting the category from the database. Please try again.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true) {
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                
                ac.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    
}
