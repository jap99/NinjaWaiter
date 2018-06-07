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
                
            } else if let restaurant = result?.user {
                
                FIR_RESTAURANT_UID = restaurant.uid
                onComplete!(nil, restaurant)
                
                DataService.instance.saveRestaurant(restaurantUID: restaurant.uid, adminEmail: adminEmail, restaurantName: restaurantName)
                     
                    Auth.auth().signIn(withEmail: adminEmail, password: password, completion: { (result, error) in
                        
                        if error != nil {
                            
                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                            FIR_RESTAURANT_UID = nil
                            
                        } else if let restaurant = result?.user {
                            DataService.instance.saveStaffMember(staffMemberUID: restaurant.uid, staffMemberEmail: adminEmail, staffMemberType: "Admin")
                            onComplete?(nil, restaurant)
                            IS_USER_LOGGED_IN = true
                            print(SUCCESSFUL_LOGIN)
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
                    print(staffMember)
                    
                } else {
                    onComplete?(DEFAULT_ERROR_MESSAGE, nil)
                }
            }
        })
    }
    
    // LOGIN RESTAURANT
    
    func restaurantLogin(email: String, password: String, onComplete: Completion?) {
        
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if error != nil {
                
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    if errorCode == .userNotFound {
                        
                    } else {
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                    }
                    
                } else {
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                }
            } else {
                
                onComplete?(nil, user)
                IS_USER_LOGGED_IN = true
                print("LOGGED IN!~~!!!")
            }
            
        })
    }
    
    func staffMemberLogin() {
        
    }
    
    func logout() {
        FIR_RESTAURANT_UID = nil
    }
    
    func handleFirebaseError(error: NSError, onComplete: ((_ errMsg: String?, _ data: User?) -> Void)?) {
        print(error.debugDescription)
        if let errorCode = AuthErrorCode(rawValue: error.code) {
            switch (errorCode) {
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
