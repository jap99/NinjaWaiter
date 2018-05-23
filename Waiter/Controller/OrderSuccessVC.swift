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

        gifView.loadGif(name: "ordered-animation")
    }

   
    

}
