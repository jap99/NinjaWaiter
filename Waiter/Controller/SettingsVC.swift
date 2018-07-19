//
//  SettingsVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    var staffArray = [StaffMember]()
    
    @IBOutlet weak var tv: UITableView!
    
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var menuManagementButton: UIButton!
    @IBOutlet weak var addStaffButton: UIButton!
    @IBOutlet weak var staffSavedSuccessful_View: UIView!
    
    @IBOutlet weak var restaurantNameLabel: UILabel!
    @IBOutlet weak var userLabel: UILabel!
    @IBOutlet weak var plusSignImage: UIImageView!
    @IBOutlet weak var tvTopView: UIView!
    
    
    @IBOutlet weak var emailTextField: UITextField!
    @IBOutlet weak var passwordTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var createButton: UIButton!
    @IBOutlet weak var addStaffView: UIView!
    @IBOutlet weak var threeOutoTenLabel: UILabel!
    
    // GENERAL
    
    @IBOutlet weak var discountTextField: UITextField!
    @IBOutlet weak var serviceChargeTextField: UITextField!
    @IBOutlet weak var taxName1TextField: UITextField!
    @IBOutlet weak var taxPercentage1TextField: UITextField!
    @IBOutlet weak var taxName2TextField: UITextField!
    @IBOutlet weak var taxPercentage2TextField: UITextField!
    @IBOutlet weak var saveButton: RoundedButton!
    
    var discountText: String?
    var serviceChargeText: String?
    var tax1NameText: String?
    var tax2NameText: String?
    var taxPercentage1NameText: String?
    var taxPercentage2NameText: String?
    
    // TABLE NUMBERS
    
    @IBOutlet weak var startingTextField: UITextField!
    @IBOutlet weak var endingTextField: UITextField!
    @IBOutlet weak var waiterGif: UIImageView!
    
    // PRINTER
    
    @IBOutlet weak var cashierPrinterTextField: UITextField!
    @IBOutlet weak var kitchenPrinterTextField: UITextField!
    @IBOutlet weak var barPrinterTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tv.delegate = self; tv.dataSource = self
        print(UIScreen.main.bounds.width)
       // hideKeyboardWhenTappedAround()
        if UIScreen.main.bounds.width > 900 { // setup constraints for small sized iPad // 1024px is for 9.7 inches
            tvTopView.translatesAutoresizingMaskIntoConstraints = false
            tv.translatesAutoresizingMaskIntoConstraints = false 
        }
        settingsButton.isUserInteractionEnabled = false
        
        setupColors()
        
        self.updateStaffTv() 
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        addStaffView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        setupObjectsWithData()
        staffSavedSuccessful_View.isHidden = true
    }
    

    

    
    
    
    // MARK: - SETUP
    
    func setupColors() {
        waiterGif.loadGif(name: "waiter")
        startingTextField.layer.borderColor = UIColor.lightGray.cgColor
        startingTextField.layer.borderWidth = 1.0
        
        endingTextField.layer.borderColor = UIColor.lightGray.cgColor
        endingTextField.layer.borderWidth = 1.0
        
        cashierPrinterTextField.layer.borderColor = UIColor.lightGray.cgColor
        cashierPrinterTextField.layer.borderWidth = 1.0
        
        kitchenPrinterTextField.layer.borderColor = UIColor.lightGray.cgColor
        kitchenPrinterTextField.layer.borderWidth = 1.0
        
        barPrinterTextField.layer.borderColor = UIColor.lightGray.cgColor
        barPrinterTextField.layer.borderWidth = 1.0
        
        discountTextField.layer.borderColor = UIColor.lightGray.cgColor
        discountTextField.layer.borderWidth = 1.0
        
        serviceChargeTextField.layer.borderColor = UIColor.lightGray.cgColor
        serviceChargeTextField.layer.borderWidth = 1.0
        
        taxName1TextField.layer.borderColor = UIColor.lightGray.cgColor
        taxName1TextField.layer.borderWidth = 1.0
        
        taxName2TextField.layer.borderColor = UIColor.lightGray.cgColor
        taxName2TextField.layer.borderWidth = 1.0
        
        taxPercentage1TextField.layer.borderColor = UIColor.lightGray.cgColor
        taxPercentage1TextField.layer.borderWidth = 1.0
        
        taxPercentage2TextField.layer.borderColor = UIColor.lightGray.cgColor
        taxPercentage2TextField.layer.borderWidth = 1.0
        
        tv.separatorStyle = .none
        
        addStaffView.layer.cornerRadius = 10
        addStaffView.layer.borderWidth = 0.5
        addStaffView.layer.borderColor = UIColor.lightGray.cgColor
    }
    
    
    func setupObjectsWithData() {
        
        DataService.instance.getSettingsData { (dict, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let dict = dict {
                
                if let startingNumberTable = dict["tableStartNumber"],
                    let endingNumberTable = dict["tableEndNumber"] {
                    
                    self.startingTextField.text = "\(startingNumberTable)"
                    self.endingTextField.text = "\(endingNumberTable)"
                }
                
                if let discount = dict["discountText"] {
                    self.discountTextField.text = discount as? String
                }
                
                if let s = dict["serviceChargeText"] {
                    self.serviceChargeTextField.text = s as? String
                }
                
                if let t1 = dict["tax1NameText"] {
                    self.taxName1TextField.text = t1 as? String
                }
                
                if let t1p = dict["taxPercentage1NameText"] {
                    self.taxPercentage1TextField.text = t1p as? String
                }
                
                if let t2 = dict["tax2NameText"] {
                    self.taxName2TextField.text = t2 as? String
                }
                
                if let t2p = dict["taxPercentage2NameText"] {
                    self.taxPercentage2TextField.text = t2p as? String
                }
            }
        }
    }
    
    
    // MARK: - ACTIONS
    
    
    
    func resetStaffNumberCountLabel() {
        threeOutoTenLabel.text = "\(staffArray.count)/10"
    }
    
    
    func updateStaffTv() {
 
        StaffMember.getStaff { (dict, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let dict = dict {
                self.staffArray.removeAll()
                
                let keyList = dict.keys
                var allkeys = [String]()
                var staffDictionaryArray: [[String: Any]] = []
                for key in keyList {
                    if let staffMemberDictionary = dict[key] as? [String: Any] {
                        allkeys.append(key)
                        if let staffType = staffMemberDictionary["staffType"] as? String,
                            let staffEmail = staffMemberDictionary["staffEmail"] as? String {
                            
                            let staff = StaffMember(email: staffEmail, type: staffType, uid: key)
                            self.staffArray.append(staff)
                        }

                        staffDictionaryArray.append(staffMemberDictionary)
                        self.resetStaffNumberCountLabel()
                        self.tv.reloadData()
                    }
                }
 
            }
            self.view.layoutSubviews()
        }
    }
    
    
    
    
    // MARK: - IBACTIONS
    
    
    
    
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
    @IBAction func menuManagementButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "MenuManagementVC-ID") as! MenuManagementVC
        present(vc, animated: true, completion: nil)
    }
    
    
    
    
    
    
    
    @IBAction func addStaffButton_Pressed(_ sender: Any) { // only for showing the popup view; not for saving to firebase
        
        if staffArray.count < 10 {
            
            addStaffView.isHidden = false
            cancelButton.isHidden = false
            self.view.bringSubview(toFront: addStaffView)
            
        } else {
            
            tooManyStaffMembers_Alert()
        } 
    }
    
    
    
    
    
    
    // TAXES
    
    @IBAction func saveButton_Pressed(_ sender: Any) { 
        
        if let discountText = discountTextField.text {
            self.discountText = discountText
        }
        
        if let serviceChargeText = serviceChargeTextField.text {
            self.serviceChargeText = serviceChargeText
        }
        
        if let tax1NameText = taxName1TextField.text {
            self.tax1NameText = tax1NameText
        }
        
        if let tax2NameText = taxName2TextField.text {
            self.tax2NameText = tax2NameText
        }
        
        if let taxPercentage1NameText = taxPercentage1TextField.text {
            self.taxPercentage1NameText = taxPercentage1NameText
        }
        
        if let taxPercentage2NameText = taxPercentage2TextField.text {
            self.taxPercentage2NameText = taxPercentage2NameText
        }
        
        let settings: [String: AnyObject] = [
            "discountText": self.discountText as AnyObject,
            "serviceChargeText": self.serviceChargeText as AnyObject,
            "tax1NameText": self.tax1NameText as AnyObject,
            "tax2NameText": self.tax2NameText as AnyObject,
            "taxPercentage1NameText": self.taxPercentage1NameText as AnyObject,
            "taxPercentage2NameText": self.taxPercentage2NameText as AnyObject
        ]
        
        DataService.instance.saveTaxesAndDiscounts(settings: settings)
    }
    
    
    
    
    // TABLES
    
    @IBAction func saveButtonTableNumbers_Pressed(_ sender: Any) {
        
        if let startingNumber = startingTextField.text, let endingNumber = endingTextField.text {
            
            DataService.instance.saveNumberOfTables(tableStartNumber: startingNumber, tableEndNumber: endingNumber)
        }
    }
    
    
    
    
    
    // CREATE STAFF - POPUP
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
        addStaffView.isHidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
    } 
    
    
    
    
    // SAVE STAFF
    
    @IBAction func createButton_Pressed(_ sender: Any) {
        
        if staffArray.count < 10 {
            if emailTextField.text != nil && emailTextField.text! != "" && passwordTextField.text != nil && passwordTextField.text! != "" {
                
                if (emailTextField.text?.count)! >= 8 {
                    
                    AuthServices.instance.createStaffMember(staffEmail: emailTextField.text!, password: passwordTextField.text!) { (error, user) in
                        
                        if let error = error {
                            
                            print("ERROR SAVING STAFF\(error.debugDescription)")
                            
                        } else { // success
                            
                            self.staffSavedSuccessful_View.isHidden = false
                            
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                self.staffSavedSuccessful_View.isHidden = true
                            })
                            
                            self.updateStaffTv()
                            self.successfullyAddedStaff_Alert(user: self.emailTextField.text!)
                        }
                    }
                    
                } else {
                    passwordNotLongEnough_Alert()
                }

            } else {
                
                enterEmailAndPassword_Alert()
            }
        } else {
            tooManyStaffMembers_Alert()
        }

    }
    
    
    @IBAction func btnDeteleAccountTap(sender: UIButton) {
        
    }
    
    
    // MARK: - TABLE VIEW (STAFF)
    
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        if let waiterCell = tableView.dequeueReusableCell(withIdentifier: WAITER_CELL, for: indexPath) as? WaiterCell {
            
            waiterCell.deleteAccountButton.tag = indexPath.row
            waiterCell.setData(staffList: staffArray, indexPath: indexPath)
            waiterCell.delegate = self
            return waiterCell
        }
        return UITableViewCell()
        
    }
    
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        return staffArray.count
    }
    
    
    
    
    
    
    
    
    // MARK: - ALERTS
    
    func errorResettingPassword_Alert(error: Error) {
        let ac = UIAlertController(title: "Error", message: error.localizedDescription, preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func successPasswordReset_Alert(staff: StaffMember) {
        let ac = UIAlertController(title: "Successful", message: "Password reset email has been sent to \(staff.email!)", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func successfullyDeletedStaff_Alert() {
        
        let ac = UIAlertController(title: "Success", message: "You have successfully deleted a staff member from the database.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        
        present(ac, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func errorDeletingStaff_Alert() {
        
        let ac = UIAlertController(title: "Error", message: "There was an error deleting the staff member from the database. Please try again.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true) {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        }
    }
    
    func enterEmailAndPassword_Alert() {
        let ac = UIAlertController(title: "Data Error", message: "Please make sure you enter both an email address and password for the user you are creating.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        
        present(ac, animated: true, completion: { //[weak self] in
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func successfullyAddedStaff_Alert(user: String) {
        
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.addStaffView.isHidden = true
        
        let ac = UIAlertController(title: "Success", message: "Staff member, \(user), was successfully added to your database.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        
        present(ac, animated: true, completion: {// [weak self] in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func passwordNotLongEnough_Alert() {
        let ac = UIAlertController(title: "Password Error", message: "Please make sure your password is at least 8 characters long.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        
        present(ac, animated: true, completion: {// [weak self] in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func tooManyStaffMembers_Alert() {
        addStaffView.isHidden = true
        let ac = UIAlertController(title: "Sorry", message: "Too many staff members added. Please delete one to add another.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)

        present(ac, animated: true, completion: {// [weak self] in

            DispatchQueue.main.asyncAfter(deadline: .now() + 4, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        })
    }
  
}

// MARK: - WAITER CELL PROTOCOL

extension SettingsVC :  WaiterCellProtocol {
    func resetButtonClicked(_ sender: UIButton) {
        if staffArray.count > sender.tag {
            let staff = staffArray[sender.tag]
            Auth.auth().sendPasswordReset(withEmail: "\(staff.email.trimmingCharacters(in: .whitespacesAndNewlines))") { error in
                if error != nil {
                    self.errorResettingPassword_Alert(error: error!)
                } else {
                    self.successPasswordReset_Alert(staff: staff)
                }
            }
        }
    }
    
   
    
    func deleteButtonClicked(_ sender: UIButton) {
        print("Delete account tap\(sender.tag)")
        DataService.instance.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_STAFF_MEMBERS).child(staffArray[sender.tag].uid).removeValue { (error, obj) in
            
            if error == nil {
                
                if self.staffArray[sender.tag].uid != "" {
                    
                    let senderIndex = sender.tag
                    self.staffArray.remove(at: senderIndex)
                    self.updateStaffTv()
                    self.tv.reloadData()
                    
                    DispatchQueue.main.async {
                        self.successfullyDeletedStaff_Alert()
                    }
                }
                
            } else if let error = error {
                self.errorDeletingStaff_Alert()
                print(error.localizedDescription)
            }
        }
    }
}


