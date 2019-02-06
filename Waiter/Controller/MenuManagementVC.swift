//
//  MenuManagementVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/9/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import FirebaseStorage
import Firebase
import DropDown


class MenuManagementVC: BaseViewController, UITableViewDelegate, UITableViewDataSource, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    @IBOutlet weak var addLabel: UIView!
    @IBOutlet weak var itemCategoryLabel: UILabel!
    @IBOutlet weak var addCategoryLabel: UILabel!
    @IBOutlet weak var categoryTvTopView: UIView!
    @IBOutlet weak var itemLabel: UILabel!
    @IBOutlet weak var addItemImageLabel: UILabel!
    @IBOutlet weak var itemTvTopView: UIView!
    @IBOutlet weak var itemAvailLabel: UILabel!
    @IBOutlet weak var itemBfLabel: UILabel!
    @IBOutlet weak var itemLunchLbl: UILabel!
    @IBOutlet weak var itemDinLbl: UILabel!
    @IBOutlet weak var itemOptionsLbl: UILabel!
    @IBOutlet weak var editItemsLbl: UILabel!
    @IBOutlet weak var editSubtitleLbl: UILabel!
    @IBOutlet weak var filterCategoryLabel: UILabel!
    @IBOutlet weak var scrollSubview: UIView!
    
    // NAVIGATION BAR BUTTONS
    @IBOutlet weak var navBarView: UIView!
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
    
    // GET ITEMS
    private var dbRef: DatabaseReference!
    private var itemRef: DatabaseReference!
    
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
    
    // EXTRA OUTLETS CREATED IN ORDER TO CODE FOR SMALL DEVICES
    @IBOutlet weak var line1: UIView!
    @IBOutlet weak var line2: UIView!
    @IBOutlet weak var line1_topConstraint: NSLayoutConstraint!
    
    // VARIABLES
    var categories = [Category]()
    var dictOfArrays = [String: [String]]()
    var index = 0
    var imagePicker: UIImagePickerController?
    var textField : UITextField?
    let dropDown = DropDown()
    var items: [[String: AnyObject]] = []
    var itemOptions: [ItemOption] = []
    var selectedItemId = ""
    var isFromSave = false
    
    // V D L
    override func viewDidLoad() {
        super.viewDidLoad()
        self.foodTextField.layer.cornerRadius = 7
        self.addCategoryView.layer.borderColor = UIColor.lightGray.cgColor
        self.addCategoryView.layer.borderWidth = 1.0
        editMenuItemsCV.delegate = self; editMenuItemsCV.dataSource = self
        itemCV.delegate = self; itemCV.dataSource = self
        dropDown.anchorView = byCategoryView
        setupInterfaceIfSmallDevice()
        getCategories()
        setupVC()
        self.getCategoryItems(categoryName: "All")
        dropDown.selectionAction = { [unowned self] (index: Int, categoryName: String) in
            self.filterCategoryLabel.text = categoryName
            self.getCategoryItems(categoryName: categoryName)
        }
    }
    
    // V D L S
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        dropDown.bottomOffset = CGPoint(x: 0, y:(dropDown.anchorView?.plainView.bounds.height)!)
        menuManagementButton.addCornerRadiusToNavBarButton()
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
        byCategoryView.layer.borderColor = UIColor.black.cgColor
        byCategoryView.layer.borderWidth = 0.5
        allView.layer.cornerRadius = 7
        
        // item - image picker
        imagePicker = UIImagePickerController()
        imagePicker?.delegate = self
    }
    
    func setupInterfaceIfSmallDevice() {
        
//        if UIScreen.main.bounds.width < 1030 {
            
//            let navBarViews: [String: UIView] = ["navBarView": navBarView, "backB": backButton, "settingsB": settingsButton, "menuManagementB": menuManagementButton]
//            let itemTopViews: [String: UIView] = ["availabilityL": itemAvailLabel, "breakfastL": itemBfLabel, "lunchL": itemLunchLbl, "dinnerL": itemDinLbl]
//            let itemViews: [String: UIView] = ["tv": itemTvTopView]
//            //let svViews: [String: UIView] = ["scrollSubview": scrollSubview, "mainScrollview": mainScrollview]        // DELETE - used anchor notation instead
//
//            navBarView.translatesAutoresizingMaskIntoConstraints = false
//            backButton.translatesAutoresizingMaskIntoConstraints = false
//            settingsButton.translatesAutoresizingMaskIntoConstraints = false
//            menuManagementButton.translatesAutoresizingMaskIntoConstraints = false
//            mainScrollview.translatesAutoresizingMaskIntoConstraints = false
//            scrollSubview.translatesAutoresizingMaskIntoConstraints = false
//            addImageButton.translatesAutoresizingMaskIntoConstraints = false
//            itemTvTopView.translatesAutoresizingMaskIntoConstraints = false
//
//            addLabel.translatesAutoresizingMaskIntoConstraints = false
//            itemCategoryLabel.translatesAutoresizingMaskIntoConstraints = false
//            addCategoryButton.translatesAutoresizingMaskIntoConstraints = false
//            saveItemButton.translatesAutoresizingMaskIntoConstraints = false
//            itemLabel.translatesAutoresizingMaskIntoConstraints = false
//            itemOptionsLbl.translatesAutoresizingMaskIntoConstraints = false
//            itemCV.translatesAutoresizingMaskIntoConstraints = false
//            editItemsLbl.translatesAutoresizingMaskIntoConstraints = false
//            line1.translatesAutoresizingMaskIntoConstraints = false
//            line2.translatesAutoresizingMaskIntoConstraints = false
//            allView.translatesAutoresizingMaskIntoConstraints = false
//            editMenuItemsCV.translatesAutoresizingMaskIntoConstraints = false
//            scrollSubview.translatesAutoresizingMaskIntoConstraints = false
//            mainScrollview.translatesAutoresizingMaskIntoConstraints = false
//
//
//            let menuMgmtItems: [String: UIView] = ["addLabel": addLabel,
//                                                   "itemCategoryLabel": itemCategoryLabel,
//                                                   "addCategoryButton": addCategoryButton,
//                                                   "itemLabel": itemLabel,
//                                                   "addImageButton": addImageButton,
//                                                   "saveItemButton": saveItemButton,
//                                                   "itemOptionsLbl": itemOptionsLbl,
//                                                   "itemCV": itemCV,
//                                                   "editItemsLbl": editItemsLbl,
//                                                   "line1": line1,
//                                                   "line2": line2,
//                                                   "allView": allView,
//                                                   "editMenuItemsCV": editMenuItemsCV]
//            NSLayoutConstraint.activate([
//                NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[addLabel]-40-[itemCategoryLabel]-25-[addCategoryButton]-100-[line1(1@1000)]-80-[itemLabel]-25-[addImageButton]-35-[saveItemButton]-180-[itemOptionsLbl]-70-[itemCV]-150-[line2(1)]-90-[editItemsLbl]-30-[allView]-60-[editMenuItemsCV(375)]|", options: [], metrics: nil, views: menuMgmtItems),
//
//                NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[backB]-100-[settingsB]-100-[menuManagementB]-40-|", options: [], metrics: nil, views: navBarViews),
//                NSLayoutConstraint.constraints(withVisualFormat: "H:[addCategoryB]-30-[tv]-30-|", options: [], metrics: nil, views: ["tv": categoryTV, "addCategoryB": addCategoryButton]),
//                NSLayoutConstraint.constraints(withVisualFormat: "H:[tv]-30-|", options: [], metrics: nil, views: itemViews),
//                NSLayoutConstraint.constraints(withVisualFormat: "H:[availabilityL]-105-[breakfastL]-45-[lunchL]-45-[dinnerL]-30-|", options: [], metrics: nil, views: itemTopViews)
//
//                ].flatMap{$0})
//        }
//
//
//        mainScrollview.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
//        mainScrollview.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
//        mainScrollview.topAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
//        mainScrollview.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
//
//        scrollSubview.leadingAnchor.constraint(equalTo: mainScrollview.leadingAnchor).isActive = true
//        scrollSubview.trailingAnchor.constraint(equalTo: mainScrollview.trailingAnchor).isActive = true
//        scrollSubview.bottomAnchor.constraint(equalTo: mainScrollview.bottomAnchor).isActive = true
//        scrollSubview.topAnchor.constraint(equalTo: mainScrollview.topAnchor).isActive = true
//        scrollSubview.widthAnchor.constraint(equalTo: mainScrollview.widthAnchor).isActive = true
//        scrollSubview.heightAnchor.constraint(equalToConstant: 3018).isActive = true
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
        isFromSave = true
        let dictOfArraysIsNotEmpty: Bool =  dictOfArrays.filter { $0.value.count > 0 }.count > 0
        //        let lunch = dictOfArrays.filter { $0.value.contains("Lunch") }.map{$0.key}
        //        let dinner = dictOfArrays.filter { $0.value.contains("Dinner") }.map{$0.key}
        //        let breakFast = dictOfArrays.filter { $0.value.contains("Breakfast") }.map{$0.key}
        //        print("lunch: \(lunch)")
        //        print("dinner: \(dinner)")
        //        print("breakFast: \(breakFast)")
        if let name = itemNameTextField.text, name != "", let price = itemPriceTextField.text, price != "", dictOfArraysIsNotEmpty {
            self.startIndicator()
            DataService.instance.saveItem(itemName: name, itemPrice: price, itemImage: self.addImageButton.currentBackgroundImage, categoryDictOfArray:  dictOfArrays) { (success) in
                if success {
                    self.itemSavedSuccess_View.isHidden = false
                    self.itemNameTextField.text = ""
                    self.itemPriceTextField.text = ""
                    self.addImageButton.setBackgroundImage(nil, for: .normal)
                    self.addImageButton.backgroundColor = customRed
                    self.itemTV.reloadData()
                    DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                        self.stopIndicator()
                        self.itemSavedSuccess_View.isHidden = true
                    }) 
                } else {
                    self.stopIndicator()
                }
            }
        } else {
            print("Item not saved")
            self.showError_ItemAddFailed()
        }
    }
    
    @IBAction func allButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func byCategoryButton_Pressed(_ sender: Any) {
        dropDown.show()
    }
    
    
    
    // MARK: - ACTIONS
    
    func getCategoryItems(categoryName: String) {
        var categoryUID = ""
        CATLOOP: for x in self.categories {
            if x.name == categoryName {
                categoryUID = x.uid
                break CATLOOP
            }
        }
        self.startIndicator()
        DataService.instance.getCategoryItems(categoryUID: categoryUID) { (dict, error) in
            self.items = [[String: AnyObject]]()
            self.stopIndicator()
            if let dict = dict {
                if categoryUID != "" {
                    for item in dict {
                        if let itemDict = (item.value as? [String: AnyObject]) {
                            var itemDetails = itemDict["itemDetails"]! as! [String: AnyObject]
                            itemDetails["itemId"] = item.key as AnyObject
                            self.items.append(itemDetails)
                        }
                    }
                } else {
                    for categories in dict {
                        if let categoryItems = (categories.value as? [String: AnyObject]) {
                            for item in categoryItems {
                                if let itemDict = (item.value as? [String: AnyObject]) {
                                    var itemDetails = itemDict["itemDetails"]! as! [String: AnyObject]
                                    itemDetails["itemId"] = item.key as AnyObject
                                    self.items.append(itemDetails)
                                }
                            }
                        }
                    }
                }
            }
            self.editMenuItemsCV.reloadData()
        }
    }
    
    func getItemOptions(itemID: String) {
        print(itemID)
        self.startIndicator()
        DataService.instance.getItemOption(itemId: itemID) { (dict, error) in
            self.itemOptions = [ItemOption]()
            self.stopIndicator()
            if let optionArray = dict {
                self.itemOptions = optionArray
            }
            self.itemCV.reloadData()
        }
    }
    
    @objc func addItemButtonAction(_ sender: UIButton) {
        if selectedItemId != "" {
            let shadowView = UIView(frame: CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height))
            shadowView.backgroundColor = UIColor.black.withAlphaComponent(0.8)
            self.view.addSubview(shadowView)
            let optionView = Bundle.main.loadNibNamed("ItemOptionsView", owner: self, options: nil)?.first as! ItemOptionsView
            optionView.frame = CGRect(x: 350, y: 150, width: optionView.frame.width, height: optionView.frame.height)
            optionView.addShadow()
            shadowView.addSubview(optionView)
            if sender.tag < self.itemOptions.count {
                let optionData = self.itemOptions[sender.tag]
                optionView.updateFields(optionData: optionData, optionIndex: sender.tag+1)
            } else {
                var optionData = ItemOption()
                optionData.itemId = selectedItemId
                optionView.updateFields(optionData: optionData, optionIndex: sender.tag+1)
            }
        } else {
            Utils.showAlert(title: "Alert", message: "Please select Menu Item to add or edit Menu Options", onSucces: nil)
        }
    }
    
    func getCategories() {
        self.startIndicator()
        DataService.instance.getCategories { (categories: [Category]?, error) in
            self.stopIndicator()
            guard let error = error else {
                if let c = categories {
                    self.categories = c
                    var categoryList = [String]()
                    categoryList.append("All")
                    for category in self.categories {
                        categoryList.append(category.name)
                    }
                    
                    self.dropDown.dataSource = categoryList
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
            self.startIndicator()
            DataService.instance.saveCategory(categoryName: categoryName) { (success) in
                self.stopIndicator()
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
    
    func showWhiteGrayCells(indexPath: IndexPath, cell: UITableViewCell) {
        if indexPath.row % 2 == 0 {     // For background color
            cell.backgroundColor = .white
        } else {
            cell.backgroundColor = customLightGray
        }
    }
   
    
    
    // MARK: - IMAGE PICKER
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        if picker == imagePicker, let img = info[UIImagePickerController.InfoKey.originalImage] as? UIImage {
            self.addImageButton.isEnabled = true
            self.addImageButton.backgroundColor = .clear
            self.addImageButton.setBackgroundImage(img, for: .normal)
        }
        picker.dismiss(animated: true, completion: nil)
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
            showWhiteGrayCells(indexPath: indexPath, cell: cell)
            return cell
        } else {
            let cell = tableView.dequeueReusableCell(withIdentifier: ADD_ITEM_CELL, for: indexPath) as! AddItemCell
            cell.parentVC = self
            if isFromSave {
                if indexPath.row == self.categories.count-1 {
                    self.isFromSave = false
                }
                cell.breakfastSwitch.isOn = false
                cell.lunchSwitch.isOn = false
                cell.dinnerSwitch.isOn = false
            }
            cell.breakfastSwitch.tag = indexPath.row
            cell.lunchSwitch.tag = indexPath.row
            cell.dinnerSwitch.tag = indexPath.row
            if self.categories.count > 0 {
                cell.categoryTitle.text = self.categories[indexPath.row].name
            }
            showWhiteGrayCells(indexPath: indexPath, cell: cell)
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
        } else if collectionView == editMenuItemsCV {
            return items.count
        } else {
            return 0
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == itemCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ItemOptionCell", for: indexPath) as! ItemOptionCell
            cell.addEditItemOptionsButton.tag = indexPath.item
            cell.configureCell(indexPath: indexPath)
            cell.addEditItemOptionsButton.removeTarget(self, action: #selector(addItemButtonAction(_:)), for: .touchUpInside)
            cell.addEditItemOptionsButton.addTarget(self, action: #selector(addItemButtonAction(_:)), for: .touchUpInside)
            if indexPath.item < self.itemOptions.count {
                cell.addEditItemOptionsButton.setTitleColor(.white, for: .normal)
                cell.addEditItemOptionsButton.backgroundColor = customRed
                cell.addEditItemOptionsButton.layer.masksToBounds = true
                cell.addEditItemOptionsButton.layer.borderWidth = 0
                cell.addEditItemOptionsButton.layer.borderColor = UIColor.clear.cgColor
            } else {
                cell.addEditItemOptionsButton.setTitleColor(.black, for: .normal)
                cell.addEditItemOptionsButton.backgroundColor = .white
                cell.addEditItemOptionsButton.layer.masksToBounds = true
                cell.addEditItemOptionsButton.layer.borderWidth = 3
                cell.addEditItemOptionsButton.layer.borderColor = UIColor.black.cgColor
            }
            return cell
        } else if collectionView == editMenuItemsCV {
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
            
            cell.foodImageView.image = items[indexPath.item]["itemImageURL"] as? String != nil ? UIImage(data: try! Data(contentsOf: (URL(string: items[indexPath.item]["itemImageURL"] as? String ?? ""))!)) :  #imageLiteral(resourceName: "Rectangle 4")
            cell.foodNameLabel.text = items[indexPath.row]["itemName"] as? String
            return cell
        } else {
            return UICollectionViewCell()
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == editMenuItemsCV {
            if let itemId = items[indexPath.item]["itemId"] as? String {
                selectedItemId = itemId
                getItemOptions(itemID: itemId)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == editMenuItemsCV {
            let screenWidth = ((UIScreen.main.bounds.width-220)/4) - 10
            return CGSize(width: screenWidth, height: 212.0)
        }
        return CGSize(width: 122, height: 122)
    }
    
    
    // MARK: - ALERTS
    
    func showError_CategoryAddFailed() {
        let alertController = UIAlertController(title: "Error", message: "There was an issue uploading your category. Please try again later.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Ok", style: .default, handler: { [unowned self] (action: UIAlertAction) in
            self.addCategoryView.isHidden = true
        })
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    @objc func renameCategoryFunc(sender: UIButton) {
        let  ac = UIAlertController(title: "Rename Category", message: "", preferredStyle: .alert)
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
        let  okAction = UIAlertAction(title: "Okay", style: .default) { [weak self] (action) in
            guard let selff = self else { return }
            selff.startIndicator()
            DataService.instance.renameCategory(categoryUID: (selff.categories[sender.tag].uid)!, updatedName: ac.textFields![0].text!, completion: { [weak self] (update) in
                guard let selff = self else { return }
                selff.stopIndicator()
            })
        }
        ac.addTextField { [weak self] (textfield) in
            textfield.text = self?.categories[sender.tag].name
            print(self?.categories[sender.tag].uid)
        }
        ac.addAction(okAction)
        ac.addAction(cancelAction)
        self.present(ac, animated: true, completion: nil)
    }
    
    @objc func deleteCategoryFunc(sender: UIButton) {
        self.startIndicator()
        DataService.instance.deleteCategory(categoryUID: (self.categories[sender.tag].uid)!) { [weak self] (success) in
            guard let selff = self else {
                return
            }
            selff.stopIndicator()
            if success {
                selff.successfullyDeletedCategory_Alert()
            } else {
                selff.errorDeletingCategory_Alert()
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
    
    func showError_ItemAddFailed() {
        let alertController = UIAlertController(title: "Item Not Saved", message: "Make sure the item name, price & availability have been set before saving.", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "Okay", style: .default, handler: nil)
        alertController.addAction(okAction)
        present(alertController, animated: true, completion: nil)
    }
    
    
}
