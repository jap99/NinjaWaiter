//
//  LoginVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

  
    @IBAction func resetPasswordButton_Pressed(_ sender: Any) {
        
    }
    
    @IBAction func loginButton_Pressed(_ sender: Any) {
       
        if emailTextField.text != nil && emailTextField.text! != "" && passwordTextField.text != nil && passwordTextField.text! != "" {
            
            AuthServices.instance.restaurantLogin(email: emailTextField.text!, password: passwordTextField.text!) { (errMessage, success) in
                
                if let error = errMessage {
                    print(error)
                    
                } else if let success = success {
                    print(success)
                    
                    StaffMember.getStaffList(adminEmail: self.emailTextField.text!, callback: { (staffArray, error) in
                        if let error = error {
                            print(error)
                        } else {
                            print(staffArray)
                        }
                    })
                }
            }
        }
    }
    
}
