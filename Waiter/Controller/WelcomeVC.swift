//
//  WelcomeVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/23/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import FirebaseAuth

// ENUM

enum UserType:String {
    case adamin = "adamin"
    case staff = "staff"
}

// CLASS

class AppUser {
    var email = ""
    var name = ""
    var type = UserType.staff
    var uid = ""
    
    init() { }
    
    init(user:User) {
        if let email = user.email {
            self.email = email
        }
        
        if let name = user.displayName {
            self.name = name
        }
        
        self.uid = user.uid
        
    }
}

var _currentUser = AppUser()

// CLASS

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
        setupGestureRecognizers()
        self.newRestaurantPopup = CreateRestaurantView.loadViewFromNib(viewController: self)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        self.initModel()
        self.loginAPI()
    }
    
    // MARK: - SETUP
    
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
    
    func initModel() {
        if let username = _userDefault.value(forKey: kUsername) as? String {
            loginModel.username = username
        } else {
            loginModel.username = ""
        }
        if let password = _userDefault.value(forKey: kPassword) as? String {
            loginModel.password = password
        } else {
            loginModel.password = ""
        }
    }

    // MARK: - ACTIONS
    
    @objc func createNewRestaurant() {
        newRestaurantPopup.center = view.center
        self.view.addSubview(newRestaurantPopup)
    }
    
    @objc func loginRestaurant() {
        let viewController = self.storyboard?.instantiateViewController(withIdentifier: "LoginVC-ID") as! LoginVC
        self.present(viewController, animated: true, completion: nil)
    }
    
    // MARK: - LOGIN
    
    func loginAPI() {
      
        if loginModel.username.isEmpty == false && loginModel.password.isEmpty == false {
            
            AuthServices.instance.restaurantLogin(email:loginModel.username, password:loginModel.password) { (errMessage, user) in
                
                if errMessage != nil {
                    
                } else if let currentUser = user as? User {
                   
                    _currentUser = AppUser(user:currentUser)
                    
                    DataService.instance.mainRef.child(FIR_ADMINISTRATORS).child(_currentUser.uid).observe(.value, with: { (obj) in
                        
                        if let _ = obj.value as? String {
                            _currentUser.type = .adamin
                        } else {
                            _currentUser.type = .staff
                        }
                    })
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
                
            } else { // no error
                
                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
                vc.staffArray = staffArray
                
                self.present(vc, animated: true, completion: {
                    
                })
            }
        })
    }
}

