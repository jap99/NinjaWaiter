//
//  CreateItem.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/12/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit

class CreateItem: UIView {
    
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var itemName: UITextField!
    @IBOutlet weak var itemPrice: UITextField!
    @IBOutlet weak var option1: UIButton!
    @IBOutlet weak var option2: UIButton!
    @IBOutlet weak var option3: UIButton!
    @IBOutlet weak var option4: UIButton!
    @IBOutlet weak var option5: UIButton!
    @IBOutlet weak var option6: UIButton!
    @IBOutlet weak var tv: UITableView!
    @IBOutlet weak var saveButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    var viewController: UIViewController!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    static func loadViewFromNib(viewController: UIViewController) -> CreateItem {
        let view = Bundle.main.loadNibNamed("CreateItem", owner: self, options: nil)?.first as! CreateItem
        view.viewController = viewController
        return view
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func addItemButton_Pressed(_ sender: Any) {
        
    }
    
    @IBAction func option1_Pressed(_ sender: Any) {
        
    }
    
    @IBAction func option2_Pressed(_ sender: Any) {
        
    }
    
    @IBAction func option3_Pressed(_ sender: Any) {
        
    }
    
    @IBAction func option4_Pressed(_ sender: Any) {
   
    }
    
    @IBAction func option5_Pressed(_ sender: Any) {
        
    }
    
    @IBAction func option6_Pressed(_ sender: Any) {
    
    }
    
    @IBAction func cancel_Pressed(_ sender: Any) {
        self.removeFromSuperview()
    }
    
    @IBAction func save_Pressed(_ sender: Any) {
        
        // THIS CODE WAS TAKEN FROM CREATERESTAURANTVIEW.SWIFT - WE JUST NEED TO EDIT IT SO IT DOES THE SAME TYPE OF THING EXCEPT FOR THIS VIEW INSTEAD
        
//        if restaurantNameTextField.text != nil && restaurantNameTextField.text != "" && emailTextField.text != nil && emailTextField.text != "" && passwordTextField.text != nil && passwordTextField.text != "" {
//
//            AuthServices.instance.createRestaurant(adminEmail: emailTextField.text!, restaurantName: restaurantNameTextField.text!, password: passwordTextField.text!) { (errorMessage, user) in
//
//                if let currentUser = user {
//
//                    _currentUser = AppUser(user:currentUser)
//                    DataService.instance.mainRef.child(FIR_ADMINISTRATORS).child(_currentUser.uid).observe(.value, with: { (obj) in
//                        if let _ = obj.value as? String {
//                            _currentUser.type = .adamin
//                        } else {
//                            _currentUser.type = .staff
//                        }
//                    })
//                    _userDefault.set(self.emailTextField.text!, forKey:kUsername)
//                    _userDefault.set(self.passwordTextField.text!, forKey:kPassword)
//                    _userDefault.synchronize()
//
//                    let alertController = UIAlertController(title: APP_NAME, message: CREATE_ACCOUNT_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
//
//                    self.viewController.present(alertController, animated: true, completion: { [weak self] in
//                        DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
//                            alertController.dismiss(animated: true, completion: {
//                                self?.removeFromSuperview()
//                                // Send user to SettingsVC
//                                let viewController = self?.viewController.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
//                                self?.viewController.present(viewController, animated: true, completion: nil)
//                            })
//                        })
//                    })
//                    self.removeFromSuperview()
//                } else {
//                    // Handle Error Case
//                    let alertController = UIAlertController(title: APP_NAME, message: errorMessage ?? DEFAULT_ERROR_MESSAGE, preferredStyle: UIAlertControllerStyle.alert)
//                    let okAction = UIAlertAction(title: "Ok", style: UIAlertActionStyle.default, handler: { (action: UIAlertAction) in
//                        self.removeFromSuperview()
//                    })
//                    let retryAction = UIAlertAction(title: "Retry", style: UIAlertActionStyle.cancel, handler: { (action: UIAlertAction) in
//                    })
//                    alertController.addAction(okAction)
//                    alertController.addAction(retryAction)
//                    self.viewController.present(alertController, animated: true, completion: nil)
//                }
//            }
//
//        }
    }
    
    
    
    
    
}
