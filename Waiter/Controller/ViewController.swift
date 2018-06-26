
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
    var checkoutDict: [String: AnyObject]!
    var tag = 0
    var menuData = [[String: [[String: [String: AnyObject]]]]]()
    var arrCategory = [CategoryDetail]()
    var currIndex = 0
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        print(menuData)
        hideKeyboardWhenTappedAround()
        
        tv.delegate = self; tv.dataSource = self
        cv1.delegate = self; cv1.dataSource = self
        cv2.delegate = self; cv2.dataSource = self
        
        let layoutCV2 = UICollectionViewFlowLayout()
        layoutCV2.scrollDirection = .vertical
        layoutCV2.minimumInteritemSpacing = 20
        layoutCV2.minimumLineSpacing = 60
        
        cv1.isUserInteractionEnabled = true
        cv2.allowsMultipleSelection = false
        cv2.isUserInteractionEnabled = true
        
        var order = "Breakfast"
        
        if tag == 1 {
            
            order = "Lunch"
        }
        else if tag == 2 {
            
            order = "Dinner"
        }
        
        DataManager.shared().getCategoryList(order: order) { (arycategory) in
            
            self.arrCategory = arycategory
            self.cv1.reloadData()
            self.cv2.reloadData()
        }
        
        tv.register(CheckoutCell.self, forCellReuseIdentifier: "CheckoutCell")
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
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let checkoutCell = tableView.dequeueReusableCell(withIdentifier: "CheckoutCell", for: indexPath) as! CheckoutCell
        
        return checkoutCell
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //return checkoutDict.count
        return 3
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
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        var count: Int?
        
        if collectionView == self.cv1 {
            
            count = arrCategory.count
            
        } else if collectionView == self.cv2 {
            
            if arrCategory.count > 0 {
             
                count = arrCategory[currIndex].categoryItemList.count
            }
            else {
                
                return 0
            }
            
            
            // count = foodsArray.count
        }
        
        return count!
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        if collectionView == cv1 {
            
        }
    }
    
   @objc func catClick(sender:UIButton) {
        
        currIndex = sender.tag
        cv2.reloadData()
    }
    
}

