//
//  OrderSuccess.swift
//  Waiter
//
//  Created by Javid Poornasir on 5/22/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import UIKit

class OrderSuccessVC: UIViewController {

    
    @IBOutlet weak var gifView: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        gifView.loadGif(name: "ordered-animation")
    }

   
    
    @IBAction func goback(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC-ID") as! SettingsVC
        self.present(vc, animated: true) { }
    }
    
}
