//
//  CreateRestaurantView.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/23/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class CreateRestaurantView: UIView {

    @IBOutlet weak var restaurantNameTextField: UITextField!
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var viewController: UIViewController!
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func loadViewFromNib(viewController: UIViewController) -> CreateRestaurantView {
        let view = Bundle.main.loadNibNamed("CreateRestaurantView", owner: self, options: nil)?.first as! CreateRestaurantView
        view.viewController = viewController
        return view
    }
     
    
    // MARK: - IBACTIONS
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
        self.removeFromSuperview()
    }

    @IBAction func createButton_Pressed(_ sender: Any) {
        
        if restaurantNameTextField.text != nil && restaurantNameTextField.text != "" && emailTextField.text != nil && emailTextField.text != "" && passwordTextField.text != nil && passwordTextField.text != "" {
            
            AuthServices.instance.createRestaurant(adminEmail: emailTextField.text!, restaurantName: restaurantNameTextField.text!, password: passwordTextField.text!) { (errorMessage, user) in
                
                if let currentUser = user {
                    
                    _currentUser = AppUser(user:currentUser)
                    DataService.instance.mainRef.child(FIR_ADMINISTRATORS).child(_currentUser.uid).observe(.value, with: { (obj) in
                        if let _ = obj.value as? String {
                            _currentUser.type = .adamin
                        } else {
                            _currentUser.type = .staff
                        }
                    })
                    _userDefault.set(self.emailTextField.text!, forKey:kUsername)
                    _userDefault.set(self.passwordTextField.text!, forKey:kPassword)
                    _userDefault.synchronize()
                    
                    let ac = UIAlertController(title: APP_NAME, message: CREATE_ACCOUNT_MESSAGE, preferredStyle: .alert)
                    
                    self.viewController.present(ac, animated: true, completion: { [weak self] in
                        
                        DispatchQueue.main.asyncAfter(deadline: .now() + 1, execute: {
                           
                            ac.dismiss(animated: true, completion: {
                                self?.removeFromSuperview()
                                
                                // Send user to SettingsVC
                                let viewController = self?.viewController.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
                                self?.viewController.present(viewController, animated: true, completion: nil)
                            })
                        })
                    })
                     self.removeFromSuperview()
                } else {
                    // Handle Error Case
                    let alertController = UIAlertController(title: APP_NAME, message: errorMessage ?? DEFAULT_ERROR_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
                        self.removeFromSuperview()
                    })
                    let retryAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
                    })
                    alertController.addAction(okAction)
                    alertController.addAction(retryAction)
                    self.viewController.present(alertController, animated: true, completion: nil)
                }
            }
           
        }
        
    }
    
    
}
