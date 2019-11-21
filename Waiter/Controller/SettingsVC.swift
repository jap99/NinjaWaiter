//
//  SettingsVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import FirebaseAuth

class SettingsVC: BaseViewController, UITableViewDelegate, UITableViewDataSource {
    
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
    @IBOutlet weak var navBarView: UIView!
    @IBOutlet weak var lineView1: UIView!
    @IBOutlet weak var generalLabel: UILabel!
    @IBOutlet weak var discountLabel: UILabel!
    @IBOutlet weak var serviceChargeLabel: UILabel!
    @IBOutlet weak var taxLabel: UILabel!
    @IBOutlet weak var tax2Label: UILabel!
    @IBOutlet weak var leaveEmptyLabel: UILabel!
    @IBOutlet weak var tableNumbersView: UIView!
    @IBOutlet weak var printerLabel: UILabel!
    @IBOutlet weak var printerDescLabel: UILabel!
    @IBOutlet weak var cashierLabel: UILabel!
    @IBOutlet weak var kitchenLabel: UILabel!
    @IBOutlet weak var barLabel: UILabel!
    @IBOutlet weak var printersStackView: UIStackView!
    @IBOutlet weak var printerSaveButton: RoundedButton!
    @IBOutlet weak var scrollView: UIScrollView!
    @IBOutlet weak var scrollSubview: UIView!
    @IBOutlet weak var addStaffLabel: UILabel!
    
    
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
        
