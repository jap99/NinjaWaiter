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
        // To get user's UID to compare it in Staff node to identify which restaurant user's with
    }
    
    // SAVE CATEGORY - TO RESTAURANT NODE
    
    func saveCategory(categoryName: String, completion :@escaping (Bool) -> ()) {
        
        let categoryUID = mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_MENU).child("Categories").child(FIR_CATEGORY).childByAutoId().key
        
        let pr: Dictionary<String, AnyObject> = [
            "categoryName": categoryName as AnyObject,
            "categoryID": categoryUID as AnyObject
        ]
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_CATEGORY).child(FIR_MENU).child(categoryUID).setValue(pr) { (err, ref) in
            
            if err != nil {
                let error = err
                print("ERROR CREATING IMAGE IN DATABASE --- ERROR DESCRIPTION: \(error.debugDescription)")
                completion(false)
            } else {
                completion(true)
                
            }
        }
    }
    
    func getCategories() {
        let refFireMenu = mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_CATEGORY).child(FIR_MENU)
//        let recentPostsQuery = (ref?.child("posts").queryLimited(toFirst: 100))!
        refFireMenu.observe(.value) { (snapshot) in
             if let childs = snapshot.children, childs.count > 0 {
            var  childObj = []
            for child in childs {
                print(child)
            }
        }
        // To get user's UID to compare it in Staff node to identify which restaurant user's with
    }
    
    func saveItemInCategory() {
        
    }
    
    func saveItemImage(itemUID: String, imageURL: URL) {
        
//        let autoOrderId = mainRef.child("").childByAutoId().key
//        
//        let pr: Dictionary<String, AnyObject> = [
//            "imageURL": imageURL.absoluteString as AnyObject
//            
//        ]
//        
//        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child().child(autoOrderId).setValue(pr) { (err, ref) in
//            
//            if err != nil {
//                let error = err
//                print("ERROR CREATING IMAGE IN DATABASE --- ERROR DESCRIPTION: \(error.debugDescription)")
//                
//            } else {
// 
//            }
//        }
    }
    
    
    
    
    
}
