//
//  LoginVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginModel {
    var username = ""
    var password = ""
}

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    var loginModel = LoginModel() 
   
    @IBAction func backButton_Pressed(_ sender: Any) {
        if let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC-ID") as? WelcomeVC {
            self.present(vc, animated: true, completion: nil)
        }
    }
    
    @IBAction func resetPasswordButton_Pressed(_ sender: Any) {
        if self.emailTextField.text == "" {
            let alertController = UIAlertController(title: "Password Reset Error", message: "Please enter an email address and then try to reset your password again.", preferredStyle: .alert)
            let defaultAction = UIAlertAction(title: "OK", style: .cancel, handler: nil)
            alertController.addAction(defaultAction)
            
            self.present(alertController, animated: true, completion: nil)
        } else {
            Auth.auth().sendPasswordReset(withEmail: self.emailTextField.text!, completion: { (error) in
                
                var title = ""
                var message = ""
                
                if error != nil {
                    title = "Password Reset Error"
                    message = (error?.localizedDescription)!
                } else {
                    title = "Success!"
                    message = "Password reset email sent."
                    self.emailTextField.text = ""
                }
                
                let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
                
                let defaultAction = UIAlertAction(title: "OK", style: .cancel) {
                    UIAlertAction in
                    DispatchQueue.main.async {
                                let vc = self.storyboard?.instantiateViewController(withIdentifier: "WelcomeVC-ID") as! WelcomeVC
                        self.present(vc, animated: true, completion: nil)
                    }
                }
                alertController.addAction(defaultAction)
                self.present(alertController, animated: true, completion: nil)
            })
        }
    }
    
    @IBAction func loginButton_Pressed(_ sender: Any) {
       
        
        if emailTextField.text != nil && emailTextField.text! != "" && passwordTextField.text != nil && passwordTextField.text! != "" {
            
            loginModel.username = emailTextField.text!
            loginModel.password = passwordTextField.text!
           
            AuthServices.instance.restaurantLogin(email:loginModel.username, password:loginModel.password) { (errMessage, user) in
                
                if errMessage != nil {
                    print("Error logging in")
                
                } else if let currentUser = user as? User {
                    
                    _currentUser = AppUser(user:currentUser)
                   
                    DataService.instance.mainRef.child(FIR_ADMINISTRATORS).child(_currentUser.uid).observe(.value, with: { (admin) in
                        
                        if let _ = admin.value as? String {
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
    
    func login() {
        
        // In LoginVC, first take the user's email address & password
        // and send it the Firebase's Auth API
        // and get back a response.
        
        // Take response.user.uid &
        // take it to Firebase database
        // and query it in the main STAFF node
      
        // The key value in the STAFF node is the userUID; value is RESTAURANT_UID
        
        // Log user in with Firebase Auth API
        
        //
        
        
    }
    
    func staffListAPI() {
        StaffMember.getStaffList(adminEmail: loginModel.username, callback: { (staffArray, error) in
            
            if error != nil {
                
            } else {

                let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
                vc.staffArray = staffArray
                self.present(vc, animated: false, completion: {
                    
                })
            }
        })
    }
}
