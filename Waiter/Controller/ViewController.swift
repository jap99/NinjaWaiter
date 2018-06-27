
//
//  ViewController.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/16/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, UICollectionViewDelegate, UICollectionViewDataSource {
    
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
    }
    
    @IBAction func goback(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
        self.present(vc, animated: true, completion: {
            
        })
    }
    
    @IBAction func confirmOrder(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ContinueOrderVC-ID") as! ContinueOrderVC
        self.present(vc, animated: true, completion: {
            
        })
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
        
        checkoutCell.configureCell(indexPath: indexPath, cartDictionaries: cart)
        return checkoutCell
    }
    
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if collectionView == self.cv1 {

            let  cellCV1 = collectionView.dequeueReusableCell(withReuseIdentifier: "SectionCell", for: indexPath) as! SectionCell

            cellCV1.foodNameLabel.tag = indexPath.row
            cellCV1.foodNameLabel.addTarget(self, action: #selector(catClick(sender:)), for: .touchUpInside)
            cellCV1.foodNameLabel.setTitle(arrCategory[indexPath.row].categoryName, for: .normal)
            return cellCV1

        } else if collectionView == self.cv2 {

            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell

            let data = arrCategory[currIndex].categoryItemList

            cell.foodNameLabel.text = data[indexPath.row].itemName
            cell.giveBorder(selected: data[indexPath.row].isSelected)

            if data[indexPath.row].itemImage != "" {

                let data = try? Data(contentsOf: URL(string: data[indexPath.row].itemImage)!) //make sure your image in this url does exist, otherwise unwrap in a if let check / try-catch
                cell.foodImageView.image = UIImage(data: data!)
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
        if collectionView == cv1 {
            print("PRINTING CV1 PRESSED")
        } else if collectionView == cv2 {
            arrCategory[currIndex].categoryItemList[indexPath.row].isSelected = !arrCategory[currIndex].categoryItemList[indexPath.row].isSelected
            let itemPrice = arrCategory[currIndex].categoryItemList[indexPath.row].itemPrice
            let itemName = arrCategory[currIndex].categoryItemList[indexPath.row].itemName
            let itemData: Dictionary<String, AnyObject> = [
                itemName: itemPrice as AnyObject
            ]
            cart.append(itemData)
            print("PRINTING CART ARRAY DATA: \(cart)")
            cv2.reloadData()
            tv.reloadData()
        }
    }
    
    
    // MARK: - ACTIONS
    
    func setupObjectsWithSettingsData() {
        
        DataService.instance.getSettingsData { (dict, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let dict = dict {
                print(dict)
                
                if let discount = dict["discountText"] {
                    self.discountLabel_Left.text = "\(discount as! String)% Discount"
                }
                
                if let s = dict["serviceChargeText"] {
                    self.serviceChargeLabel_Left.text =  "\(s as! String)% Service Charge"
                }
                
                if let t1 = dict["tax1NameText"], let t1p = dict["taxPercentage1NameText"] {
                    self.tax1Label_Left.text = "\(t1p as! String)% \(t1 as! String)"
                }
                
                if let t2 = dict["tax2NameText"], let t2p = dict["taxPercentage2NameText"] {
                    self.tax2Label_Left.text = "\(t2p as! String)% \(t2 as! String)"
                }
            }
        }
    }
    
    func getMenuData() {
        var order = "Breakfast"
        if tag == 1 { order = "Lunch" } else if tag == 2 { order = "Dinner" }
        
        DataManager.shared().getCategoryList(order: order) { (arycategory) in
            
            self.arrCategory = arycategory
            self.cv1.reloadData()
            self.cv2.reloadData()
        }
    }
    
    @objc func catClick(sender: UIButton) {
        
        currIndex = sender.tag
        cv2.reloadData()
    }
}

