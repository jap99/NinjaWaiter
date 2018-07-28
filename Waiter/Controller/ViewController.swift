
//
//  ViewController.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/16/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
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
    var arrCategory = [CategoryDetail]()
    var currIndex = 0
    var cart = [[String: AnyObject]]()
    var categoryType = CategoryType.none
    
    var discountPercentage = 0.0
    var serviceChargePercentage = 0.0
    var tax1Percentage = 0.0
    var tax2Percentage = 0.0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv.delegate = self; tv.dataSource = self
        cv1.delegate = self; cv1.dataSource = self
        cv2.delegate = self; cv2.dataSource = self
        
//        let layoutCV2 = UICollectionViewFlowLayout()
//        layoutCV2.scrollDirection = .vertical
//        layoutCV2.minimumInteritemSpacing = 20
//        layoutCV2.minimumLineSpacing = 60
        
        cv1.isUserInteractionEnabled = true
        cv1.allowsMultipleSelection = false
        cv2.allowsMultipleSelection = true
        cv2.isUserInteractionEnabled = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        getMenuData()
        setupObjectsWithSettingsData()
        self.tv.isHidden = false
        tv.separatorStyle = .none
        updateCartTotal()
        getDataFromFirebase()
    }
    
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
    
    // MARK: - TABLE VIEW
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return cart.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let checkoutCell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell
        
        checkoutCell.xButton.tag = indexPath.row
        checkoutCell.xButton.removeTarget(self, action: #selector(ViewController.removeItemFromCart(_:)), for: .touchUpInside)
        checkoutCell.xButton.addTarget(self, action: #selector(ViewController.removeItemFromCart(_:)), for: .touchUpInside)
        
        checkoutCell.configureCell(indexPath: indexPath, cartDictionaries: cart)
        return checkoutCell
    }
    
    @objc func removeItemFromCart(_ sender: AnyObject) {
        if let btn = sender as? UIButton {
            if cart.count > btn.tag {
                let removeItemId = sender.accessibilityIdentifier
                var i = 0
                ItemLoop: for item in arrCategory[currIndex].categoryItemList {
                    if item.itemId == removeItemId {
                        arrCategory[currIndex].categoryItemList[i].isSelected = false
                        break ItemLoop
                    }
                    i  += 1
                }
                
                cart.remove(at: btn.tag)
                self.cv2.reloadData()
                self.tv.reloadData()
            }
        }
        updateCartTotal()
    }
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cv1 {

            let  cellCV1 = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionCell

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
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
            cell.foodImageView.image = nil 
            let data = self.arrCategory[self.currIndex].categoryItemList
            
            cell.foodNameLabel.text = data[indexPath.row].itemName
            cell.giveBorder(selected: data[indexPath.row].isSelected)
            let  imgURL =  data[indexPath.row].itemImage
            if imgURL.isEmpty == false {
                cell.foodImageView.kf.setImage(with:URL(string:imgURL))
            }
            return cell
        } else {
            let cell = UICollectionViewCell()
            return cell
        }
    }
    
    // number of sections
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    // number of items
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int?
        if collectionView == self.cv1 {
            count = arrCategory.count
        } else if collectionView == self.cv2 {
            if arrCategory.count > 0 {
                count = arrCategory[currIndex].categoryItemList.count
            } else {
                return 0
            }
        }
        return count!
    }
    
    // did select item
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cv2 {
            arrCategory[currIndex].categoryItemList[indexPath.row].isSelected = !arrCategory[currIndex].categoryItemList[indexPath.row].isSelected
            
            let itemId = arrCategory[currIndex].categoryItemList[indexPath.row].itemId
            if arrCategory[currIndex].categoryItemList[indexPath.row].isSelected {
                let itemPrice = arrCategory[currIndex].categoryItemList[indexPath.row].itemPrice
                let itemName = arrCategory[currIndex].categoryItemList[indexPath.row].itemName
                let itemData: Dictionary<String, AnyObject> = [
                    "itemName" : itemName as AnyObject,
                    "itemPrice" : itemPrice as AnyObject,
                    "ItemID": itemId as AnyObject
                ]
                self.cart.append(itemData)
            } else {
                var i = 0
                CartLoop: for cartItem in self.cart {
                    if cartItem["ItemID"] as! String == itemId {
                        break CartLoop
                    }
                    i += 1
                }
                self.cart.remove(at: i)
            }
            
            self.cv2.reloadData()
            self.tv.reloadData()
            updateCartTotal()
            
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didDeselectItemAt indexPath: IndexPath) {
        if collectionView == cv2 {
        }
    }
    
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if collectionView == cv2 {
            let screenWidth = (UIScreen.main.bounds.width*0.67-40)/3-1
            return CGSize(width: screenWidth, height: 212.0)
        }
        return CGSize(width: 189, height: 50)
    }
    
    // MARK: - ACTIONS
    
    func setupObjectsWithSettingsData() {
        
        DataService.instance.getSettingsData { (dict, error) in
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
    func setround2Decimal(str:Double) -> String {
        
        var finalStr = String()
        
       finalStr = String(format: "%.2f", str)
        //
        return finalStr
        
    }
    func updateCartTotal() {
        var subTotal = 0.0
        var discount = 0.0
        var serviceTax = 0.0
        var tax1 = 0.0
        var tax2 = 0.0
        var total = 0.0
        
        for cartItem in self.cart {
            subTotal = subTotal + (cartItem["itemPrice"] as! NSString).doubleValue
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
        
    }
    
    func getDataFromFirebase() {
        DataManager.shared().getCategoryList(order:CategoryType.breakfast.rawValue) { (arrayCategory) in
            
            for cat in arrayCategory {
                let category = CategoryEntity.createNewEntity(key:"categoryUID", value:cat.categoryId as NSString)
                category.updateWith(cat: cat, type: self.categoryType)
            }
            _appDel.saveContext()
            self.getMenuData()
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
        let arrCategory = CategoryEntity.fetchDataFromEntity(predicate:predicate, sortDescs:nil)
        for cate in arrCategory {
            let cateDetails = CategoryDetail()
            cateDetails.converFrom(cat:cate)
            arrCat.append(cateDetails)
        }
        self.arrCategory = arrCat
        _appDel.saveContext()
        self.cv1.reloadData()
        self.cv2.reloadData()
        
    }
    
    @objc func catClick(sender: UIButton) {
        self.currIndex = sender.tag
        self.cv1.reloadData()
        self.cv2.reloadData()
    }
    
    // MARK: - ALERTS
    
    func noItemsInCart_Alert() {
        let ac = UIAlertController(title: "No Items In Cart", message: "No items have been added to the cart. Please add at least one item to the cart to checkout.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: { (_) in
            if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as? DashboardVC {
                self.present(vc, animated: true, completion: nil)
            }
        })
        
        ac.addAction(ok)
        
        present(ac, animated: true, completion: {// [weak self] in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                
                ac.dismiss(animated: true, completion: {
                    
                    if let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as? DashboardVC {
                        self.present(vc, animated: true, completion: nil)
                    }
                    
                })
            })
        })
    }
}

