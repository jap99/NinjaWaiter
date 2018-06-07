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
    
    // If there's no instance created yet we create one here
    
    private static let _instance = AuthServices()
    var defaults = UserDefaults.standard
    
    static var instance: AuthServices {
        return _instance
    }
    
    func createRestaurant(adminEmail: String, restaurantName: String, password: String, onComplete: ((_ errMsg: String?, _ data: User?) -> Void)?) {
        
        Auth.auth().createUser(withEmail: adminEmail, password: password, completion: { (result, error) in
            
            if error != nil {
                
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                onComplete?(DEFAULT_ERROR_MESSAGE, nil)
                
            } else if let user = result?.user {
                
                onComplete!(nil, user)
                print(user)
                
                DataService.instance.saveRestaurant(restaurantUID: user.uid, adminEmail: adminEmail, restaurantName: restaurantName)
                
                Auth.auth().signIn(withEmail: adminEmail, password: password, completion: { (result, error) in
                    
                    if error != nil {
                        
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                        
                    } else if let user = result?.user { // We've logged in successfully
                        
                        onComplete?(nil, user)
                        IS_USER_LOGGED_IN = true
                        print("LOGGED IN222!~~!!!")
                    }
                })
                
            }
        })
    }
    
    func createStaffMember(staffEmail: String, password: String, onComplete: ((_ errMsg: String?, _ data: User?) -> Void)?) {
        
        Auth.auth().createUser(withEmail: staffEmail, password: password, completion: { (user, error) in
            
            if error != nil {
                
                self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                
            } else {
                
                if let firebaseUser = user?.user {
                    
                    onComplete?(nil, firebaseUser)
                    print(firebaseUser)
                    
                } else {
                    onComplete?(DEFAULT_ERROR_MESSAGE, nil)
                }
                
                //                if let restuarentId = user?.user.uid {
                //
                //                    DataService.instance.saveRestaurant(restaurantUID: restuarentId, adminEmail: adminEmail, restaurantName: restaurantName)
                //
                //                    Auth.auth().signIn(restaurantUID: restuarentId, withEmail: adminEmail, password: password, completion: { (user, error) in
                //
                //                        if error != nil {
                //
                //                            self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                //
                //                        } else { // We've logged in successfully
                //
                //                            onComplete?(nil, user)
                //                            IS_USER_LOGGED_IN = true
                //                            print("LOGGED IN222!~~!!!")
                //                        }
                //                    })
                //                }
            }
        })
    }
    
    func restaurantLogin(email: String, password: String, onComplete: Completion?) {
        Auth.auth().signIn(withEmail: email, password: password, completion: { (user, error) in
            
            if (error != nil) {
                
                if let errorCode = AuthErrorCode(rawValue: error!._code) {
                    if errorCode == .userNotFound {
                        
                    } else {
                        //Handle all other errors
                        self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                    }
                } else {
                    //Handle all other errors
                    self.handleFirebaseError(error: error! as NSError, onComplete: onComplete)
                }
            } else {
                //Successfully logged in
                onComplete?(nil, user)
                IS_USER_LOGGED_IN = true
                print("LOGGED IN!~~!!!")
            }
            
        })
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
