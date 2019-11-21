//
//  QRCode.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/21/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import UIKit


class QRCode {
    
//    static func encodePayment(total: Double = 0.00,
//                              receipt: Receipt?,
//                              checkinID: String,
//                              tax: Double = 0.00, type: CheckinStatus) -> String? {
//        guard let user = KeychainService.getUser(),
//            let merchant = user.merchant else {
//            return nil
//        }
//        guard let address = UserDefaults.standard.object(forKey: "") as? String else {
//            return nil
//        }
//        guard let wallet = KeychainService.getWallet() else {
//            return nil
//        }
//        var state = merchant.state ?? ""
//        let temp = States.statesDict.key(forValue: state)
//        if temp != nil {
//            state = temp!
//        }
//        let locationInfo = "\(merchant.address ?? ""), \(merchant.city ?? ""), \(state) \(merchant.zip ?? "")"
//        let amount = String(format: "%.2f", arguments: [total])
//        let taxStr = String(format: "%.2f", arguments: [tax])
//        let qrElements = [
//            "waiter-app-txt",                               // 0.
//            amount,                                         // 2. Amount
//            merchant,                                       // 3. Merchant (ID, Name, Address, City, State, Zip)
//            QRCode.createReceipt()!,                        // 4. Unique Receipt ID (partially Sequence Based)
//            wallet,                                         // 6. Merchant's Ethereum Address
//            String(describing: merchant.tipping),           // 7. Boolean that Describes if tipping is enabled
//            taxStr,                                         // 8. Tax amount to be added to the Transaction
//            String(describing: type)                        // 9. Checkin Status - Type
//        ]
//        print(qrElements)
//        var encodedPayment = qrElements.joined(separator: "|||")
//        // Attach a json serialized RECEIPT to the end of the QR Code if available
//        if let receipt = receipt {
//            encodedPayment.append("|||")
//            encodedPayment.append(receipt.toJsonString(checkinId: checkinId))
//        }
//        return encodedPayment
//    }
//
//    static func createReceipt() -> String? {
//        guard let user = try! Persistence.Users.getUser(withContext: nil),
//            let merchant = user.merchant else {
//            return nil
//        }
//        guard let merchantCode = merchant.merchantCode else {
//            return nil
//        }
//        let transactionCount = Persistence.Transactions.count()
//        var count = String(transactionCount + 1)
//        while count.count < 8 {
//            count = "0\(count)"
//        }
//        let lastFive = String(merchantCode.suffix(5))
//        let currentReceipt = "\(lastFive)-\(count)"
//        return currentReceipt
//    }
    
}
