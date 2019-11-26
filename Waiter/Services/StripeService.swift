//
//  StripeService.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/12/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFunctions
import Alamofire
import Stripe

class StripeService {
    
    var customerID: String!
    var hostConnectAccountID: String!
    lazy var functions = Functions.functions()
    static let instance = StripeService()
    private init() {}
    
    private lazy var baseURL: URL = { // for non-firebase cloud function endpoints
        guard let url = URL(string: Constants.baseURLString) else {
            fatalError("Invalid URL")
        }
        return url
    }()
    
    
    
    // MARK: - ADD / CREATE
    
    // CREATE  P.I.
    
    func createPaymentIntent(paymentMethod: String, customerID: String, _ completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        let params: [String: Any] = [
            "customer_id": customerID,
            "payment_method": paymentMethod,
        ]
        print("--------CREATE PAYMENT INTENT PARAMS-------")
        print(params)
        print("-------------------------------------------")
        functions.httpsCallable("setupPaymentIntent").call(params) { (result, error) in
            if let error = error {
                print(error.localizedDescription.capitalized)
                completion(false, nil)
            } else if let result = result {
                print(result)
                completion(true, result)
            }
        }
    }
    
    // CREATE CUSTOMER
    
    func createStripeCustomer(paymentMethodID: String, last4: String, _ completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        guard let email = FirebaseService.email,
            let name = KeychainService.getDisplayName() else {
                return
        }
        let uid = KeychainService.getfirebaseUID() ?? FirebaseService.uid
        let params: [String: Any] = [
            "email": email,
            "name": name,
            "firebaseUID": uid!,
            "paymentMethodID": paymentMethodID,
            "cardLast4Nums": last4
        ]
        print("--------CREATE CUSTOMER PARAMS-------")
        print(params)
        print("-------------------------------------")
        functions.httpsCallable("createStripeCustomer").call(params) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else if let result = result {
                print(result)
                completion(true, result)
            }
        }
    }
    
    // CREATE CONNECT ACCOUNT
    
    func createConnectAccount(currentUser c: Merchant,
                              source: String,
                              completion: @escaping STPJSONResponseCompletionBlock) {
        var params: [String: Any]!
        var url: URL!
        url = baseURL.appendingPathComponent("v1/setup-company-connect-account")
        print("------------ COMPANY CONNECT ACCOUNT -----------")
        print(source)
        print("----- PARAMS-----")
        params = [
            "company_name": c.name!,
            "company_phone": c.phone!,
            "company_ein": c.ein!,
            "company_address_line_1": c.address.line1!,
            "company_address_city": c.address.city!,
            "company_address_state": c.address.state!,
            "company_address_zip": c.address.zip!,
            "owner_first_name": c.owners[0].ownerFirstName!,
            "owner_last_name": c.owners[0].ownerLastName!,
            "owner_email": c.owners[0].email!,
            "rep_first_name": c.repFirstName ?? "",
            "rep_last_name": c.repLastName ?? "",
            "rep_email": c.repEmail ?? "",
            "rep_job_title": c.repTitle ?? "",
            "rep_address_line_1": c.repAddress.line1 ?? "",
            "rep_address_city": c.repAddress.city ?? "",
            "rep_address_state": c.repAddress.state ?? "",
            "rep_address_zip": c.repAddress.zip ?? "",
            "rep_month": c.repBirthday.month,
            "rep_day": c.repBirthday.day,
            "rep_year": c.repBirthday.year,
            "rep_last_4_ssn": c.repLast4SSN,
            "source": source,
            "is_executive": c.repIsExecutive
        ]
        print(params!)
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("SUCCESS - CREATED CONNECT ACCOUNT")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("FAILED - TO CREATE CONNECT ACCOUNT")
                    completion(nil, error)
                }
        }
    }
    
    
    func updateCompanyConnectAccountBankAccount(connectAccountID: String, source: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/update-company-connect-account-bank-account")
        let params: [String: Any] = [
            "account_id" : connectAccountID,
            "source" : source
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("SUCCESS - UPDATED CONNECT ACCOUNT DETAILS")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("FAILED - TO UPDATE CONNECT ACCOUNT DETAILS")
                    completion(nil, error)
                }
        }
    }
    
    // CREATE BANK ACCOUNT TOKEN
    
    func createACHToken(bankNum: String, routingNum: String, accountHolderName: String, completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        let params: [String: Any] = [
            "bank_account_number": bankNum,
            "bank_routing_number": routingNum,
            "account_holder_name": accountHolderName
        ]
        functions.httpsCallable("createACHToken").call(params) { (response, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else if let response = response {
                print(response)
                completion(true, response)
            }
        }
    }
    
    // ADD BANK ACCOUNT
    
    func addBankAccountToStripeConnectAccount(connectAcctID: String, bankAccount: String, _ completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        let params: [String: Any] = [
            "bankAccount": bankAccount,
        ]
        functions.httpsCallable("updateStripeConnectAccount").call(params) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else if let result = result {
                print(result)
                completion(true, result)
            }
        }
    }
    
    // ADD PAYMENT METHOD
    
    func linkCustomerToPaymentMethod(firebaseUID: String, stripeCustomerID: String, paymentMethodID: String, cardsLast4Num: String, _ completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        let params: [String: Any] = [
            "firebaseUID": firebaseUID,
            "stripeCustomerID": stripeCustomerID,
            "paymentMethodID": paymentMethodID,
            "cardsLast4Num": cardsLast4Num,
        ]
        print("--------LINK CUSTOMER TO PM PARAMS-------")
        print(params)
        print("-----------------------------------------")
        functions.httpsCallable("linkCustomerToPaymentMethod").call(params) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else if let result = result {
                completion(true, result)
            }
        }
    }
    
    
    // MARK: - GET
    
    
    // GET PAYMENT METHODS
    
    func getPaymentMethods(stripeCustomerID: String, _ completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        let params: [String: Any] = [
            "customerID": stripeCustomerID,
        ]
        functions.httpsCallable("getPaymentMethods").call(params) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else if let result = result {
                
                completion(true, result)
            }
        }
    }
    
    
    // GET BALANCE
    
    func getHostsConnectAccountBalance(hostConnectAccountID: String, _ completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        let params: [String: Any] = [
            "hostConnectAccountID": hostConnectAccountID,
        ]
        functions.httpsCallable("getBalance").call(params) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else if let result = result {
                print(result)
                completion(true, result)
            }
        }
    }
    
    
    
    // MARK: - CHARGES
    
    
    // CHARGE CUSTOMERS
    
    func chargeCustomersPaymentMethod(amount: String, paymentMethod: String, customerID: String, email: String, hostConnectAccountID: String, _ completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        let params: [String: Any] = [
            "amount": amount,
            "paymentMethod": paymentMethod,
            "customerID": customerID,
            "email": email,
            "hostConnectAccountID": hostConnectAccountID,
        ]
        functions.httpsCallable("chargeCustomer").call(params) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else if let result = result {
                print(result)
                completion(true, result)
            }
        }
    }
    
    
    
    // MARK: - DELETE
    
    
    // DELETE PAYMENT METHOD
    
    func deletePaymentMethod(paymentMethodID: String, _ completion: @escaping (Bool, HTTPSCallableResult?) -> ()) {
        let params: [String: Any] = [
            "paymentMethodID": paymentMethodID,
        ]
        functions.httpsCallable("deletePaymentMethod").call(params) { (result, error) in
            if let error = error {
                print(error.localizedDescription)
                completion(false, nil)
            } else if let result = result {
                print(result)
                completion(true, result)
            }
        }
    }
    
    
    func createPaymentIntent(amount: String, paymentMethodID: String, description: String, orderID: String, hostConnectAccountID: String, date: Date, completion: @escaping STPJSONResponseCompletionBlock) {
        print("------------ SETTING UP PAYMENT INTENT ---------------")
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        let newDate = dateFormatter.string(from: date)
        let u = Auth.auth().currentUser!
        let email = u.email ?? DataService.instance.retrieveAuthUsername()!
        let url = baseURL.appendingPathComponent("v1/create-payment-intent")
        let params: [String: Any] = [
            "amount": amount,
            "description": description,
            "payment_method": paymentMethodID,
            "customer_id": self.customerID!,
            "email": email,
            "host_connect_account_id": hostConnectAccountID,
            "activity_UID": orderID,
            "buyer_firebase_UID": u.uid,
            "activity_date": "\(newDate)"
        ]
        print("-------------- PARAMS FOR CREATING PAYMENT INTENT: -----------")
        print(params)
        print("--------------------------------------------------------------")
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("SUCCESS - CREATED PAYMENT INTENT")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("FAILED - TO CREATE PAYMENT INTENT")
                    completion(nil, error)
                }
        }
    }
    
    func createCustomerAtRegistration(with email: String, name: String, firebaseUID: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/create-customer-at-registration")
        let params: [String: Any] = [
            "email": email,
            "name": name,
            "firebaseUID": firebaseUID
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<500)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("SUCCESS - CREATED CUSTOMER")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("FAILED - TO CREATE CUSTOMER")
                    completion(nil, error)
                }
        }
    }
    
    func createCustomerAndLinkToPaymentMethod(_ paymentID: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/create-customer-and-link-payment-method")
        let x = Auth.auth().currentUser!
        let n: String = x.displayName ?? DataService.instance.retrieveDisplayName()!
        let params: [String: Any] = [
            "payment_method": paymentID,
            "email": x.email!,
            "name": n,
            "firebaseUID": x.uid
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("SUCCESS - CREATED CUSTOMER AND/OR LINK PAYMENT METHOD")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("FAILED - TO CREATE CUSTOMER AND/OR LINK PAYMENT METHOD")
                    completion(nil, error)
                }
        }
    }
    
    func linkPaymentMethodToExistingStripeCustomer(paymentID: String, _ customerID: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/link-payment-method-to-preexisting-customer")
        let email = Auth.auth().currentUser?.email ?? DataService.instance.retrieveAuthUsername()
        print("-------- EMAIL --------")
        print(email!)
        print("-----------------------")
        let params: [String: Any] = [
            "payment_method": paymentID,
            "customer_id": customerID,
            "email": email!
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("SUCCESS - ATTACHED PAYMENT TO CUSTOMER")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("FAILED - TO ATTACHED PAYMENT TO CUSTOMER")
                    completion(nil, error)
                }
        }
    }
    
    func createBankAccountToken(bankAccount: String,
                                routingNumber: String,
                                accountHolder: String,
                                accountType: String,
                                completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/create-ba-token")
        let params: [String: Any] = [
            "name": accountHolder,
            "type": accountType,
            "routing_number": routingNumber,
            "bank_account": bankAccount
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("SUCCESS - CREATING BA TOKEN")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("FAILED - TO CREATE BA TOKEN")
                    completion(nil, error)
                }
        }
    }
    
    func createBankAccount(customerId: String, source: String, bankName: String, completion: @escaping STPJSONResponseCompletionBlock ) {
        let url = baseURL.appendingPathComponent("v1/create-bank-account")
        print("BANK ACCOUNT SOURCE TOKEN - \(source)")
        let params: [String : Any] = [
            "customer_id" : customerId,
            "source" : source,
            "bank_account" : bankName
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    print("SUCCESS - CREATED BANK ACCOUNT")
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    print("FAILED - TO CREATE BANK ACCOUNT")
                    completion(nil, error)
                }
        }
    }
    
    func deleteBankAccount(customerId: String, source: String, completion: @escaping STPJSONResponseCompletionBlock ) {
        let url = baseURL.appendingPathComponent("v1/delete-bank-account")
        let params: [String : Any] = [
            "customer_id" : customerId,
            "source" : source
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func createCard(with token: String, customer: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/create-card")
        let params: [String: Any] = [
            "source": token,
            "customer": customer
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func refundCustomer(with charge: String, completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/refund")
        let params: [String: Any] = [
            "charge": charge
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func completeCharge(with token: String, amount: Int, email: String, metadata: [String : Any], completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/charge")
        let params: [String: Any] = [
            "source": token,
            "amount": amount,
            "currency": "usd",
            "email" : email,
            "metadata" : metadata
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    func completeChargeWithCustomer(with token: String, amount: Int, customer: String, metadata: [String : Any], completion: @escaping STPJSONResponseCompletionBlock) {
        let url = baseURL.appendingPathComponent("v1/charge-with-customer")
        let params: [String: Any] = [
            "source": token,
            "amount": amount,
            "currency": "usd",
            "customer": customer,
            "metadata": metadata
        ]
        Alamofire.request(url, method: .post, parameters: params)
            .validate(statusCode: 200..<300)
            .responseJSON { responseJSON in
                switch responseJSON.result {
                case .success(let json):
                    completion(json as? [String: AnyObject], nil)
                case .failure(let error):
                    completion(nil, error)
                }
        }
    }
    
    //    func handleCardSetup(name: String, clientSecret: String, paymentMethodID: String, completion: @escaping STPJSONResponseCompletionBlock) {
    //        let url = baseURL.appendingPathComponent("v1/handle-card-setup")
    //        let params: [String: Any] = [
    //            "client_secret": clientSecret,
    //            "payment_method": paymentMethodID,
    //            "name": name
    //        ]
    //        Alamofire.request(url, method: .post, parameters: params)
    //            .validate(statusCode: 200..<300)
    //            .responseJSON { responseJSON in
    //                switch responseJSON.result {
    //                case .success(let json):
    //                    print("SUCCESS - HANDLED CARD SETUP")
    //                    completion(json as? [String: AnyObject], nil)
    //                case .failure(let error):
    //                    print("FAILED - TO HANDLE CARD SETUP")
    //                    completion(nil, error)
    //                }
    //        }
    //    }
    
    
    
}


