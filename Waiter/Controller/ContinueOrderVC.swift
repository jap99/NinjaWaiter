//
//  ContinueOrderVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class ContinueOrderVC: UIViewController/*, UICollectionViewDataSource, UICollectionViewDelegate*/ {

    @IBOutlet weak var cv1: UICollectionView!

    
    @IBOutlet weak var placeTakeAwayButton: UIButton!
    @IBOutlet weak var phoneNumberTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
       // cv1.delegate = self; cv1.dataSource = self
    }

 
    // MARK: - COLLECTION VIEW
    
//    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
//
//        return 1
//    }
//
//    func numberOfSections(in collectionView: UICollectionView) -> Int {
//        return 1
//    }
//
//    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
//
//        return UICollectionViewCell()
//    }
    
    // MARK: - IBACTIONS
    
    @IBAction func backButtonPressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderSuccessVC-ID") as! OrderSuccessVC
        self.present(vc, animated: true, completion: {
            
        })
    }
    
    @IBAction func placeTakeAwayButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "OrderSuccessVC-ID") as! OrderSuccessVC
        self.present(vc, animated: true, completion: {
            
        })
    }
    
}
