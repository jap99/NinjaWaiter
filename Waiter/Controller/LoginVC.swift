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
                
                if errMessage != nil {
                    
                } else if success != nil {
                    
                    StaffMember.getStaffList(adminEmail: self.emailTextField.text!, callback: { (staffArray, error) in
                        
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
        }
    }
    
}
