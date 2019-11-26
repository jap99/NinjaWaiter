//
//  DataServices.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import FirebaseDatabase
import FirebaseStorage
import FirebaseAuth
import SwiftKeychainWrapper

final class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    static private var databaseUrl: String {
        return ""
    }
    
    var mainRef: DatabaseReference {
        return Database.database().reference()
    }
    
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: storageKey)
    }
    
    var imagesStorageRef: StorageReference {
        return mainStorageRef.child("images")
    }
    
    var itemImageUrlString: String?     // SAVE ITEM - TO ITEMS NODE & AVAILABILITY NODE
    private var KEY_UID = "uid"
    private let FIR_CHILD_USERS: String = "users"
    
    // NODES
    
    let FIR_RESTAURANTS = "Restaurants"
    let FIR_STAFF_MEMBERS = "Staff"
    let FIR_ADMINISTRATORS = "Administrators"
    let FIR_SECTIONS = "Sections"
    let FIR_DRINKS = "Drinks"
    let FIR_PRINTERS = "Printers"
    let FIR_SETTINGS = "Settings"
    let FIR_CATEGORY = "Category"
    let FIR_CATEGORIES = "Categories"
    let FIR_AVAILABILITY = "Availability"
    let FIR_ITEMS = "Items"
    let FIR_MENU = "Menu"
    let FIR_BREAKFAST = "Breakfast"
    let FIR_LUNCH = "Lunch"
    let FIR_DINNER = "Dinner"
    
    let APP_NAME = "Waiter App"
    var _currentUser = AppUser()
    static var RESTAURANT_UID: String!
    var IS_USER_LOGGED_IN = false
    let _userDefault = UserDefaults.standard
    let kUsername = "kUsername"
    let kPassword = "kPassword"
    let _appDel = UIApplication.shared.delegate as! AppDelegate
    
    let databaseKey = "https://waiter-9249e.firebaseio.com/"
    let storageKey = "gs://waiter-9249e.appspot.com/"
    
    
    // MARK: - SAVE
    
    
    // PUSH NOTIFICATION TOKEN - (SAVE)
    
    func saveDeviceToken(token: String, firebaseId: String, completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        let token = ["token": token]
        mainRef.child(FIR_CHILD_USERS).child(firebaseId).updateChildValues(token) { (error, ref) in
            if let error = error {
                completion(false, error)
            } else {
                print(ref)
                completion(true, nil)
            }
        }
    }
    
    // STRIPE CUSTOMER ID - (SAVE)
    
    func saveStripeCustomerID(_ customerID: String) {
        let id: [String: String] = [
            Constants.STRIPE_CUSTOMER_ID: customerID
        ]
        if let firebaseUID = KeychainService.getfirebaseUID() {
            mainRef.child(FIR_CHILD_USERS).child(firebaseUID).updateChildValues(id) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print("---- SAVED STRIPE CUSTOMER ID TO FIREBASE ----")
                    print(ref)
                    print("----------------------------------------------")
                }
            }
        }
    }
    
    // PAYMENT METHOD - (SAVE)
    
    func saveStripePaymentMethod(paymentMethodID: String) {
        let paymentMethod: [String: String] = [
            Constants.STRIPE_PAYMENT_METHOD: paymentMethodID
        ]
        if let firebaseUID = KeychainService.getfirebaseUID() {
            mainRef.child(FIR_CHILD_USERS).child(firebaseUID).updateChildValues(paymentMethod) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                } else {
                    print(ref)
                }
            }
        }
    }
    
    // STRIPE CONNECT ACCOUNT ID - (SAVE)
    
    func saveHostConnectAccountID(_ accountID: String, completion: @escaping (_ success: Bool, _ error: Error?) -> ()) {
        let id: [String: String] = [
            Constants.HOST_CONNECT_ACCOUNT_ID: accountID
        ]
        
        if let firebaseUID = KeychainService.getfirebaseUID() {
            mainRef.child(FIR_CHILD_USERS).child(firebaseUID).updateChildValues(id) { (error, ref) in
                if let error = error {
                    print(error.localizedDescription)
                    completion(false, error)
                } else {
                    print("---- SAVED STRIPE CUSTOMER ID TO FIREBASE ----")
                    completion(true, nil)
                    print(ref)
                    print("----------------------------------------------")
                }
            }
        } else {
            completion(false, nil)
        }
    }
    
    
    // MARK: - GET
    
    
    // USER PROFILE FROM FIREBASE - (GET)
    
    func getDisplayNameFromFirebase(_ completion: @escaping (String?) -> Void) {
        if let firebaseUID = KeychainService.getfirebaseUID() {
            mainRef.child("users").child(firebaseUID).observeSingleEvent(of: .value) { (snapshot) in
                if let value = snapshot.value as? [String: Any] {
                    if let displayName = value["displayName"] as? String {
                        completion(displayName)
                    } else {
                        print("NO DISPLAY NAME AVAILABLE")
                        completion(nil)
                    }
                }
            }
        }
    }
    
    // STRIPE CUSTOMER ID - (GET)
    
    func getStripeCustomerID(completion: @escaping (_ stripeCustomerID: String?) -> ()) {
        if let firebaseUID = KeychainService.getfirebaseUID() {
            mainRef.child(FIR_CHILD_USERS).child(firebaseUID).observeSingleEvent(of: .value, with:{ (snapshot) in
                if let value = snapshot.value as? [String: Any],
                    let id = value[Constants.STRIPE_CUSTOMER_ID] as? String {
                    completion(id)
                    return
                }
                completion(nil)
                return
            }) {(error) in
                print(error.localizedDescription)
                completion(nil)
                return
            }
        }
    }
    
    // DEVICE TOKEN - (GET)
    
    func getDeviceToken(_ token: String, _ completion: @escaping (_ token: String?) -> Void) {
        if let firebaseUID = KeychainService.getfirebaseUID() {
            mainRef.child(FIR_CHILD_USERS).child(firebaseUID).observeSingleEvent(of: .value, with:{ (snapshot) in
                if let value = snapshot.value as? [String: Any],
                    let token = value["deviceToken"] as? String {
                    completion(token)
                }
            }) {(error) in }
            completion(nil)
        }
    }
    
    // PAYMENT METHOD - (GET)
    
    func getStripePaymentMethod(completion: @escaping (_ paymentMethodID: String?) -> ()) {
        if let firebaseUID = KeychainService.getfirebaseUID() {
            mainRef.child(FIR_CHILD_USERS).child(firebaseUID).observeSingleEvent(of: .value, with:{ (snapshot) in
                if let value = snapshot.value as? [String: Any],
                    let pm = value[Constants.STRIPE_PAYMENT_METHOD] as? String {
                    print(pm)
                    completion(pm)
                    return
                }
                completion(nil)
                return
            }) {(error) in
                print(error.localizedDescription)
                completion(nil)
                return
            }
        }
    }
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // MARK: - KEYCHAIN SERVICES
    
    func removeKeychainWrapper(_ completion: @escaping (Bool) -> Void) {
        if KeychainWrapper.standard.removeAllKeys() {
            print("JAVID: Data removed all keys from keychain")
            completion(true)
        } else {
            completion(false)
        }
    }
    
    func saveAuthCredentials(un username: String, pw password: String, id: String, firstName: String, lastName: String) {
        let unSaveSuccessful: Bool = KeychainWrapper.standard.set(username, forKey: Constants.username)
        let pwSaveSuccessful: Bool = KeychainWrapper.standard.set(password, forKey: Constants.password)
        let firstNameSaveSuccessful: Bool = KeychainWrapper.standard.set(firstName, forKey: Constants.firstName)
        let lastNameSaveSuccessful: Bool = KeychainWrapper.standard.set(lastName, forKey: Constants.lastName)
        let dp = "\(firstName)" + " " + "\(lastName)"
        let displayNameSaveSuccessful: Bool = KeychainWrapper.standard.set(dp, forKey: Constants.displayName)
        let keychainResult = KeychainWrapper.standard.set(id, forKey: KEY_UID)
        print("JAVID: FirebaseUID saved to keychain - Keychain Result: \(keychainResult)")
        print("JAVID: Username saved to keychain - Keychain Result: \(unSaveSuccessful)")
        print("JAVID: Password saved to keychain - Keychain Result: \(pwSaveSuccessful)")
        print("JAVID: First name saved to keychain - Keychain Result: \(firstNameSaveSuccessful)")
        print("JAVID: Last name saved to keychain - Keychain Result: \(lastNameSaveSuccessful)")
        print("JAVID: Display name saved to keychain - Keychain Result: \(displayNameSaveSuccessful)")
    }
    
    func retrieveAuthUsername() -> String? {
        let un: String? = KeychainWrapper.standard.string(forKey: Constants.username, withAccessibility: nil)
        print("JAVID: Retrieval results for username & password from keychain - UN: \(String(describing: un))")
        return un
    }
    
    func retrieveAuthPassword() -> String? {
        let pw: String? = KeychainWrapper.standard.string(forKey: Constants.password, withAccessibility: nil)
        print("JAVID: Retrieval results for username & password from keychain - PW: \(String(describing: pw))")
        return pw
    }
    
    func retrieveFirstName() -> String? {
        let fn: String? = KeychainWrapper.standard.string(forKey: Constants.firstName, withAccessibility: nil)
        print("JAVID: Retrieval results for first Name from keychain - PW: \(String(describing: fn))")
        return fn
    }
    
    func retrieveLastName() -> String? {
        let ln: String? = KeychainWrapper.standard.string(forKey: Constants.lastName, withAccessibility: nil)
        print("JAVID: Retrieval results for username & password from keychain - PW: \(String(describing: ln))")
        return ln
    }
    
    func retrieveDisplayName() -> String? {
        let ln: String? = KeychainWrapper.standard.string(forKey: Constants.displayName, withAccessibility: nil)
        print("JAVID: Retrieval results for username & password from keychain - PW: \(String(describing: ln))")
        return ln
    }
    
    func retrieveFirebaseUID() -> String? {
        let uid: String? = KeychainWrapper.standard.string(forKey: KEY_UID, withAccessibility: nil)
        print("JAVID: Retrieval results for Firebase UID from keychain - UID: \(String(describing: uid))")
        return uid
    }
    
    
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    ////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////////
    
    
    // MARK: - GET
    
    
    // GET SETTINGS DATA
    
    func getSettingsData(callback: ((_ categories: [String: AnyObject]?, _ error: Error?) -> Void)?) { // Includes table numbers
        mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_SETTINGS).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            } else {
                Singleton.sharedInstance.settingsData = Settings.shared.parseSettingData(snapshot: snapshot)
                callback?((snapshot.value as! [String : AnyObject]), nil)
            }
        }
    }
    
    // GET AVAILABILITY - BREAKFAST, LUNCH, DINNER
    
    func getAvailabilityDataFromServer() {
        mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).observe(.value) { (snapshot: DataSnapshot) in
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                let availability = Availability(dict:snapshot)
                Singleton.sharedInstance.availabilityData = [availability]
            }
        }
    }
     
    // GET RESTAURANT UID
    
    func getRestaurantUID(userUID: String, completion:@escaping ((_ restD:String?) -> ())) {
        mainRef.child(FIR_STAFF_MEMBERS).child(userUID).observe(.value) { (snapshot) in
            if snapshot.exists(),let restID = snapshot.value as? String {
                completion(restID)
            } else {
                completion(nil)
            }
        }
    }
    
    // RENAME CATEGORY
    
    func renameCategory(categoryUID: String, updatedName: String, completion: @escaping (Bool) -> ()) {
        let categoryData: Dictionary<String, AnyObject> = [
            categoryUID: updatedName as AnyObject
        ]
        mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).updateChildValues(categoryData) { (error, ref) in
            if error != nil {
                print(error?.localizedDescription ?? "ERROR RENAMING CATEGORY")
            } else {
                print(ref)
            }
        }
    }
    
    // DELETE CATEGORY
    
    func deleteCategory(categoryUID: String, completion: @escaping (Bool) -> ()) {
        mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).child(categoryUID).removeValue { (error, reference) in
            if let error = error {
                print(error.localizedDescription)
            } else {  self.mainRef.child(self.FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(self.FIR_MENU).child(self.FIR_AVAILABILITY).child(self.FIR_BREAKFAST).child(self.FIR_CATEGORIES).child(categoryUID).removeValue { (error, reference) in
                if let error = error {
                    print("BREAKFAST - ERROR REMOVING CATEGORY: \(error.localizedDescription)")
                } else {
                    print("REMOVED CATEGORY FROM BREAKFAST NODE")
                }
                }
                self.mainRef.child(self.FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(self.FIR_MENU).child(self.FIR_AVAILABILITY).child(self.FIR_LUNCH).child(self.FIR_CATEGORIES).child(categoryUID).removeValue { (error, reference) in
                    if let error = error {
                        print("LUNCH - ERROR REMOVING CATEGORY: \(error.localizedDescription)")
                    } else {
                        print("REMOVED CATEGORY FROM LUNCH NODE")
                    }
                }
                self.mainRef.child(self.FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(self.FIR_MENU).child(self.FIR_AVAILABILITY).child(self.FIR_DINNER).child(self.FIR_CATEGORIES).child(categoryUID).removeValue { (error, reference) in
                    if let error = error {
                        print("DINNER - ERROR REMOVING CATEGORY: \(error.localizedDescription)")
                    } else {
                        print("REMOVED CATEGORY FROM DINNER NODE")
                    } 
                }
            }
        }
    }
    
    // SAVE CATEGORY - TO RESTAURANT NODE
    
    func saveCategory(categoryName: String, completion: @escaping (Bool) -> ()) {
        if let categoryUID = mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORIES).child(FIR_CATEGORY).childByAutoId().key {
            let category: Dictionary<String, AnyObject> = [categoryUID: categoryName as AnyObject ]
            mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).updateChildValues(category) { (error, ref) in
                if let error = error {
                    print("ERROR CREATING IMAGE IN DATABASE --- ERROR DESCRIPTION: \(error.localizedDescription)")
                    completion(false)
                } else {
                    completion(true)
                }
            }
        } 
    }
    
    // GET CATEGORIES (1/2)
    
    func getCategories(callback: ((_ categories: [Category]?, _ error: Error?) -> Void)?) {
        mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            }
            callback?(Category.parseCategoryData(snapshot: snapshot),nil)
            Singleton.sharedInstance.categoriesItems = Category.parseCategoryData(snapshot: snapshot)
        }
    }
    
    // GET CATEGORIES (2/2)
    
    func getCategoriesFromServer(callback: ((_ categories: [Category]?, _ error: Error?) -> Void)?) {
        mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).observe(.value) { (snapshot) in
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            }
            Singleton.sharedInstance.categoriesItems = Category.parseCategoryData(snapshot: snapshot)
        }
    }
    
     
    // GET ITEMS FROM CATEGORY
    
    func getCategoryItems(categoryUID: String, callback: ((_ categories: [String: AnyObject]?, _ error: Error?) -> Void)?) {
        if categoryUID != "" {
            mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child("CategoryDetails").child(categoryUID).observe(.value) { (snapshot) in
                if !snapshot.exists() {
                    callback?(nil, nil)
                    return
                } else {
                    print(snapshot.value as AnyObject)
                    callback?((snapshot.value as! [String : AnyObject]), nil)
                }
            }
        } else {
            mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child("CategoryDetails").observe(.value) { (snapshot) in
                if !snapshot.exists() {
                    callback?(nil, nil)
                    return
                } else {
                    print(snapshot.value as AnyObject)
                    callback?((snapshot.value as! [String : AnyObject]), nil)
                }
            }
        }
    }
    
    // GET ITEM OPTION
    
    func getItemOption(itemId: String, callback: ((_ categories: [ItemOption]?, _ error: Error?) -> Void)?) {  mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child("Items").child(itemId).child("itemDetails").child("itemOption").observe(.value) { (snapshot) in
        if !snapshot.exists() {
            callback?(nil, nil)
            return
        } else {
            var optionListArray = [ItemOption]()
            if let optionListDict = snapshot.value as? [String : AnyObject] {
                for (k,v) in optionListDict {
                    let optionData = ItemOption()
                    optionData.itemId = itemId as String
                    optionData.optionId = k as String
                    if let optionValue = v as? [String: String] {
                        if let title = optionValue["optionTitle"] {
                            optionData.optionName = title
                        }
                        if let price = optionValue["optionPrice"] {
                            optionData.optionPrice = price
                        }
                    }
                    optionListArray.append(optionData)
                }
            }
            callback?(optionListArray, nil)
        }
        }
    }
    
    
    // MARK: - CREATE / ADD / SAVE
    
    
    // SAVE ITEM - #1
    
    func saveItem(itemName: String, itemPrice: String, itemImage: UIImage?, categoryDictOfArray: [String: [String]], completion: @escaping (Bool) -> ()) {
        guard let itemUID = mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).childByAutoId().key else {
            return
        }
        if let itemImage = itemImage {
            if let imageData = itemImage.jpegData(compressionQuality: 0.3) {
                let imageName = NSUUID().uuidString
                let storageRef = imagesStorageRef.child("\(imageName).jpeg")
                storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                    if let _ = error {
                        return
                    }
                    storageRef.downloadURL(completion: { (url, error) in
                        if let downloadURL = url {  self.itemImageUrlString = downloadURL.description }
                        if let error = error {
                            print(error.localizedDescription)
                        }
                        let itemDetails: Dictionary<String, AnyObject> = [
                            "itemName": itemName as AnyObject,
                            "itemPrice": itemPrice as AnyObject,
                            "itemImageURL": self.itemImageUrlString as AnyObject
                        ]
                        let item: Dictionary<String, AnyObject> = [
                            "itemDetails": itemDetails as AnyObject
                        ]
                        self.saveData(itemUID: itemUID, item: item, categoryDictOfArray: categoryDictOfArray, completion: completion)
                    })
                })
            }
        } else {
            let itemDetails: Dictionary<String, AnyObject> = [
                "itemName": itemName as AnyObject,
                "itemPrice": itemPrice as AnyObject
            ]
            let item: Dictionary<String, AnyObject> = [
                "itemDetails": itemDetails as AnyObject
            ]
            self.saveData(itemUID: itemUID, item: item, categoryDictOfArray: categoryDictOfArray, completion: completion)
        }
    }
    
    // SAVE ITEM - #2
    
    func saveData(itemUID: String, item: Dictionary<String, AnyObject>, categoryDictOfArray: [String: [String]], completion: @escaping (Bool) -> ()) {
        self.mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).child(itemUID).updateChildValues(item) { (error, ref) in
            if let _ = error {
                completion(false)
            } else {
                let itemDetailsNode: Dictionary<String, AnyObject> = [
                    "itemDetails": item["itemDetails"] as AnyObject
                ]
                let categoryUIDs = categoryDictOfArray.keys
                for category in categoryUIDs {
                    print(category)
                    self.mainRef.child(self.FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(self.FIR_MENU).child("CategoryDetails").child(category).child(itemUID).updateChildValues(itemDetailsNode) { (error, ref) in
                        if let error = error {
                            print("ERROR CREATING IMAGE IN DATABASE --- ERROR DESCRIPTION: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            let breakfastCategoryUIDs = categoryDictOfArray.filter { $0.value.contains("Breakfast") }.map{$0.key}
                            let lunchCategoryUIDs = categoryDictOfArray.filter { $0.value.contains("Lunch") }.map{$0.key}
                            let dinnerCategoryUIDs = categoryDictOfArray.filter { $0.value.contains("Dinner") }.map{$0.key}
                            var arrBreakFast: [String: Any]
                            var arrlunch: [String: Any]
                            var arrDinner: [String: Any]
                            if let breakfastCategoryUIDsKey = breakfastCategoryUIDs.first {
                                arrBreakFast = [itemUID: itemDetailsNode]
                                self.mainRef.child(self.FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(self.FIR_MENU).child(self.FIR_AVAILABILITY).child(self.FIR_BREAKFAST).child(self.FIR_CATEGORIES).child(breakfastCategoryUIDsKey).child(self.FIR_ITEMS).updateChildValues(arrBreakFast)
                            }
                            if let lunchCategoryUIDsKey = lunchCategoryUIDs.first {
                                arrlunch = [itemUID: itemDetailsNode]
                                self.mainRef.child(self.FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(self.FIR_MENU).child(self.FIR_AVAILABILITY).child(self.FIR_LUNCH).child(self.FIR_CATEGORIES).child(lunchCategoryUIDsKey).child(self.FIR_ITEMS).updateChildValues(arrlunch)
                            }
                            if let dinnerCategoryUIDsKey = dinnerCategoryUIDs.first {
                                arrDinner = [itemUID: itemDetailsNode]
                                self.mainRef.child(self.FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(self.FIR_MENU).child(self.FIR_AVAILABILITY).child(self.FIR_DINNER).child(self.FIR_CATEGORIES).child(dinnerCategoryUIDsKey).child(self.FIR_ITEMS).updateChildValues(arrDinner)
                            }
                            completion(true)
                        }
                    }
                }
            }
        }
    }
 
    // SAVE RESTAURANT & ADMIN - TO RESTAURANT NODE & SETTINGS
      
      func saveRestaurant(restaurantUID: String, adminEmail: String, restaurantName: String) {
          let restaurantData: Dictionary<String, AnyObject> = [
              "restaurantName": restaurantName as AnyObject,
              "adminEmail": adminEmail as AnyObject
          ]
          mainRef.child(FIR_RESTAURANTS).child(restaurantUID).child(FIR_SETTINGS).setValue(restaurantData)
      }
      
      // SAVE ADMIN - TO ADMINISTRATORS NODE
      
      func saveToAdministratorsNode(adminUID: String, restaurantUID: String) {
          let adminData: Dictionary<String, AnyObject> = [
              adminUID: restaurantUID as AnyObject
          ]
          mainRef.child(FIR_ADMINISTRATORS).updateChildValues(adminData)
      }
      
      // SAVE STAFF - TO RESTAURANT NODE
      
      func saveStaffMember(staffMemberUID: String, staffMemberEmail: String, staffMemberType: String) {
          let lowercasedStaffEmail = staffMemberEmail.lowercased()
          let staffMemberData: Dictionary<String, AnyObject> = [
              "staffEmail": lowercasedStaffEmail as AnyObject,
              "staffType": staffMemberType as AnyObject
          ]
          mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_STAFF_MEMBERS).child(staffMemberUID).updateChildValues(staffMemberData) { (error, ref) in
              if let error = error {
                  print(error.localizedDescription)
              } else {
                  self.saveToStaffNode(staffMemberUID: staffMemberUID, restaurantUID: DataService.RESTAURANT_UID)
              }
          }
      }
      
      // SAVE STAFF - TO MAIN STAFF NODE
      
      func saveToStaffNode(staffMemberUID: String, restaurantUID: String) {
          let data: Dictionary<String, String> = [
              staffMemberUID: restaurantUID
          ]
          mainRef.child(FIR_STAFF_MEMBERS).updateChildValues(data)
      }
      
      //    func getStaff(callback: ((_ staffMembers: [StaffMember]?, _ error: Error?) -> Void)?) {
      //        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_STAFF_MEMBERS).observeSingleEvent(of: .value) { (snapshot) in
      //            if let dict = snapshot.value as? [String: Any] {
      //                if let staffDict = dict["Staff"] as? [String: Any] {
      //                    let keysList = staffDict.keys
      //                    var allKeys = [String]()
      //                    var staffDictionaryArray: [[String: Any]] = []
      //                    for key in keyList {
      //                        if let staffMemberDictionary = staffDict[key] as? [String: Any] {
      //                            allKeys.append(key)
      //                            staffDictionaryArray.append(staffMemberDictionary)
      //                        }
      //                    }
      //                }
      //            }
      //        }
      //    }
      
    
    // ADD ITEM OPTION
    
    func addEditItemOption(itemId: String, optionId: String, optionValue: [String: AnyObject]) {  mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_MENU).child("Items").child(itemId).child("itemDetails").child("itemOption").child(optionId).updateChildValues(optionValue)
    }
    
    // SAVE TABLE NUMBERS
    
    func saveNumberOfTables(tableStartNumber: String, tableEndNumber: String) {
        let data: Dictionary<String, AnyObject> = [
            "tableStartNumber": tableStartNumber as AnyObject,
            "tableEndNumber": tableEndNumber as AnyObject
        ]
        mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_SETTINGS).updateChildValues(data)
    }
    
    // SAVE TAXES & DISCOUNTS
    
    func saveTaxesAndDiscounts(settings: [String: AnyObject]) {
        mainRef.child(FIR_RESTAURANTS).child(DataService.RESTAURANT_UID).child(FIR_SETTINGS).updateChildValues(settings)
    }
    
    // SAVE ITEM OPTION
    
    func saveItemOption(itemUID: String, completion: @escaping (Bool) -> ()) {
        //       mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("CategoryDetails").child(category).child(itemUID).
        //        let itemOptionUID = mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).child().childByAutoId().key
        //        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).update
    }
    
    
    
    
    
    
}
