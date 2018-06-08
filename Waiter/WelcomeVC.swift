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
        loginRestaurantLabel.isUserInteractionEnabled = true
        createNewRestButton2.isUserInteractionEnabled = true
        
        let tapGesture1 = UITapGestureRecognizer(target: self, action: #selector(self.createNewRestaurant))
        let tapGesture2 = UITapGestureRecognizer(target: self, action: #selector(self.loginRestaurant))
        let tapGesture3 = UITapGestureRecognizer(target: self, action: #selector(self.createNewRestaurant))
        
        createNewRestaurantLabel.addGestureRecognizer(tapGesture1)
        createNewRestaurantButton.addGestureRecognizer(tapGesture1)
        createNewRestButton2.addGestureRecognizer(tapGesture3)
        
        loginRestaurantLabel.addGestureRecognizer(tapGesture2)
        loginRestaurantButton.addGestureRecognizer(tapGesture2)
    }
    
}
