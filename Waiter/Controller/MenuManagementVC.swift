//
//  MenuManagementVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/9/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class MenuManagementVC: UIViewController {

    @IBOutlet weak var menuManagementButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    @IBOutlet weak var backButton: UIButton!
    @IBOutlet weak var addCategoryButton: UIButton!
    @IBOutlet weak var tv: UITableView!
    
    @IBOutlet weak var addCategoryView: UIView!
    @IBOutlet weak var foodTextField: UITextField!
    @IBOutlet weak var cancelButton: UIButton!
    @IBOutlet weak var addButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
 
    }

    // MARK: - IBACTIONS
    
    @IBAction func backButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "DashboardVC-ID") as! DashboardVC
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func settingsButton_Pressed(_ sender: Any) {
        let vc = self.storyboard?.instantiateViewController(withIdentifier: "SettingsVC-ID") as! SettingsVC
        present(vc, animated: true, completion: nil)
    }
    
    @IBAction func menuManagementButton_Pressed(_ sender: Any) {
    }
    
    @IBAction func addCategoryButton_Pressed(_ sender: Any) {
          addCategoryView.isHidden = false
    }
    
    @IBAction func cancelButton_Pressed(_ sender: Any) {
        foodTextField.text = ""
        addCategoryView.isHidden = true
    }

    @IBAction func addButton_Pressed(_ sender: Any) {
    }
    
 
}
