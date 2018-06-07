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
    
//    var usersRef: DatabaseReference {
//        //return mainRef.child(FIR_CHILD_USERS).child((Auth.auth().currentUser?.uid)!).child("profile")
//    }
    
//    var imagesRef: DatabaseReference {
//        //return mainRef.child(FIR_CHILD_IMAGES)
//        var one: Int = 1
//    }
    
    var mainStorageRef: StorageReference {
        return Storage.storage().reference(forURL: storageKey)
    }
    
    var imagesStorageRef: StorageReference {
        return mainStorageRef.child("images")
    }
    
    func saveRestaurant(restaurantUID: String, adminEmail: String, restaurantName: String) {
        let restaurantData: Dictionary<String, AnyObject> = [
        "restaurantName": restaurantName as AnyObject,
        "adminEmail": adminEmail as AnyObject
        ]
        
        mainRef.child(FIR_RESTAURANTS).child(restaurantUID).setValue(restaurantData)
    }
    
    func saveWaiter(uid: String, email: String) {
        
        let lowercasedEmail = email.lowercased()
        
        let profile: Dictionary<String, AnyObject> = ["email": email as AnyObject]
      //  mainRef.child(FIR_CHILD_USERS).child(uid).child("profile").setValue(profile)
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
       //         let location: CLLocation = CLLocation(latitude: locationLattitude, longitude: locationLongitude)
                
//                if let geoFire = GeoFire(firebaseRef: DataService.instance.mainRef.child("videos-locations")) {
//
//                    geoFire.setLocation(location, forKey: "\(autoOrderId)") { (error) in
//                        if (error != nil) {
//                            debugPrint("An error occured: \(error)")
//                        } else {
//                            print("Saved location successfully!")
//                        }
//                    }
//
//                    print("\(geoFire.description)")
//                } else {
//                    print("FAIL TO INITIALIZE GEOFIRE")
//                }
            }
        }
    }
    
    
    
    
    
}
