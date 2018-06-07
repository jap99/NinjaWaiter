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
         print(staffArray)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print(staffArray)
    }

    // MARK: - ACTIONS
    
    func goToViewController() {
        let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerVC-ID") as! ViewController
        self.present(vc, animated: true) { }
    }
    
    // MARK: - IBACTIONS
    
    @IBAction func breakfastButton_Pressed(_ sender: Any) {
        goToViewController()
    }
    
    @IBAction func lunchButton_Pressed(_ sender: Any) {
        goToViewController()
    }
    
    @IBAction func dinnerButton_Pressed(_ sender: Any) {
        goToViewController()
    }
    
    @IBAction func settingsButton_Pressed(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC-ID") as! SettingsVC
        self.present(vc, animated: true) { }
    }
    
}
