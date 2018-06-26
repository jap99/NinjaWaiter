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
        
        hideKeyboardWhenTappedAround()
        
        settingsButton.isUserInteractionEnabled = false
 
        
        
        setup()
        
        StaffMember.getStaffList(adminEmail: LoginModel.instance.username) { (staffMemberArray, error) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                if staffMemberArray != nil {
                    self.staffArray = staffMemberArray!
                    print(staffMemberArray!)
                }
                
            }
        }
        
        tv.beginUpdates()
        tv.reloadData()
        tv.endUpdates()
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        addStaffView.isHidden = true
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
        setupObjectsWithData()
        tv.reloadData() 
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        print("VIEW DID APPEAR")
    }
    
    // MARK: - SETUP
    
    func setup() {
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
    }
    
    func setupObjectsWithData() {
        
        DataService.instance.getSettingsData { (dict, error) in
            if let error = error {
                print(error.localizedDescription)
            } else if let dict = dict {
                print(dict)
                
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
        
        addStaffView.isHidden = false
        cancelButton.isHidden = false 
        self.view.bringSubview(toFront: addStaffView)
    }
    
    // SAVE TAXES & DISCOUNTS
    
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
    
    // SAVE TABLE NUMBERS
    
    @IBAction func saveButtonTableNumbers_Pressed(_ sender: Any) {
        
        if let startingNumber = startingTextField.text, let endingNumber = endingTextField.text {
            
            DataService.instance.saveNumberOfTables(tableStartNumber: startingNumber, tableEndNumber: endingNumber)
        }
    }
    
    // FOR THE 'CREATE STAFF' POPUP VIEW
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
        addStaffView.isHidden = true
        emailTextField.text = ""
        passwordTextField.text = ""
    } 
    
    // CREATE STAFF MEMBER
    
    @IBAction func createButton_Pressed(_ sender: Any) {
        
        if emailTextField.text != nil && emailTextField.text! != "" && passwordTextField.text != nil && passwordTextField.text! != "" {
            
            AuthServices.instance.createStaffMember(staffEmail: emailTextField.text!, password: passwordTextField.text!) { (error, user) in
                
                if let error = error {
                    
                    print("ERROR SAVING STAFF\(error.debugDescription)")
                    
                } else { // success
                    
                    StaffMember.getStaffList(adminEmail: self.emailTextField.text!, callback: { (staffArray, error) in
                        
                        if let error = error {
                            print(error.localizedDescription)
                            
                        } else {
                            //self.staffArray = []
                            // self.staffArray = staffArray!
                            
                            DispatchQueue.main.async {
                                //self.staffArray.append()
                                self.tv.reloadData()
                            }
                            self.successfullyAddedStaff_Alert(user: self.emailTextField.text!)
                        }
                    })
                    
                }
            }
        } else {
            
            enterEmailAndPassword_Alert()
        }
        
    }
    
    // MARK: - ALERTS
    
    func enterEmailAndPassword_Alert() {
        let ac = UIAlertController(title: "Data Error", message: "Please make sure you enter both an email address and password for the user you are creating.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        
        present(ac, animated: true, completion: { //[weak self] in
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                
                ac.dismiss(animated: true, completion: {
                    //self?.removeFromSuperview()
                })
            })
        })
    }
    
    func successfullyAddedStaff_Alert(user: String) {
        
        self.emailTextField.text = ""
        self.passwordTextField.text = ""
        self.addStaffView.isHidden = true
        
        let ac = UIAlertController(title: "Success", message: "Staff member, \(user), added successfully.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        
        present(ac, animated: true, completion: {// [weak self] in
            
            DispatchQueue.main.asyncAfter(deadline: .now(), execute: {
                self.tv.reloadData()
                self.loadViewIfNeeded()
                ac.dismiss(animated: true, completion: {
                    //self?.removeFromSuperview()
                })
            })
        })
    }
    
    // MARK: - TABLE VIEW (STAFF)
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        if let waiterCell = tableView.dequeueReusableCell(withIdentifier: WAITER_CELL, for: indexPath) as? WaiterCell {
            
            waiterCell.deleteAccountButton.tag = indexPath.row
            waiterCell.setData(staff: staffArray[indexPath.row], indexPath: indexPath)
            
            //            for x in 0..<staffArray.count {
            //
            //                print(staffArray.count)
            //
            //                if x < 8 {
            //
            //                    if staffArray.count <= x {
            //                        waiterCell.deleteAccountButton.tag = indexPath.row
            //                        waiterCell.setData(staff: staffArray[x], indexPath: indexPath)
            //
            //                    }
            //                }
            //            }
            
            if indexPath.row % 2 == 0 {
                waiterCell.backgroundColor = .white
                
            } else {
                waiterCell.backgroundColor = customLightGray
            }
            
            return waiterCell
        } else {
            
            let cell = UITableViewCell()
            
            if indexPath.row % 2 == 0 {
                cell.backgroundColor = .white
                
            } else {
                cell.backgroundColor = customLightGray
            }
            
            return cell
        }
        
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        //        var count = 0
        //
        //        if staffArray.count <= 8 {
        //            count = 8
        //        } else {
        //            count = staffArray.count
        //        }
        return staffArray.count //count
    }
    
    @IBAction func btnDeteleAccountTap(sender: UIButton) {
        print("Delete account tap\(sender.tag)")
        
        let _ = DataService.instance.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_STAFF_MEMBERS).child(staffArray[sender.tag].uid).removeValue { (error, obj) in
            
            if error == nil {
                DispatchQueue.main.async {
                    self.staffArray.remove(at: sender.tag)
                    self.successfullyDeletedStaff_Alert()
                    self.tv.reloadData()
                }
            } else if let error = error {
                self.errorDeletingStaff_Alert()
                print(error.localizedDescription)
            }
        }
    }
    
    // MARK: - ALERTS
    
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
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 2, execute: {
                
                ac.dismiss(animated: true, completion: nil)
            })
        }
    }
}


