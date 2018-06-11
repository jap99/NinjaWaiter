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
    var loginModel = LoginModel()
    override func viewDidLoad() {
        super.viewDidLoad()
        self.initModel()
        setupGestureRecognizers()
        self.newRestaurantPopup = CreateRestaurantView.loadViewFromNib(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.loginAPI()
    }
    
    func initModel() {
        if let username = _userDefault.value(forKey: kUsername) as? String {
            loginModel.username = username
        }
        if let password = _userDefault.value(forKey: kPassword) as? String {
            loginModel.password = password
        }
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

//MARK: api calling
extension WelcomeVC {
    
    func loginAPI() {
        if loginModel.username.isEmpty == false && loginModel.password.isEmpty == false {
            
            AuthServices.instance.restaurantLogin(email:loginModel.username, password:loginModel.password) { (errMessage, success) in
                
                if errMessage != nil {
                    
                } else if success != nil {
                    _userDefault.set(self.loginModel.username, forKey:kUsername)
                    _userDefault.set(self.loginModel.password, forKey:kPassword)
                    _userDefault.synchronize()
                    self.staffListAPI()
                }
            }
        }
    }
    
    func staffListAPI() {
        StaffMember.getStaffList(adminEmail: loginModel.username, callback: { (staffArray, error) in
            
            if error != nil {
                
            } else {
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
                vc.staffArray = staffArray
                self.present(vc, animated: true, completion: {
                    
                })
            }
        })
    }
}

