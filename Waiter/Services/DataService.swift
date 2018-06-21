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
    
    // SAVE RESTAURANT & ADMIN - TO RESTAURANT NODE
    
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
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_STAFF_MEMBERS).child(staffMemberUID).updateChildValues(staffMemberData)
    }
    
    // SAVE STAFF - TO MAIN STAFF NODE
    
    func saveToStaffNode(staffMemberUID: String, restaurantUID: String) {
        
        let data: Dictionary<String, String> = [
            staffMemberUID: restaurantUID
        ]
        
        mainRef.child(FIR_STAFF_MEMBERS).updateChildValues(data)
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
    
    // SAVE CATEGORY - TO RESTAURANT NODE
    
    func saveCategory(categoryName: String, completion :@escaping (Bool) -> ()) {
        
        let categoryUID = mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("Categories").child(FIR_CATEGORY).childByAutoId().key
        
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
    
    // GET CATEGORIES
    
    func getCategories(callback: ((_ categories: [Category]?, _ error: Error?) -> Void)?) {
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).observe(.value) { (snapshot) in
            
            print(snapshot)
            
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            }
            callback?(Category.parseCategoryData(snapshot: snapshot),nil)
            Singleton.sharedInstance.categoriesItems = Category.parseCategoryData(snapshot: snapshot)
        }
    }
    
    
    func getCategoriesFromServer(callback: ((_ categories: [Category]?, _ error: Error?) -> Void)?) {
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_CATEGORY).observe(.value) { (snapshot) in
            
            print(snapshot)
            
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            }
            Singleton.sharedInstance.categoriesItems = Category.parseCategoryData(snapshot: snapshot)
        }
    }
    
    // SAVE ITEM - TO ITEMS NODE & AVAILABILITY NODE
    var itemImageUrlString: String?
    
    func saveItem(itemName: String, itemPrice: String, itemImage: UIImage?, categoryDictOfArray: [String: [String]], completion: @escaping (Bool) -> ()) {
        
        let itemUID = mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).childByAutoId().key
        
        if let imageData = UIImageJPEGRepresentation(itemImage!, 0.3) {
            
            let imageName = NSUUID().uuidString
            
            let storageRef = imagesStorageRef.child("\(imageName).jpeg")
            
            storageRef.putData(imageData, metadata: nil, completion: { (metadata, error) in
                
                if let error = error {
                    print("PRINTING ERROR UPLOADING PROFILE IMAGE TO FIREBASE - ERROR DESCRIPTION: \(error.localizedDescription)")
                    return
                }
                
                storageRef.downloadURL(completion: { (url, error) in
                    if let downloadURL = url {
                        self.itemImageUrlString = downloadURL.description
                    }
                    if let error = error {
                        print(error.localizedDescription)
                    }
                    
                    
                    let itemDetails: Dictionary<String, AnyObject> = [
                        "itemName": itemName as AnyObject,
                        "itemPrice": itemPrice as AnyObject,
                        "itemImageURL": self.itemImageUrlString as AnyObject
                    ]
                    
                    let item: Dictionary<String, AnyObject> = [
                        "Categories": categoryDictOfArray as AnyObject,
                        "ItemDetails": itemDetails as AnyObject,
                        "itemImageURL": self.itemImageUrlString as AnyObject
                    ]
                    self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_ITEMS).child(itemUID).updateChildValues(item) { (error, ref) in
                        
                        if let error = error {
                            print("ERROR CREATING IMAGE IN DATABASE --- ERROR DESCRIPTION: \(error.localizedDescription)")
                            completion(false)
                        } else {
                            
                            let itemDetailsNode: Dictionary<String, AnyObject> = [
                                "ItemDetails": itemDetails as AnyObject
                            ]
                            
                            let breakfastCategoryUIDs = categoryDictOfArray.filter { $0.value.contains("Breakfast") }.map{$0.key}
                            let lunchCategoryUIDs = categoryDictOfArray.filter { $0.value.contains("Lunch") }.map{$0.key}
                            let dinnerCategoryUIDs = categoryDictOfArray.filter { $0.value.contains("Dinner") }.map{$0.key}
                            
                            var arrBreakFast: [String: Any]
                            var arrlunch: [String: Any]
                            var arrDinner: [String: Any]
                            
                            if let breakfastCategoryUIDsKey = breakfastCategoryUIDs.first {
                                arrBreakFast = [itemUID: itemDetailsNode]
                                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("Availability").child("Breakfast").child("Categories").child(breakfastCategoryUIDsKey).child("Items").updateChildValues(arrBreakFast)
                            }
                            if let lunchCategoryUIDsKey = lunchCategoryUIDs.first {
                                arrlunch = [itemUID: itemDetailsNode]
                                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("Availability").child("Lunch").child("Categories").child(lunchCategoryUIDsKey).child("Items").updateChildValues(arrlunch)
                            }
                            if let dinnerCategoryUIDsKey = dinnerCategoryUIDs.first {
                                arrDinner = [itemUID: itemDetailsNode]
                                self.mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("Availability").child("Dinner").child("Categories").child(dinnerCategoryUIDsKey).child("Items").updateChildValues(arrDinner)
                            }
                            
                            completion(true)
                        }
                    }
                })
            })
        }
    }
    
    // SAVE TABLE NUMBERS
    
    func saveNumberOfTables(tableStartNumber: String, tableEndNumber: String, restaurantUID: String) {
        
        let data: Dictionary<String, AnyObject> = [
            "tableStartNumber": tableStartNumber as AnyObject,
            "tableEndNumber": tableEndNumber as AnyObject
        ]
        
        mainRef.child(FIR_RESTAURANTS).child(restaurantUID).child(FIR_SETTINGS).updateChildValues(data)
    }
    
    
    // GET SETTINGS DATA
    
    func getSettingsData(callback: ((_ categories: [String: AnyObject]?, _ error: Error?) -> Void)?) { // Includes table numbers
        
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_SETTINGS).observe(.value) { (snapshot) in
            
            print(snapshot.value!)
            
            if !snapshot.exists() {
                callback?(nil, nil)
                return
            } else {
                
                Singleton.sharedInstance.settingsData = Settings.parseSettingData(snapshot: snapshot)
                callback?((snapshot.value as! [String : AnyObject]), nil)
            }
        }
    }
    
    
    func getAvailabilityDataFromServer() {
          mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child(FIR_AVAILABILITY).observe(.value) { (snapshot: DataSnapshot) in
            
            if let snapshot = snapshot.children.allObjects as? [DataSnapshot] {
                
                let availability = Availability(dict:snapshot)
                print(availability)
                Singleton.sharedInstance.availabilityData = [availability]
            }
            
        }
    }
    
    
}
