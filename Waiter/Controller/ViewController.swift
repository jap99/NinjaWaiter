
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
    @IBOutlet weak var subtotalLabel: UILabel!
    @IBOutlet weak var fivePercentDiscountLabel: UILabel!
    @IBOutlet weak var tenPercentChargeLabel: UILabel!
    @IBOutlet weak var sixPercentGstLabel: UILabel!
    @IBOutlet weak var totalLabel: UILabel!
    
    @IBOutlet weak var exitButton: UIButton!
    var sectionsArray: [String]!
    var foodsArray: [String]!
    var checkoutDict: [String: AnyObject]!
    
    override func viewDidLoad() {
    super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        cv1.delegate = self; cv1.dataSource = self
//        cv1.register(SectionCell.self, forCellWithReuseIdentifier: "SectionCell")
        cv2.delegate = self; cv2.dataSource = self
        cv2.register(FoodCell.self, forCellWithReuseIdentifier: "FoodCell")
        tv.delegate = self; tv.dataSource = self
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
                
                cellCV1.foodNameLabel.setTitle(String(Singleton.sharedInstance.categoriesItems[indexPath.row].name), for: .normal)
                return cellCV1
            
            } else if collectionView == self.cv2 {
                let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "FoodCell", for: indexPath) as! FoodCell
                
                return cell
            } else {
                var cell: UICollectionViewCell?
                return cell!
            }
        }
    
        func numberOfSections(in collectionView: UICollectionView) -> Int {
            return 1
        }
            
        func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
            var count: Int?
//
            if collectionView == self.cv1 {
                
                count = Singleton.sharedInstance.categoriesItems.count
            
            } else {
                count = 1
            }
//            if collectionView == self.cv2 {
//                count = foodsArray.count
//            }
//
            return count!
//            return 1
        }
}

