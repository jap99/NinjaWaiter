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
    @IBOutlet weak var countdownTextField: UILabel!
    
    var seconds = 11
    var timer = Timer()
    var isTimerRunning = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        hideKeyboardWhenTappedAround()
        gifView.loadGif(name: "ordered-animation")
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        runTimer()
    }

    override func viewWillDisappear(_ animated: Bool) {
        resetButtonTapped()
    }
   
    
    // MARK: - IBACTIONS
    
    @IBAction func goback(_ sender: Any) {
        let vc = storyboard?.instantiateViewController(withIdentifier: "SettingsVC-ID") as! SettingsVC
        self.present(vc, animated: true) { }
    }
    
    // MARK: - ACTIONS
    
    func runTimer() {
        timer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: (#selector(OrderSuccessVC.updateTimer)), userInfo: nil, repeats: true)
    }
    
    @objc func updateTimer() {
        
        if seconds > 0 {
            seconds -= 1     //This will decrement(count down)the seconds.
            DispatchQueue.main.async {
                self.countdownTextField.text = "This screen will automatically close in \(self.seconds) seconds"  
            }
            
        } else {
            let vc = storyboard?.instantiateViewController(withIdentifier: "ViewControllerVC-ID") as! ViewController
            self.present(vc, animated: true) { }
        }
        
    }
    
    func resetButtonTapped() {
        timer.invalidate()
        seconds = 10
        countdownTextField.text = "\(seconds)"
    }
}
