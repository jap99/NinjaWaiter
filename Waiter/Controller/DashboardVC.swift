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
  //      fetchCategoryFromServer()
        
        if RESTAURANT_UID != nil {
            DataService.instance.getSettingsData { (_, _) in
            }
            DataService.instance.getAvailabilityDataFromServer()  // currently called in welcomeVC's loginAPI function
        }
        
        
        
    }
    
    func  fetchCategoryFromServer() { // won't need this in the future
        DispatchQueue.global(qos: .background).async {
            
            DataService.instance.getCategoriesFromServer { (categories: [Category]?, error) in
                guard let _ = error else {
                    return
                }
            }
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
    }

    // MARK: - ACTIONS
    
    func goToViewController(menuData: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerVC-ID") as! ViewController
        vc.tag = menuData
        self.present(vc, animated: true) { }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func breakfastButton_Pressed(_ sender: Any) {
        let breakfast = Singleton.sharedInstance.availabilityData[0].breakfast
        print(breakfast)
       
//        DataManager.shared().getCategoryList(order: "Breakfast")
        goToViewController(menuData: 0)
    }
    
    @IBAction func lunchButton_Pressed(_ sender: Any) {
       // let lunch: [CategoryData] = Singleton.sharedInstance.availabilityData[0].lunch
         let lunch = Singleton.sharedInstance.availabilityData[0].lunch
        print(lunch)
        goToViewController(menuData: 1)
        //goToViewController(lunch)
    }
    
    @IBAction func dinnerButton_Pressed(_ sender: Any) {
        let dinner = Singleton.sharedInstance.availabilityData[0].dinner
//        let dinner: [CategoryData] = Singleton.sharedInstance.availabilityData[0].dinner
//        goToViewController(dinner)
        print(dinner)
        goToViewController(menuData: 2)
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
