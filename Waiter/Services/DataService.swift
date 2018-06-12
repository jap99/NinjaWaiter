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
    
    func getRestaurantUID(userUID: String, completion:@escaping ((_ restD:String) -> ())) {
        
        mainRef.child(FIR_STAFF_MEMBERS).child(userUID).observe(.value) { (snapshot) in
            
            if snapshot.exists() {
                if let restID = snapshot.value as? String {
                    completion(restID)
                }
            }
        }
        // To get user's UID to compare it in Staff node to identify which restaurant user's with
    }
    
    // ADD CATEGORY - TO RESTAURANT NODE
    
    func addCategory() {
        
    }
    
    func addItemToCategory() {
        
    }
    
    func sendProductImage(senderUID: String, imageURL: URL, thumbnail: String, timeStamp: String, title: String, description: String) {
        
        let autoOrderId = mainRef.child("").childByAutoId().key
        
        let pr: Dictionary<String, AnyObject> = [
            "mediaURL": imageURL.absoluteString as AnyObject,
            "thumbnail": thumbnail as AnyObject,
            "timeStamp": timeStamp as AnyObject,
            "userID": senderUID as AnyObject,
            "title": title as AnyObject,
            "description": description as AnyObject,
        ]
        
        mainRef.child("").child(autoOrderId).setValue(pr) { (err, ref) in
            
            if err != nil {
                let error = err
                print("ERROR CREATING IMAGE IN DATABASE --- ERROR DESCRIPTION: \(error.debugDescription)")
                
            } else {
 
            }
        }
    }
    
    
    
    
    
}
