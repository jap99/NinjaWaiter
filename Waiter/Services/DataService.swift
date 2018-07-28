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

class DataService {
    
    private static let _instance = DataService()
    
    static var instance: DataService {
        return _instance
    }
    
    var databaseUrl: String {
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
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_STAFF_MEMBERS).child(staffMemberUID).updateChildValues(staffMemberData) { (error, ref) in
            
            if let error = error {
                print(error.localizedDescription)
            } else {
                self.saveToStaffNode(staffMemberUID: staffMemberUID, restaurantUID: RESTAURANT_UID)
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
    //
    //        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_STAFF_MEMBERS).observeSingleEvent(of: .value) { (snapshot) in
    //
    //            if let dict = snapshot.value as? [String: Any] {
    //
    //                if let staffDict = dict["Staff"] as? [String: Any] {
    //
    //                    let keysList = staffDict.keys
    //
    //                    var allKeys = [String]()
    //
    //                    var staffDictionaryArray: [[String: Any]] = []
    //
    //                    for key in keyList {
    //
    //                        if let staffMemberDictionary = staffDict[key] as? [String: Any] {
    //
    //                            allKeys.append(key)
    //
    //                            staffDictionaryArray.append(staffMemberDictionary)
    //                        }
    //                    }
    //                }
    //
    //            }
    //        }
    //    }
    
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
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).updateChildValues(categoryData) { (error, ref) in
            
            if error != nil {
                print(error?.localizedDescription ?? "ERROR RENAMING CATEGORY")
            } else {
                print(ref)
            }
        }
    }
    
    
    // DELETE CATEGORY
    
