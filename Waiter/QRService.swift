//
//  QRService.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/22/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import UIKit

class QRService {
    
    private init() {}
    
    private static func generateQRCode(from string: String) -> UIImage? {
        let data = string.data(using: String.Encoding.ascii)
        if let filter = CIFilter(name: "CIQRCodeGenerator") {
            filter.setValue(data, forKey: "inputMessage")
            let transform = CGAffineTransform(scaleX: 3, y: 3)
            if let output = filter.outputImage?.transformed(by: transform) {
                return UIImage(ciImage: output)
            }
        }
        return nil
    }

    // https://www.hackingwithswift.com/example-code/media/how-to-create-a-qr-code
    
    let image = generateQRCode(from: "Hacking with Swift is the best iOS coding tutorial I've ever read!")
    
    
}
