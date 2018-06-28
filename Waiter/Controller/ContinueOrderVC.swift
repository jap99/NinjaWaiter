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
    
    @IBOutlet weak var oneImageView: UIImageView!
    @IBOutlet weak var twoImageView: UIImageView!
    @IBOutlet weak var threeImageView: UIImageView!
    @IBOutlet weak var fourImageView: UIImageView!
    @IBOutlet weak var fiveImageView: UIImageView!
    @IBOutlet weak var sixImageView: UIImageView!
    @IBOutlet weak var sevenImageView: UIImageView!
    @IBOutlet weak var eightImageView: UIImageView!
    @IBOutlet weak var nineImageView: UIImageView!
    @IBOutlet weak var zeroImageView: UIImageView!
    @IBOutlet weak var deleteImageView: UIImageView!
    
    @IBOutlet weak var placeTakeAwayButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    @IBOutlet weak var chooseTableView: UIView!
    
    var phoneNumber = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        cv1.delegate = self; cv1.dataSource = self
        cv1.reloadData()
        setupGestureRecognizers()
        chooseTableView.layer.cornerRadius = 7.0 
    }

    func setupGestureRecognizers() {
        
        oneImageView.isUserInteractionEnabled = true
        twoImageView.isUserInteractionEnabled = true
        threeImageView.isUserInteractionEnabled = true
        fourImageView.isUserInteractionEnabled = true
        fiveImageView.isUserInteractionEnabled = true
        sixImageView.isUserInteractionEnabled = true
        sevenImageView.isUserInteractionEnabled = true
        eightImageView.isUserInteractionEnabled = true
        nineImageView.isUserInteractionEnabled = true
        zeroImageView.isUserInteractionEnabled = true
        deleteImageView.isUserInteractionEnabled = true
        
        oneImageView.tag = 1
        twoImageView.tag = 2
        threeImageView.tag = 3
        fourImageView.tag = 4
        fiveImageView.tag = 5
        sixImageView.tag = 6
        sevenImageView.tag = 7
        eightImageView.tag = 8
        nineImageView.tag = 9
        zeroImageView.tag = 0
        
        let tapGesture = UITapGestureRecognizer(target: self, action: #selector(self.providePhoneNumber(_:)))
        
        oneImageView.addGestureRecognizer(tapGesture)
        twoImageView.addGestureRecognizer(tapGesture)
        threeImageView.addGestureRecognizer(tapGesture)
        fourImageView.addGestureRecognizer(tapGesture)
        fiveImageView.addGestureRecognizer(tapGesture)
        sixImageView.addGestureRecognizer(tapGesture)
        sevenImageView.addGestureRecognizer(tapGesture)
        eightImageView.addGestureRecognizer(tapGesture)
        nineImageView.addGestureRecognizer(tapGesture)
        zeroImageView.addGestureRecognizer(tapGesture)
        
        tapGesture.numberOfTapsRequired = 1
        tapGesture.numberOfTouchesRequired = 1

    }
    
    @objc func providePhoneNumber(_ sender: UIImageView) {
        
        phoneNumber = "\(phoneNumber)\(sender.tag)"
        phoneNumberTextField.text = phoneNumber
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
        var count: Int = 0
        
        print(Singleton.sharedInstance.settingsData[0].totalTable)
        if collectionView == self.cv1 && Singleton.sharedInstance.settingsData[0].totalTable > 0 {
           count = Singleton.sharedInstance.settingsData[0].totalTable
        } else {
            
            noTablesToShow_Alert()
            
        }
        return count
    }
    
    
    // MARK: - IBACTIONS
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "ViewControllerVC-ID") as! ViewController
        self.present(vc, animated: true, completion: nil)
    }
    
    @IBAction func placeTakeAwayButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderSuccessVC-ID") as! OrderSuccessVC
        self.present(vc, animated: true, completion: nil)
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
