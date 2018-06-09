//
//  LoginVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import FirebaseAuth

class LoginVC: UIViewController {

    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

  
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
