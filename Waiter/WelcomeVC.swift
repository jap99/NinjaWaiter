//
//  WelcomeVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/23/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class WelcomeVC: UIViewController {

    @IBOutlet weak var createNewRestaurantLabel: UILabel!
    @IBOutlet weak var createNewRestaurantButton: UIButton!
    @IBOutlet weak var createNewRestButton2: UIButton!
    @IBOutlet weak var loginRestaurantLabel: UILabel!
    @IBOutlet weak var loginRestaurantButton: UIButton!
    @IBOutlet weak var loginRestaurantButton2: UIButton!
    
    var newRestaurantPopup: CreateRestaurantView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupGestureRecognizers()
        self.newRestaurantPopup = CreateRestaurantView.loadViewFromNib(viewController: self)
    }

    @objc func createNewRestaurant() {
        newRestaurantPopup.center = view.center
        self.view.addSubview(newRestaurantPopup)
    }
    
    @objc func loginRestaurant() {
        
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC-ID") as! LoginVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    func setupGestureRecognizers() {
        createNewRestaurantLabel.isUserInteractionEnabled = true
        createNewRestButton2.isUserInteractionEnabled = true
        loginRestaurantLabel.isUserInteractionEnabled = true
        loginRestaurantButton2.isUserInteractionEnabled = true
        loginRestaurantButton.isUserInteractionEnabled = true
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.createNewRestaurant))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.loginRestaurant))
        
        createNewRestaurantLabel.addGestureRecognizer(tapGesture1)
        createNewRestaurantButton.addGestureRecognizer(tapGesture1)
        createNewRestButton2.addGestureRecognizer(tapGesture1)
        
        loginRestaurantLabel.addGestureRecognizer(tapGesture2)
        loginRestaurantButton.addGestureRecognizer(tapGesture2)
        loginRestaurantButton2.addGestureRecognizer(tapGesture2)
    }
    
}
