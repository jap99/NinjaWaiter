//
//  DashboardVC.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit
import Kingfisher

class DashboardVC: BaseViewController {
    
    @IBOutlet weak var breakfastButton: UIButton!
    @IBOutlet weak var lunchButton: UIButton!
    @IBOutlet weak var dinnerButton: UIButton!
    @IBOutlet weak var settingsButton: UIButton!
    
    @IBOutlet weak var topLabel: UILabel!
    @IBOutlet weak var containerView: UIView!
    @IBOutlet weak var v1: UIView!
    @IBOutlet weak var v2: UIView!
    
    @IBOutlet weak var orderingButton: RoundedButton!
    
    var staffArray: [StaffMember]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        v1.layer.cornerRadius = 8
        v2.layer.cornerRadius = 8
        orderingButton.clipsToBounds = true 
        settingsButton.isEnabled = _currentUser.type == .adamin
        hideKeyboardWhenTappedAround()
        if UIScreen.main.bounds.width < 1030 {
            topLabel.translatesAutoresizingMaskIntoConstraints = false
            containerView.translatesAutoresizingMaskIntoConstraints = false
            NSLayoutConstraint.activate([
                NSLayoutConstraint.constraints(withVisualFormat: "V:|-65-[l]-50-[v]", options: [], metrics: nil, views: ["l": topLabel, "v":containerView])
                ].flatMap{$0})
        }
        if RESTAURANT_UID != nil {
            self.startIndicator()
            DataService.instance.getSettingsData { (dict, error) in
                self.stopIndicator()
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print(dict!)
                }
            }
        }
        DataService.instance.getAvailabilityDataFromServer()  // currently called in welcomeVC's loginAPI function
        self.startIndicator()
        
        // BREAKFAST
        
        DataManager.shared().getCategoryList(order:CategoryType.breakfast.rawValue) { [weak self] (arrayCategory) in
            guard let selff = self else { return }
            selff.stopIndicator()
            guard let arrayCategory = arrayCategory else {
                selff.breakfastButton.isEnabled = false
                selff.breakfastButton.backgroundColor = customRed2
                return
            }
            if arrayCategory.count > 0 { 
                for cat in arrayCategory {
                    let category = CategoryEntity.createNewEntity(key:"categoryUID", value:cat.categoryId as NSString)
                    category.updateWith(cat: cat, type: .breakfast)
                }
                _appDel.saveContext()
            } else {
                selff.breakfastButton.isEnabled = true
                selff.breakfastButton.backgroundColor = customRed
            }
        }
        
        // LUNCH
        
        DataManager.shared().getCategoryList(order:CategoryType.lunch.rawValue) { [weak self] (arrayCategory) in
            guard let selff = self else { return }
            selff.stopIndicator()
            guard let arrayCategory = arrayCategory else {
                selff.lunchButton.isEnabled = false
                selff.lunchButton.backgroundColor = customRed2
                return
            }
            if arrayCategory.count > 0 {
                for cat in arrayCategory {
                    let category = CategoryEntity.createNewEntity(key:"categoryUID", value:cat.categoryId as NSString)
                    category.updateWith(cat: cat, type: .lunch)
                }
                _appDel.saveContext()
            } else {
                selff.lunchButton.isEnabled = true
                selff.lunchButton.backgroundColor = customRed
            }
            
        }
        
        // DINNER
        
        DataManager.shared().getCategoryList(order:CategoryType.dinner.rawValue) { [weak self ](arrayCategory) in
            guard let selff = self else { return }
            selff.stopIndicator()
            guard let arrayCategory = arrayCategory else {
                selff.dinnerButton.isEnabled = false
                selff.dinnerButton.backgroundColor = customRed2
                return
            }
            if arrayCategory.count > 0 {
                for cat in arrayCategory {
                    let category = CategoryEntity.createNewEntity(key:"categoryUID", value:cat.categoryId as NSString)
                    category.updateWith(cat: cat, type: .dinner)
                }
                _appDel.saveContext()
            } else {
                selff.dinnerButton.isEnabled = true
                selff.dinnerButton.backgroundColor = customRed
            }
            
        }
        //        let predicate = NSPredicate(format: "categroyType == %@", argumentArray:[categoryType.rawValue])
        //        let arrayCategory = CategoryEntity.fetchDataFromEntity(predicate: predicate, sortDescs: nil)
        // let arrCat = CategoryEntity.fetchDataFromEntity(predicate: <#T##NSPredicate?#>, sortDescs: <#T##NSArray?#>)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        
