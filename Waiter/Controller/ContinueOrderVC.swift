//
//  ContinueOrderVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class ContinueOrderVC: UIViewController, UICollectionViewDataSource, UICollectionViewDelegate{//}, UIGestureRecognizerDelegate{

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
    
    var phoneNumber = " "
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        hideKeyboardWhenTappedAround()
        cv1.delegate = self; cv1.dataSource = self
        cv1.reloadData()
        setupGestureRecognizers()
        chooseTableView.layer.cornerRadius = 7.0
        
//        let layout: UICollectionViewFlowLayout = UICollectionViewFlowLayout()
//        layout.sectionInset = UIEdgeInsets(top: 20, left: 0, bottom: 10, right: 0)
//        layout.itemSize = CGSize(width: 172, height: 172)
//        layout.minimumInteritemSpacing = 20
//        layout.minimumLineSpacing = 20
//        cv1!.collectionViewLayout = layout
    }

    func setupGestureRecognizers() {
        
        let tapGesture0 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber0))
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber1))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber2))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber3))
        let tapGesture4 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber4))
        let tapGesture5 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber5))
        let tapGesture6 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber6))
        let tapGesture7 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber7))
        let tapGesture8 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber8))
        let tapGesture9 = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumber9))
        let tapGestureDelete = UITapGestureRecognizer(target: self, action: #selector(providePhoneNumberDelete(_:)))
        
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
        
        oneImageView.addGestureRecognizer(tapGesture1)
        twoImageView.addGestureRecognizer(tapGesture2)
        threeImageView.addGestureRecognizer(tapGesture3)
        fourImageView.addGestureRecognizer(tapGesture4)
        fiveImageView.addGestureRecognizer(tapGesture5)
        sixImageView.addGestureRecognizer(tapGesture6)
        sevenImageView.addGestureRecognizer(tapGesture7)
        eightImageView.addGestureRecognizer(tapGesture8)
        nineImageView.addGestureRecognizer(tapGesture9)
        zeroImageView.addGestureRecognizer(tapGesture0)
        deleteImageView.addGestureRecognizer(tapGestureDelete)
    }
    
    @objc func providePhoneNumber0() {
        phoneNumber = "\(phoneNumber)0"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber1() {
        phoneNumber = "\(phoneNumber)1"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber2() {
        phoneNumber = "\(phoneNumber)2"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber3() {
        phoneNumber = "\(phoneNumber)3"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber4() {
        phoneNumber = "\(phoneNumber)4"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber5() {
        phoneNumber = "\(phoneNumber)5"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber6() {
        phoneNumber = "\(phoneNumber)6"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber7() {
        phoneNumber = "\(phoneNumber)7"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber8() {
        phoneNumber = "\(phoneNumber)8"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumber9() {
        phoneNumber = "\(phoneNumber)9"
        phoneNumberTextField.text = phoneNumber
    }
    
    @objc func providePhoneNumberDelete(_ sender: UITapGestureRecognizer) {
        phoneNumber.removeLast()
        phoneNumberTextField.text = phoneNumber
    }
 
    // MARK: - COLLECTION VIEW
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let layout = collectionView.collectionViewLayout as? UICollectionViewFlowLayout
        layout?.minimumInteritemSpacing = 0
        layout?.minimumLineSpacing = 0
        
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
    
    @IBAction func goToDashboard(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
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
