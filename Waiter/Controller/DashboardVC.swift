//
//  DashboardVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class DashboardVC: UIViewController {

    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    var staffArray: [StaffMember]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        settingsButton.isEnabled = _currentUser.type == .adamin
        hideKeyboardWhenTappedAround()
        fetchCategoryFromServer()
        DataService.instance.getSettingsData { (_, _) in
        }
        DataService.instance.getAvabilityFromServer()
        
    }
    
    func  fetchCategoryFromServer(){
        DispatchQueue.global(qos: .background).async {
            
            DataService.instance.getCategoriesFromServer { (categories: [Category]?, error) in
                guard let _ = error else {
                    return
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(staffArray as Any)
    }

    // MARK: - ACTIONS
    
    func goToViewController(_ categoryData: [CategoryData]) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerVC-ID") as! ViewController
        vc.categoryData = categoryData
        self.present(vc, animated: true) { }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func breakfastButton_Pressed(_ sender: Any) {
        let breakfast :[CategoryData] = Singleton.sharedInstance.availabitlityData[0].breakfast
        goToViewController(breakfast)
    }
    
    @IBAction func lunchButton_Pressed(_ sender: Any) {
        let lunch :[CategoryData] = Singleton.sharedInstance.availabitlityData[0].lunch
        goToViewController(lunch)
    }
    
    @IBAction func dinnerButton_Pressed(_ sender: Any) {
        let dinner :[CategoryData] = Singleton.sharedInstance.availabitlityData[0].dinner
        print(dinner[0].itemName)
        print(dinner[0].itemPrice)
        goToViewController(dinner)
    }
    
    @IBAction func settingsButton_Pressed(_ sender: Any) {
        if _currentUser.type == .adamin {
         
            let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC-ID") as! SettingsVC
            if let staff = staffArray {
                vc.staffArray = staff
            }
            self.present(vc, animated: true) { }
        }
    }
    
    
    @IBAction func brnLogoutTap(_ sender: UIButton) {
        _currentUser = AppUser()
        _userDefault.set(nil, forKey: kPassword)
        _userDefault.set(nil, forKey: kUsername)
        _userDefault.synchronize()
        let vc = self.storyboard?.instantiateViewController(withIdentifier:"WelcomeVC-ID")
         _appDel.window?.rootViewController = vc
    }
    
    
}
