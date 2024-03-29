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
    
    // SAVE RESTAURANT
    
    func saveRestaurant(restaurantUID: String, adminEmail: String, restaurantName: String) {
        let restaurantData: Dictionary<String, AnyObject> = [
            "restaurantName": restaurantName as AnyObject,
            "adminEmail": adminEmail as AnyObject   
        ]
        
        mainRef.child(FIR_RESTAURANTS).child(restaurantUID).child(FIR_SETTINGS).setValue(restaurantData)
      
    }
    
    // SAVE STAFF MEMBER
    
    func saveStaffMember(staffMemberUID: String, staffMemberEmail: String, staffMemberType: String) {
        
        let lowercasedStaffEmail = staffMemberEmail.lowercased()
        
        let staffMemberData: Dictionary<String, AnyObject> = [
            "staffEmail": lowercasedStaffEmail as AnyObject,
            "staffType": staffMemberType as AnyObject
        ]
       
        mainRef.child(FIR_RESTAURANTS).child(RESTAURANT_UID).child(FIR_STAFF_MEMBERS).child(staffMemberUID).updateChildValues(staffMemberData)
        //saveToStaffNode(staffMemberUID: staffMemberUID, restaurantUID: RESTAURANT_UID)
    }
    
    // SAVE USER TO MAIN STAFF NODE
    
    func saveToStaffNode(staffMemberUID: String, restaurantUID: String) {
   
        let data: Dictionary<String, String> = [
            staffMemberUID: restaurantUID
        ]
        
        mainRef.child(FIR_STAFF_MEMBERS).updateChildValues(data)
    }
    
    
    // SAVE TO ADMINISTRATORS NODE
    
    func saveToAdministratorsNode(adminUID: String, restaurantUID: String) {
        
        let adminData: Dictionary<String, AnyObject> = [
            adminUID: restaurantUID as AnyObject
        ]
        
        mainRef.child(FIR_ADMINISTRATORS).updateChildValues(adminData)
    }
    
    func getRestaurantUID(userUID: String, completion:@escaping ((_ restD:String) -> ())) {
        
        //mainRef.child(FIR_STAFF_MEMBERS).child(userUID).observe(<#T##eventType: DataEventType##DataEventType#>, with: <#T##(DataSnapshot) -> Void#>)
        mainRef.child(FIR_STAFF_MEMBERS).child(userUID).observe(.value) { (snapshot) in
            
            if snapshot.exists() {
                if let restID = snapshot.value as? String {
                    completion(restID)
                }
            }
        }
        // first get user's UID
        // then compare it in the Staff node & find out which restaurant user is part of
        
    }
    
    
    
    
    
    func updateUserProfileData(username: String?, firstName: String?, lastName: String?, email: String?, uid: String, completionHandler: @escaping Completion ) {
        
        let data: Dictionary<String, AnyObject> = [
            "firstName": firstName as AnyObject,
            "lastName": lastName as AnyObject,
            "username": username as AnyObject,
            "email": email as AnyObject
        ]
        
    //    mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").updateChildValues(data) { (error, success) in
//            if error != nil {
//                completionHandler(nil, nil)
//            } else {
//                completionHandler(error?.localizedDescription, nil)
//            }
        
 //       }
    }
    
    
    func sendProductImage(senderUID: String, mediaURL: URL, thumbnail: String, locationCountry: String, locationRegion: String, locationState: String, locationLattitude: Double, locationLongitude: Double, timeStamp: String, title: String, description: String, hashtag: String) {
        
        let autoOrderId = mainRef.child("videos").childByAutoId().key
        
        let pr: Dictionary<String, AnyObject> = [
            "mediaURL": mediaURL.absoluteString as AnyObject,
            "thumbnail": thumbnail as AnyObject,
            "locationCountry": locationCountry as AnyObject,
            "locationRegion": locationRegion as AnyObject,
            "latitude": locationLattitude as AnyObject,
            "longitude": locationLongitude as AnyObject,
            "locationState": locationState as AnyObject,
            "timeStamp": timeStamp as AnyObject,
            "userID": senderUID as AnyObject,
            "numberOfViews": 0 as AnyObject,
            "openCount": 0 as AnyObject,
            //"createdOn": NSDate.getPresentDate(),
            "title": title as AnyObject,
            "description": description as AnyObject,
            "hashtag": hashtag as AnyObject
        ]
        
        mainRef.child("videos").child(autoOrderId).setValue(pr) { (err, ref) in
            
            if err != nil {
                let error = err
                print("ERROR CREATING VIDEO IN DATABASE --- ERROR DESCRIPTION: \(error.debugDescription)")
                
            } else {
 
            }
        }
    }
    
    
    
    
    
}
