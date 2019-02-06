//
//  AuthServicesss.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import FirebaseAuth

class AuthServices {
    
    private static let _instance = AuthServices()
    var defaults = UserDefaults.standard
    
    static var instance: AuthServices {
        return _instance
    }
    
    // CREATE RESTAURANT
    
    func createRestaurant(adminEmail: String, restaurantName: String, password: String, onComplete: ((_ errMsg: String?, _ data: User?) -> Void)?) {
        
        Auth.auth().createUser(withEmail: adminEmail, password: password, completion: { (result, error) in
            
            if error != nil {
                
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                onComplete?(DEFAULT_ERROR_MESSAGE, nil)
                
            } else if let user = result?.user {
                
                guard let restaurantUID = DataService.instance.mainRef.child(FIR_RESTAURANTS).childByAutoId().key else { return }
                
                RESTAURANT_UID = restaurantUID
                
                DataService.instance.saveToAdministratorsNode(adminUID: user.uid, restaurantUID: RESTAURANT_UID)
                DataService.instance.saveToStaffNode(staffMemberUID: user.uid, restaurantUID: RESTAURANT_UID)
                onComplete!(nil, user)
                
                DataService.instance.saveRestaurant(restaurantUID: restaurantUID, adminEmail: adminEmail, restaurantName: restaurantName)
                     
                    Auth.auth().signIn(withEmail: adminEmail, password: password, completion: { (result, error) in
                        
                        if error != nil {
                            
                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            RESTAURANT_UID = nil
                            
                        } else if let user = result?.user {
                            DataService.instance.saveStaffMember(staffMemberUID: user.uid, staffMemberEmail: adminEmail, staffMemberType: "Admin")
                            onComplete?(nil, user)
                            
                            print(SUCCESSFUL_LOGIN)
                            IS_USER_LOGGED_IN = true
                        }
                    })
            }
        })
    }
    
    // CREATE STAFF MEMBER
    
    func createStaffMember(staffEmail: String, password: String, onComplete: ((_ errMsg: String?, _ data: User?) -> Void)?) {
        
        Auth.auth().createUser(withEmail: staffEmail, password: password, completion: { (result, error) in
            
            if error != nil {
                
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                
                onComplete?(DEFAULT_ERROR_MESSAGE, nil)
                
            } else if error == nil {
                
                if let staffMember = result?.user {
                    
                    DataService.instance.saveStaffMember(staffMemberUID: staffMember.uid, staffMemberEmail: staffMember.email!, staffMemberType: "Staff")
                    
                    onComplete?(nil, staffMember)
                    
                } else {
                    onComplete?(DEFAULT_ERROR_MESSAGE, nil)
                }
            }
        })
    }
    
    // LOGIN RESTAURANT
    
    func restaurantLogin(email: String, password: String, onComplete: Completion?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (result, error) in
            
            if error != nil {                         // error
                
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                RESTAURANT_UID = nil
                
                
            } else if let result = result {          // no error
                
                // get restaurant uid
                
                DataService.instance.getRestaurantUID(userUID: result.user.uid, completion: { (restID) in
                    RESTAURANT_UID = restID
                    IS_USER_LOGGED_IN = true
                    onComplete?(nil, result.user)
                })
            }
        })
    }
    
    func staffMemberLogin() {
        
    }
    
    func checkIfUserIsAnAdmin() {
        
    }
    
    func logout() {
        RESTAURANT_UID = nil
    }
    
    func handleFirebaseError(error: NSError, onComplete: ((_ errMsg: String?, _ data: User?) -> Void)?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
            case .userNotFound:
                onComplete?("User Not Found", nil)
                break
            case .invalidEmail:
                onComplete?("Invalid email address", nil)
                break
            case .wrongPassword:
                onComplete?("Invalid password", nil)
                break
            case .emailAlreadyInUse, .accountExistsWithDifferentCredential:
                onComplete?("Could not create account. Email already in use", nil)
                break
            default:
                onComplete?("There was a problem authenticating. Try again.", nil)
            }
        }
    }
    
}
