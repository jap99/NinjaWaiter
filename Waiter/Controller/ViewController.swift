
//
//  ViewController.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/16/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import CoreData

class ViewController: BaseViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout, UIPopoverPresentationControllerDelegate {
    
    @IBOutlet weak var cv1: UICollectionView!
    @IBOutlet weak var cv2: UICollectionView!
    @IBOutlet weak var tv: UITableView!
    
    @IBOutlet weak var confirmOrderButton: UIButton!
    @IBOutlet weak var subtotalLabel_Left: UILabel!
    @IBOutlet weak var subtotalLabel_Right: UILabel!
    @IBOutlet weak var discountLabel_Left: UILabel!
    @IBOutlet weak var discountLabel_Right: UILabel!
    @IBOutlet weak var serviceChargeLabel_Left: UILabel!
    @IBOutlet weak var serviceChargeLabel_Right: UILabel!
    @IBOutlet weak var tax1Label_Left: UILabel!
    @IBOutlet weak var tax1Label_Right: UILabel!
    @IBOutlet weak var tax2Label_Left: UILabel!
    @IBOutlet weak var tax2Label_Right: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var exitButton: UIButton!
    
    var sectionsArray: [String]!
    var foodsArray: [Item]! // used in cv2
    //var checkoutDict: [String: AnyObject]!
    var tag = 0
    var menuData = [[String: [[String: [String: AnyObject]]]]]()
    var arrCategory: [CategoryDetail]?
    var currIndex = 0
    var cart = [CategoryItems]()
    var categoryType = CategoryType.none
    
    var discountPercentage = 0.0
    var serviceChargePercentage = 0.0
    var tax1Percentage = 0.0
    var tax2Percentage = 0.0
    
    
    
