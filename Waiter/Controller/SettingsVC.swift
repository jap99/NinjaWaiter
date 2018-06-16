//
//  SettingsVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    var staffArray = [StaffMember]()
    
    @IBOutlet weak var tv: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var menuManagementButton: UIButton!
    @IBOutlet weak var addStaffButton: UIButton!
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var addStaffView: UIView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tv.delegate = self
        tv.dataSource = self
        hideKeyboardWhenTappedAround()
        settingsButton.isUserInteractionEnabled = false  
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        addStaffView.isHidden = true
    }

    // MARK: - IBACTIONS
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelAddNewStaff(_ sender: Any) {
        addStaffView.isHidden = true
    }
    
    @IBAction func menuManagementButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuManagementVC-ID") as! MenuManagementVC
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func addStaffButton_Pressed(_ sender: Any) {
        addStaffView.isHidden = false
        cancelButton.isHidden = false 
        self.view.bringSubview(toFront: addStaffView)
    }
    
    // FOR THE 'CREATE STAFF' POPUP VIEW
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
        cancelButton.isHidden = true
    } 
    
    @IBAction func createButton_Pressed(_ sender: Any) {
        
        if emailTextField.text != nil && emailTextField.text! != "" && passwordTextField.text != nil && passwordTextField.text! != "" {
            
            AuthServices.instance.createStaffMember(staffEmail: emailTextField.text!, password: passwordTextField.text!) { (error, user) in
                
                if let error = error {
                  
                    print(error.debugDescription)
                
                } else {
                   
                    print(user!)
                    self.addStaffView.isHidden = true
                }
            }
        }
    }
    
    
    // MARK: - TABLE VIEW
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: WAITER_CELL, for: indexPath)
        return cell 
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        if let waiterCell =  cell as? WaiterCell {
            waiterCell.deleteAccountButton.tag = indexPath.row
            waiterCell.setData(staff: staffArray[indexPath.row], indexPath: indexPath)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return staffArray.count
    }
    
    @IBAction func btnDeteleAccountTap(sender:UIButton) {
        print("Delete account tap\(sender.tag)")
        let restNode = DataService.instance.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_STAFF_MEMBERS)
        restNode.child(staffArray[sender.tag].uid).removeValue { (error, obj) in
            if error == nil {
                DispatchQueue.main.async {
                    self.staffArray.remove(at: sender.tag)
                    self.tv.reloadData()
                }
            }
        }
    }
    
}
