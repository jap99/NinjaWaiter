//
//  ContinueOrderVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class ContinueOrderVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate {

    @IBOutlet weak var cv1: UICollectionView!

    
    @IBOutlet weak var placeTakeAwayButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var chooseTableView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        cv1.delegate = self; cv1.dataSource = self
        cv1.reloadData()
        
        chooseTableView.layer.cornerRadius = 7.0 
    }

 
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        if collectionView == self.cv1 {
            
            let  cellCV1 = collectionView.dequeueReusableCell(withReuseIdentifier: "TableCell", for: indexPath) as! TableCell
            cellCV1.tableNumberLabel.text = String(indexPath.row + 1)
            cellCV1.tableNumberLabel.tintColor = .black
            return cellCV1
            
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
        
        if collectionView == self.cv1 && Singleton.sharedInstance.settingsData[0].totalTable > 0 {
           count = Singleton.sharedInstance.settingsData[0].totalTable
        } else {
            
            noTablesToShow_Alert()
            
        }
        return count!
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerVC-ID") as! ViewController
        self.present(vc, animated: true, completion: {
            
        })
    }
    
    @IBAction func placeTakeAwayButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderSuccessVC-ID") as! OrderSuccessVC
        self.present(vc, animated: true, completion: {
            
        })
    }
    
    // MARK: - ALERTS
    
    func noTablesToShow_Alert() {
        
        let ac = UIAlertController(title: "Sorry", message: "No tables available to show. If you the admin to this account, you may configure this screen from the Settings screen.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        
        present(ac, animated: true, completion: {// [weak self] in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        })
    }
    
}