    // MARK: - INIT
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setup1()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        setup2()
    }
    
    
    
    // MARK: - SETUP
    
    func setup1() {
        tv.delegate = self; tv.dataSource = self
        cv1.delegate = self; cv1.dataSource = self
        cv2.delegate = self; cv2.dataSource = self
        tv.rowHeight = UITableView.automaticDimension
        tv.estimatedRowHeight = 1000
        //        let layoutCV2 = UICollectionViewFlowLayout()
        //        layoutCV2.scrollDirection = .vertical
        //        layoutCV2.minimumInteritemSpacing = 20
        //        layoutCV2.minimumLineSpacing = 60
        cv1.isUserInteractionEnabled = true
        cv1.allowsMultipleSelection = false
        cv2.allowsMultipleSelection = true
        cv2.isUserInteractionEnabled = true
    }
    
    func setup2() {
        getMenuData()
        setupObjectsWithSettingsData()
        self.tv.isHidden = false
        tv.separatorStyle = .none
        updateCartTotal()
        getDataFromFirebase()
    }
    
    
    
    // MARK: - IB_ACTIONS
    
    @IBAction func goback(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
        self.present(vc, animated: true, completion: {
            
        })
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        if cart.count > 0 {
            let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContinueOrderVC-ID") as! ContinueOrderVC
            self.present(vc, animated: true, completion: nil)
        } else {
            noItemsInCart_Alert()
        }
        
    }
    
    
    
    @objc func removeItemFromCart(_ sender: AnyObject) {
        if let btn = sender as? UIButton {
            if cart.count > btn.tag {
                cart.remove(at: btn.tag)
                updateCartTotal()
            }
        }
    }
    
    func getItemOptions(menuItem: CategoryItems, sourceView: UIView) {
        if menuItem.itemId != "" {
            self.startIndicator()
            DataService.instance.getItemOption(itemId: menuItem.itemId) { (dict, error) in
                self.stopIndicator()
                if let optionArray = dict {
                    menuItem.optionList = optionArray
                }
                if menuItem.optionList.count > 0 {
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    if let pc = storyBoard.instantiateViewController(withIdentifier: "ItemOptionPopupVC") as? ItemOptionPopupVC {
                        pc.menuItem = menuItem
                        pc.delegate = self
 //                       pc.modalPresentationStyle = .none
//                        let screenFrame = UIScreen.main.bounds
//                        pc.preferredContentSize = CGSize(width: screenFrame.width*0.4, height: screenFrame.height*0.6)
//                        pc.popoverPresentationController?.delegate = self
//                        pc.popoverPresentationController?.sourceView = sourceView
//                        pc.popoverPresentationController?.sourceRect = sourceView.bounds
                        self.present(pc, animated: true, completion: nil)
                    }
                } else {
                    self.addItemToCart(menuItem: menuItem)
                }
            }
        }
    }
    
    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }
    

    // MARK: - ACTIONS
    
    @objc func catClick(sender: UIButton) {
        self.currIndex = sender.tag
        self.cv1.reloadData()
        self.cv2.reloadData()
    }
    
    
    func setround2Decimal(str:Double) -> String {
        var finalStr = String()
        finalStr = String(format: "%.2f", str)
        return finalStr
    }
    
    
    func setupObjectsWithSettingsData() {
        self.startIndicator()
        DataService.instance.getSettingsData { (dict, error) in
            self.stopIndicator()
            if let error = error {
                print(error.localizedDescription)
            } else if let dict = dict {
                DispatchQueue.main.async {
                    if let discount = dict["discountText"] {
                        self.discountPercentage = (discount as! NSString).doubleValue
                        self.discountLabel_Left.text = "\(discount as! String)% Discount"
                    }
                    if let s = dict["serviceChargeText"] {
                        self.serviceChargePercentage = (s as! NSString).doubleValue
                        self.serviceChargeLabel_Left.text =  "\(s as! String)% Service Charge"
                    }
                    if let t1 = dict["tax1NameText"], let t1p = dict["taxPercentage1NameText"] {
                        self.tax1Percentage = (t1p as! NSString).doubleValue
                        self.tax1Label_Left.text = "\(t1p as! String)% \(t1 as! String)"
                    }
                    if let t2 = dict["tax2NameText"], let t2p = dict["taxPercentage2NameText"] {
                        self.tax2Percentage = (t2p as! NSString).doubleValue
                        self.tax2Label_Left.text = "\(t2p as! String)% \(t2 as! String)"
                    }
                }
            }
        }
    }
    
    
    func updateCartTotal() {
        var subTotal = 0.0
        var discount = 0.0
        var serviceTax = 0.0
        var tax1 = 0.0
        var tax2 = 0.0
        var total = 0.0
        for cartItem in self.cart {
            let price = cartItem.itemPrice as NSString
            subTotal = subTotal + price.doubleValue
            for option in cartItem.optionList {
                if option.isOptionSelected {
                    let price = option.optionPrice as NSString
                    subTotal = subTotal + price.doubleValue
                }
            }
        }
        discount = subTotal * discountPercentage/100
        let taxAbleAmount = subTotal - discount
        serviceTax = taxAbleAmount * serviceChargePercentage/100
        tax1 = taxAbleAmount * tax1Percentage/100
        tax2 = taxAbleAmount * tax2Percentage/100
        total = subTotal - discount + serviceTax + tax1 + tax2
        subtotalLabel_Right.text = self.setround2Decimal(str: subTotal)
        discountLabel_Right.text = "-\(self.setround2Decimal(str: discount))"
        serviceChargeLabel_Right.text = "+\(self.setround2Decimal(str: serviceTax))"
        tax1Label_Right.text = "+\(self.setround2Decimal(str: tax1))"
        tax2Label_Right.text = "+\(self.setround2Decimal(str: tax2))"
        totalLabel.text = "\(self.setround2Decimal(str: total))"
        self.tv.reloadData()
    }
    
    
    func getDataFromFirebase() {
        self.startIndicator()
        DataManager.shared().getCategoryList(order:CategoryType.breakfast.rawValue) { [weak self] (arrayCategory) in
            guard let sself = self, let arrayCategory = arrayCategory else {
                return 
            }
            sself.stopIndicator()
            for cat in arrayCategory {
                let category = CategoryEntity.createNewEntity(key:"categoryUID", value:cat.categoryId as NSString)
                category.updateWith(cat: cat, type: sself.categoryType)
            }
            _appDel.saveContext()
            sself.getMenuData()
        }
    }
    
    func getMenuData() {
        /*var order = "Breakfast"
        if tag == 1 { order = "Lunch" } else if tag == 2 { order = "Dinner" }
        DataManager.shared().getCategoryList(order: order) { (arycategory) in
            DispatchQueue.main.async {
                self.arrCategory = arycategory
                self.cv1.reloadData()
                self.cv2.reloadData()
            }
        } */
        var arrCat = [CategoryDetail]()
        let predicate = NSPredicate(format: "categroyType == %@", argumentArray:[categoryType.rawValue])
        let arrayCategory = CategoryEntity.fetchDataFromEntity(predicate: predicate, sortDescs: nil)
        for cate in arrayCategory {
            let cateDetails = CategoryDetail()
            cateDetails.converFrom(cat:cate)
            arrCat.append(cateDetails)
        }
        self.arrCategory = arrCat
        _appDel.saveContext()
        self.cv1.reloadData()
        self.cv2.reloadData()
    }
    

    
    
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let checkoutCell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as? CheckoutCell {
            checkoutCell.xButton.tag = indexPath.row
            checkoutCell.xButton.removeTarget(self, action: #selector(ViewController.removeItemFromCart(_:)), for: .touchUpInside)
            checkoutCell.xButton.addTarget(self, action: #selector(ViewController.removeItemFromCart(_:)), for: .touchUpInside)
            checkoutCell.configureCell(indexPath: indexPath, cartItem: cart[indexPath.row])
            return checkoutCell
        }
        return UITableViewCell()
    }
    
    
    
    // MARK: - COLLECTION VIEW
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cv1 {
            guard let  cellCV1 = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as? SectionCell,
            let arrCategory = self.arrCategory else {
                return UICollectionViewCell()
            }
            cellCV1.foodNameLabel.tag = indexPath.row
            cellCV1.foodNameLabel.removeTarget(self, action: #selector(catClick(sender:)), for: .touchUpInside)
            cellCV1.foodNameLabel.addTarget(self, action: #selector(catClick(sender:)), for: .touchUpInside)
            cellCV1.foodNameLabel.setTitle(arrCategory[indexPath.row].categoryName, for: .normal)
            if self.currIndex == indexPath.row {
                cellCV1.selectorView.isHidden = false
            } else {
                cellCV1.selectorView.isHidden = true
            }
            return cellCV1
        } else if collectionView == self.cv2 {
            guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as? FoodCell,
                let arrCategory = self.arrCategory else { return UICollectionViewCell() }
            if arrCategory.count > 0 {
                cell.foodImageView.image = nil
                print(arrCategory[self.currIndex].categoryItemList)
                let data = arrCategory[self.currIndex].categoryItemList
                cell.foodNameLabel.text = data[indexPath.row].itemName
                cell.giveBorder(selected: data[indexPath.row].isSelected)
                let  imgURL =  data[indexPath.row].itemImage
                if imgURL.isEmpty == false {
                    cell.foodImageView.kf.setImage(with:URL(string:imgURL))
                }
            } else {
            }
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        guard let arrCategory = arrCategory else { return 30 }
        if collectionView == self.cv1 {
            return arrCategory.count
        } else { // we're in cv2 now
            if arrCategory.count > 0 {
                return arrCategory[currIndex].categoryItemList.count
            } else {
                return 30
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let arrCategory = arrCategory else { return }
        if collectionView == cv2 {
            print(indexPath.row, arrCategory.count)
            if arrCategory.count > 0 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
                let menuItem: CategoryItems = arrCategory[currIndex].categoryItemList[indexPath.row]
                self.getItemOptions(menuItem: menuItem, sourceView: cell.foodImageView)
            } else {
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuManagementVC-ID") as! MenuManagementVC
                present(vc, animated: true, completion: nil)
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cv2 {
            let screenWidth = (UIScreen.main.bounds.width*0.67-40)/3-1
            return CGSize(width: screenWidth, height: 212.0)
        }
        return CGSize(width: 189, height: 50)
    }
    
    
    
    // MARK: - ALERTS
    
    func noItemsInCart_Alert() {
        let ac = UIAlertController(title: "CART EMPTY", message: "No items have been added to the cart.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as? DashboardVC {
                self.present(vc, animated: true, completion: nil)
            }
        })
        ac.addAction(ok)
        present(ac, animated: true, completion: { [weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                ac.dismiss(animated: true, completion: {
                    if let vc = self?.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as? DashboardVC {
                        self?.present(vc, animated: true, completion: nil)
                    }
                })
            })
        })
    }
}


extension ViewController: ItemOptionDelegate {
    
    func addItemToCart(menuItem: CategoryItems) {
        self.cart.append(menuItem.copyObject())
        updateCartTotal()
    }
    
}