//        DataService.instance.getAvailabilityDataFromServer()  // currently called in welcomeVC's loginAPI function
//        self.startIndicator()
//
//        DataManager.shared().getCategoryList(order:CategoryType.breakfast.rawValue) { [weak self] (arrayCategory) in
//            self?.stopIndicator()
//            if arrayCategory.count > 0 {
//                DispatchQueue.main.async {
//                    self?.breakfastButton.isHidden = true
//                }
//
//                for cat in arrayCategory {
//                    let category = CategoryEntity.createNewEntity(key:"categoryUID", value:cat.categoryId as NSString)
//                    category.updateWith(cat: cat, type: .breakfast)
//                }
//                _appDel.saveContext()
//            } else {
//                DispatchQueue.main.async {
//                    self?.breakfastButton.isHidden = true
//                }
//
//            }
//        }
//
//        DataManager.shared().getCategoryList(order:CategoryType.lunch.rawValue) { (arrayCategory) in
//            self.stopIndicator()
//            if arrayCategory.count > 0 {
//
//            } else {
//
//            }
//            for cat in arrayCategory {
//                let category = CategoryEntity.createNewEntity(key:"categoryUID", value:cat.categoryId as NSString)
//                category.updateWith(cat: cat, type: .lunch)
//            }
//            _appDel.saveContext()
//        }
//        DataManager.shared().getCategoryList(order:CategoryType.dinner.rawValue) { (arrayCategory) in
//            self.stopIndicator()
//            if arrayCategory.count > 0 {
//
//            } else {
//
//            }
//            for cat in arrayCategory {
//                let category = CategoryEntity.createNewEntity(key:"categoryUID", value:cat.categoryId as NSString)
//                category.updateWith(cat: cat, type: .dinner)
//            }
//            _appDel.saveContext()
//        }
////        let predicate = NSPredicate(format: "categroyType == %@", argumentArray:[categoryType.rawValue])
////        let arrayCategory = CategoryEntity.fetchDataFromEntity(predicate: predicate, sortDescs: nil)
//        // let arrCat = CategoryEntity.fetchDataFromEntity(predicate: <#T##NSPredicate?#>, sortDescs: <#T##NSArray?#>)
        super.viewWillAppear(true)
    }
    
    func  fetchCategoryFromServer() { // won't need this in the future
        DispatchQueue.global(qos: .background).async {
            self.startIndicator()
            DataService.instance.getCategoriesFromServer { (categories: [Category]?, error) in
                self.stopIndicator()
                guard let _ = error else {
                    return
                }
            }
        }
    }
    
    // MARK: - ACTIONS
    
    func goToViewController(menuData: Int) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerVC-ID") as! ViewController
        vc.tag = menuData
        vc.categoryType = CategoryType.getType(raw: menuData)
        self.present(vc, animated: true) { }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func breakfastButton_Pressed(_ sender: Any) {
        let _ = Singleton.sharedInstance.availabilityData[0].breakfast
        goToViewController(menuData: 0)
    }
    
    @IBAction func lunchButton_Pressed(_ sender: Any) {
        let _ = Singleton.sharedInstance.availabilityData[0].lunch
        goToViewController(menuData: 1)
    }
    
    @IBAction func dinnerButton_Pressed(_ sender: Any) {
        let _ = Singleton.sharedInstance.availabilityData[0].dinner
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