    func deleteCategory(categoryUID: String, completion: @escaping (Bool) -> ()) {
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).child(categoryUID).removeValue { (error, reference) in
            
            if let error = error {
                
                print(error.localizedDescription)
                
            } else {
                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).child(FIR_BREAKFAST).child(FIR_CATEGORIES).child(categoryUID).removeValue { (error, reference) in
                    
                    if let error = error {
                        print("BREAKFAST - ERROR REMOVING CATEGORY: \(error.localizedDescription)")
                    } else {
                        print("REMOVED CATEGORY FROM BREAKFAST NODE")
                    }
                }
                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).child(FIR_LUNCH).child(FIR_CATEGORIES).child(categoryUID).removeValue { (error, reference) in
                    
                    if let error = error {
                        print("LUNCH - ERROR REMOVING CATEGORY: \(error.localizedDescription)")
                    } else {
                        print("REMOVED CATEGORY FROM LUNCH NODE")
                    }
                    
                }
                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).child(FIR_DINNER).child(FIR_CATEGORIES).child(categoryUID).removeValue { (error, reference) in
                    
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
        
        let categoryUID = mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORIES).child(FIR_CATEGORY).childByAutoId().key
        
        let category: Dictionary<String, AnyObject> = [
            categoryUID: categoryName as AnyObject
        ]
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).updateChildValues(category) { (error, ref) in
            
            if let error = error {
                print("ERROR CREATING IMAGE IN DATABASE --- ERROR DESCRIPTION: \(error.localizedDescription)")
                completion(false)
            } else {
                completion(true)
                
            }
        }
    }
    
    // GET CATEGORIES (1/2)
    
    func getCategories(callback: ((_ categories: [Category]?, _ error: Error?) -> Void)?) {
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).observe(.value) { (snapshot) in
            
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
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).observe(.value) { (snapshot) in
            
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            }
            Singleton.sharedInstance.categoriesItems = Category.parseCategoryData(snapshot: snapshot)
        }
    }
    
    // SAVE ITEM - #1
    
    func saveItem(itemName: String, itemPrice: String, itemImage: UIImage?, categoryDictOfArray: [String: [String]], completion: @escaping (Bool) -> ()) {
        
        let itemUID = mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).childByAutoId().key
        
        if let itemImage = itemImage {
            if let imageData = UIImageJPEGRepresentation(itemImage, 0.4) {
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
        
        self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).child(itemUID).updateChildValues(item) { (error, ref) in
            
            if let _ = error {
                completion(false)
            } else {
                
                let itemDetailsNode: Dictionary<String, AnyObject> = [
                    "itemDetails": item["itemDetails"] as AnyObject
                ]
                
                let categoryUIDs = categoryDictOfArray.keys
                
                for category in categoryUIDs {
                    print(category)
                      self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("CategoryDetails").child(category).child(itemUID).updateChildValues(itemDetailsNode) { (error, ref) in
                        
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
                                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).child(FIR_BREAKFAST).child(FIR_CATEGORIES).child(breakfastCategoryUIDsKey).child(FIR_ITEMS).updateChildValues(arrBreakFast)
                            }
                            if let lunchCategoryUIDsKey = lunchCategoryUIDs.first {
                                arrlunch = [itemUID: itemDetailsNode]
                                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).child(FIR_LUNCH).child(FIR_CATEGORIES).child(lunchCategoryUIDsKey).child(FIR_ITEMS).updateChildValues(arrlunch)
                            }
                            if let dinnerCategoryUIDsKey = dinnerCategoryUIDs.first {
                                arrDinner = [itemUID: itemDetailsNode]
                                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).child(FIR_DINNER).child(FIR_CATEGORIES).child(dinnerCategoryUIDsKey).child(FIR_ITEMS).updateChildValues(arrDinner)
                            }
                            completion(true)
                        }
                    }
                }
            }
        }
    }
    
    func getCategoryItems(categoryUID: String, callback: ((_ categories: [String: AnyObject]?, _ error: Error?) -> Void)?) {
       
        if categoryUID != "" {
       mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("CategoryDetails").child(categoryUID).observe(.value) { (snapshot) in
                
                if !snapshot.exists() {
                    callback?(nil, nil)
                    return
                } else {
                    print(snapshot.value as AnyObject)
                    callback?((snapshot.value as! [String : AnyObject]), nil)
                }
            }
        } else {
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("CategoryDetails").observe(.value) { (snapshot) in
                
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
    
    
    
    func getItemOption(itemId: String, callback: ((_ categories: [[String: AnyObject]]?, _ error: Error?) -> Void)?) {
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("Items").child(itemId).child("itemDetails").child("itemOption").observe(.value) { (snapshot) in
            
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            } else {
                var optionListArray = [[String: AnyObject]]()
                if let optionListDict = snapshot.value as? [String : AnyObject] {
                    for (k,v) in optionListDict {
                        var optionData = [String: AnyObject]()
                        optionData["key"] = k as AnyObject
                        optionData["value"] = v
                        optionListArray.append(optionData)
                    }
                }
                callback?(optionListArray, nil)
            }
        }
    }
    
    // SAVE TABLE NUMBERS
    
    func saveNumberOfTables(tableStartNumber: String, tableEndNumber: String) {
        
        let data: Dictionary<String, AnyObject> = [
            "tableStartNumber": tableStartNumber as AnyObject,
            "tableEndNumber": tableEndNumber as AnyObject
        ]
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_SETTINGS).updateChildValues(data)
    }
    
    // SAVE TAXES & DISCOUNTS
    
    func saveTaxesAndDiscounts(settings: [String: AnyObject]) {
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_SETTINGS).updateChildValues(settings)
    }
    
    // GET SETTINGS DATA
    
    func getSettingsData(callback: ((_ categories: [String: AnyObject]?, _ error: Error?) -> Void)?) { // Includes table numbers
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_SETTINGS).observe(.value) { (snapshot) in
            
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
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).observe(.value) { (snapshot: DataSnapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                let availability = Availability(dict:snapshot)
                Singleton.sharedInstance.availabilityData = [availability]
            }
        }
    }
    
    // SAVE ITEM OPTION
    
    func saveItemOption(itemUID: String, completion: @escaping (Bool) -> ()) {
        
 //       mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("CategoryDetails").child(category).child(itemUID).
        //        let itemOptionUID = mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).child().childByAutoId().key
        //
        //        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).update
    }
    
    
    
    
    
}