        setupInterfaceIfSmallDevice()
        setupColors()
        updateStaffTV()
    }
    
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        settingsButton.addCornerRadiusToNavBarButton()
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
    
    func translateMasksToFalse() {
        navBarView.translatesAutoresizingMaskIntoConstraints = false
        tvTopView.translatesAutoresizingMaskIntoConstraints = false
        tv.translatesAutoresizingMaskIntoConstraints = false
        restaurantNameLabel.translatesAutoresizingMaskIntoConstraints = false
        userLabel.translatesAutoresizingMaskIntoConstraints = false
        addStaffButton.translatesAutoresizingMaskIntoConstraints = false
        plusSignImage.translatesAutoresizingMaskIntoConstraints = false
        addStaffLabel.translatesAutoresizingMaskIntoConstraints = false
        scrollSubview.translatesAutoresizingMaskIntoConstraints = false
        scrollView.translatesAutoresizingMaskIntoConstraints = false
        tableNumbersView.translatesAutoresizingMaskIntoConstraints = false
        lineView1.translatesAutoresizingMaskIntoConstraints = false
        settingsButton.isUserInteractionEnabled = false
    
    }
    
    func setupInterfaceIfSmallDevice() {
        if UIScreen.main.bounds.width < 1030 {
            
            translateMasksToFalse()
            
            //            let horizontal_generalLabels: [String: UIView] = ["discountL": discountLabel, "serviceChargeL": serviceChargeLabel, "tax1L": taxLabel, "tax2L": tax2Label]
            //           let horizontal_generalTextFields: [String: UIView] = ["discountT": discountTextField, "serviceT": serviceChargeTextField, "taxName1": taxName1TextField, "taxPer1": //taxPercentage1TextField, "taxName2": taxName2TextField, "taxPer2": taxPercentage2TextField]
            
            let vertical_views_setOne: [String: UIView] = ["navBar": navBarView, "scrollSubview": scrollSubview, "resName": restaurantNameLabel, "userLabel": userLabel, "addStaffButton": addStaffButton, "tv": tv, "lineView": lineView1, "generalL": generalLabel, "discountL": discountLabel, "discountT": discountTextField, "generalSaveB": saveButton, "tableNumView": tableNumbersView, "printerL": printerLabel, "printerStackView": printersStackView, "printerSaveB": printerSaveButton]
            let vertical_views_setTwo: [String: UIView] = ["resName": restaurantNameLabel, "userLabel": userLabel, "tvTopView": tvTopView, "tv": tv, "printerDescrL": printerDescLabel, "lineView": lineView1]
            let navBarViews: [String: UIView] = ["backB": backButton, "settingsB": settingsButton, "menuManagementB": menuManagementButton]
            
            NSLayoutConstraint.activate([
                
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[resName]-30-[userLabel]-30-[addStaffButton]-82-[lineView]-91-[generalL]-50-[discountL]-30-[discountT]-50-[generalSaveB]-60-[tableNumView]-60-[printerL]-40-[printerStackView]-30-[printerSaveB]-50-|", options: [], metrics: nil, views: vertical_views_setOne),
                
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-30-[resName]-30-[userLabel]-30-[tvTopView(50)][tv(>=50@999,<=120@1000)]-40-[lineView]", options: [], metrics: nil, views: vertical_views_setTwo),
                
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-40-[backB]-100-[settingsB]-100-[menuManagementB]-40-|", options: [], metrics: nil, views: navBarViews), 
                NSLayoutConstraint.constraints(withVisualFormat: "H:|-20-[rest]", options: [], metrics: nil, views: ["rest": restaurantNameLabel]),
                NSLayoutConstraint.constraints(withVisualFormat: "H:[addStaffButton]-40-[tv]-40-|", options: [], metrics: nil, views: ["tv": tv, "addStaffButton": addStaffButton])
                
                
                ].flatMap{$0})
        }
        
        scrollView.leftAnchor.constraint(equalTo: self.view.leftAnchor).isActive = true
        scrollView.rightAnchor.constraint(equalTo: self.view.rightAnchor).isActive = true
        scrollView.topAnchor.constraint(equalTo: navBarView.bottomAnchor).isActive = true
        scrollView.bottomAnchor.constraint(equalTo: self.view.bottomAnchor).isActive = true
        
        scrollSubview.leadingAnchor.constraint(equalTo: scrollView.leadingAnchor).isActive = true
        scrollSubview.trailingAnchor.constraint(equalTo: scrollView.trailingAnchor).isActive = true
        scrollSubview.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor).isActive = true
        scrollSubview.topAnchor.constraint(equalTo: scrollView.topAnchor).isActive = true
        scrollSubview.widthAnchor.constraint(equalTo: scrollView.widthAnchor).isActive = true
        scrollSubview.heightAnchor.constraint(equalToConstant: 1800).isActive = true
    }
    
    func setupObjectsWithData() {
        self.startIndicator()
        DataService.instance.getSettingsData { (dict, error) in
            self.stopIndicator()
            if let error = error {
                print(error.localizedDescription)
            } else if let dict = dict {
                print(dict)
                
                if let restaurantName = dict["restaurantName"] as? String {
                    self.restaurantNameLabel.text = restaurantName.capitalized
                }
                
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
    
    func updateStaffTV() {
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
    
    @IBAction func selectPrinterButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DiscoveryViewController-ID") as! DiscoveryViewController
        vc.delegate = self
        present(vc, animated: true, completion: nil)
    }
    
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
            self.view.bringSubviewToFront(addStaffView)
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
                    self.startIndicator()
                    AuthServices.instance.createStaffMember(staffEmail: emailTextField.text!, password: passwordTextField.text!) { (error, user) in
                        if let error = error {
                            self.stopIndicator()
                            print("ERROR SAVING STAFF\(error.debugDescription)")
                        } else { // success
                            self.staffSavedSuccessful_View.isHidden = false
                            DispatchQueue.main.asyncAfter(deadline: .now() + 1.5, execute: {
                                self.stopIndicator()
                                self.staffSavedSuccessful_View.isHidden = true
                            })
                            self.updateStaffTV()
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
        if let waiterCell = tableView.dequeueReusableCell(withIdentifier: Constants.WAITER_CELL, for: indexPath) as? WaiterCell {
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
        present(ac, animated: true, completion: {
            DispatchQueue.main.asyncAfter(deadline: .now() + 3, execute: {
                ac.dismiss(animated: true, completion: nil)
            })
        })
    }
    
    func passwordNotLongEnough_Alert() {
        let ac = UIAlertController(title: "Password Error", message: "Please make sure your password is at least 8 characters long.", preferredStyle: .alert)
        let ok = UIAlertAction(title: "Okay", style: .default, handler: nil)
        ac.addAction(ok)
        present(ac, animated: true, completion: {
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
        present(ac, animated: true, completion: {
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
       self.startIndicator()
        DataService.instance.mainRef.child(Constants.FIR_RESTAURANTS).child(Constants.RESTAURANT_UID).child(Constants.FIR_STAFF_MEMBERS).child(staffArray[sender.tag].uid).removeValue { (error, obj) in
        self.stopIndicator()
            if error == nil {
                if self.staffArray[sender.tag].uid != "" {
                    let senderIndex = sender.tag
                    self.staffArray.remove(at: senderIndex)
                    self.updateStaffTV()
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


extension SettingsVC: DiscoveryViewDelegate {
    func discoveryView(_ sendor:DiscoveryViewController, onSelectPrinterTarget target:String) {
    
    }
}

