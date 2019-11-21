//
//  KeychainService.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/21/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//
 
import Foundation
import SwiftKeychainWrapper


final class KeychainService {
    
    private init() {}
    
    private static let isHostRightNow: String = "isUserOnlineAsHost"
    private static let defaultPayMethod: String = "defaultPaymentMethodID"
    private static let firstName: String = "firstName01d111af"
    private static let lastName: String = "lastNamegasdf4"
    private static let displayName1: String = "displayName03shbf4"
    private static let stripeCustomerID: String = "stripeCustomerIDbhfa"
    private static let stripeDefaultsLast4: String = "defaultsLast4abhfa"
    private static let firebaseUID: String = "firebaseUIDParkr04555a111dfa"
    private static let hostConnectAccountID: String = "hostConnectAccountIDParkr0f00iW8QYuAM"
    private static let profilePic: String = "usersProfilePictureasdfadff34"
    private static let auth: String = "2346256lagh2p25hp25p2"
    private static let email: String = "2346256lagh2777p25hp25p2"
    private static let pass: String = "2346256lagh2777p99977d25hp25p2"
    private static let exp: String = "2asdf00uuu6lagh2777p99977d25hp25p2"
    private static let brand: String = "2346256l5634565634kagfhpa"
    
    
    // MARK: - CLEAR KEYCHAIN
    
    
    static func removeKeychainWrapper(_ completion: @escaping (Bool) -> ()) {
        if KeychainWrapper.standard.removeAllKeys() {   // remove keys
            KeychainWrapper.wipeKeychain()              // wipe chain
            print("KEYCHAIN CLEARED")
            completion(true)
        } else {
            completion(false)
        }
    }
    
    static func removeCacheForDefaultPaymentMethods() {
        KeychainWrapper.standard.removeObject(forKey: defaultPayMethod, withAccessibility: .whenUnlocked)
        KeychainWrapper.standard.removeObject(forKey: stripeDefaultsLast4, withAccessibility: .whenUnlocked)
        KeychainWrapper.standard.removeObject(forKey: stripeCustomerID, withAccessibility: .whenUnlocked)
    }
    
    // MARK: - SAVING
    
    
    static func saveName(firstName: String, lastName: String) {
        let displayName = "\(firstName)" + " " + "\(lastName)"
        let firstNameSaveSuccessful: Bool = KeychainWrapper.standard.set(firstName, forKey: firstName, withAccessibility: .whenUnlocked)
        let lastNameSaveSuccessful: Bool = KeychainWrapper.standard.set(lastName, forKey: lastName, withAccessibility: .whenUnlocked)
        let displayNameSaveSuccessful: Bool = KeychainWrapper.standard.set(displayName, forKey: displayName1, withAccessibility: .whenUnlocked)
//        print("SAVED - FIRST NAME: \(firstNameSaveSuccessful)")
//        print("SAVED - LAST NAME: \(lastNameSaveSuccessful)")
//        print("SAVED - FULL NAME: \(displayNameSaveSuccessful)")
    }
    
    static func saveStripeCustomerID(id: String) {
        let idSaveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: stripeCustomerID, withAccessibility: .whenUnlocked)
        print("SAVED - STRIPE CUSTOMER ID: \(idSaveSuccessful)")
    }
    
    static func saveStripeDefaultPaymentMethodInfo(id: String, pm: String, exp: String, brand: String) {
        let last4: Bool = KeychainWrapper.standard.set(id, forKey: stripeDefaultsLast4)
        let pm1: Bool = KeychainWrapper.standard.set(pm, forKey: defaultPayMethod, withAccessibility: .whenUnlocked)
        let exp1: Bool = KeychainWrapper.standard.set(pm, forKey: exp, withAccessibility: .whenUnlocked)
        let brand1: Bool = KeychainWrapper.standard.set(pm, forKey: brand, withAccessibility: .whenUnlocked)
        print("SAVED - PM: \(pm1)")
        print("SAVED - EXP: \(exp1)")
        print("SAVED - BRAND: \(brand1)")
        print("SAVED - LAST4 PM: \(last4)")
    }
    
    static func saveFirebaseUID(id: String) {
        let idSaveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: firebaseUID, withAccessibility: .whenUnlocked)
//        print("SAVED - FB UID: \(idSaveSuccessful)")
    }
    
    static func savehostConnectAccountID(id: String) {
        let idSaveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: hostConnectAccountID, withAccessibility: .whenUnlocked)
//        print("SAVED - CONNECT ACCOUNT: \(idSaveSuccessful)")
    }
    
    static func saveUsersCurrentState(isHostOrNot: String) {
        let val: Bool = KeychainWrapper.standard.set(isHostOrNot, forKey: isHostRightNow, withAccessibility: .whenUnlocked)
//        print("SAVED - IS USER HOST?: \(val)")
    }
    
    static func saveUserProfilePicture(imageData: Data) {
        let result: Bool = KeychainWrapper.standard.set(imageData, forKey: profilePic, withAccessibility: .whenUnlocked)
//        print("SAVED - PROFILE PICTURE: \(result)")
    }
    
    static func saveAuthToken(id: String) {
        let idSaveSuccessful: Bool = KeychainWrapper.standard.set(id, forKey: auth, withAccessibility: .whenUnlocked)
//        print("SAVED - TOKEN: \(idSaveSuccessful)")
    }
    
    static func saveEmail(id: String, pw: String) {
        let e: Bool = KeychainWrapper.standard.set(id, forKey: email, withAccessibility: .whenUnlocked)
        KeychainWrapper.standard.set(pw, forKey: pass, withAccessibility: .whenUnlocked)
//        print("SAVED - EMAIL TO KEYCHAIN: \(e)")
    }
    
    static func saveEmail(id: String) {
        let e: Bool = KeychainWrapper.standard.set(id, forKey: email, withAccessibility: .whenUnlocked)
//        print("SAVED - EMAIL TO KEYCHAIN: \(e)")
    }
    
    
    
    // MARK: - RETRIEVAL
    
    
    
    static func getFirstName() -> String? {
        let firstName1: String? = KeychainWrapper.standard.string(forKey: firstName, withAccessibility: .whenUnlocked)
//        print("CACHED - FB - FIRST NAME: \(String(describing: firstName))")
        return firstName1
    }
    
    static func getLastName() -> String? {
        let lastName1: String? = KeychainWrapper.standard.string(forKey: lastName, withAccessibility: .whenUnlocked)
//        print("CACHED - FB - LAST NAME: \(String(describing: lastName))")
        return lastName1
    }
    
    static func getDisplayName() -> String? {
        let displayName: String? = KeychainWrapper.standard.string(forKey: displayName1, withAccessibility: .whenUnlocked)
//        print("CACHED - FB - FULL NAME: \(String(describing: displayName))")
        return displayName
    }
    
    static func getStripeCustomerID() -> String? {
        let stripeCustomerID1: String? = KeychainWrapper.standard.string(forKey: stripeCustomerID, withAccessibility: .whenUnlocked)
        print("GOT - STRIPE CUSTOMER ID: \(String(describing: stripeCustomerID1 ?? "nil"))")
        return stripeCustomerID1
    }
   
    static func getStripeDefaultsInfo() -> String? {
        let stripeDefaultsLast41: String? = KeychainWrapper.standard.string(forKey: stripeDefaultsLast4, withAccessibility: .whenUnlocked)
        let pm: String? = KeychainWrapper.standard.string(forKey: defaultPayMethod, withAccessibility: .whenUnlocked)
        print("GOT - PM INFO", stripeDefaultsLast41 ?? "nil", pm ?? "nil")
        return pm
    }
    
    static func getExp() -> String? {
        let pm: String? = KeychainWrapper.standard.string(forKey: exp, withAccessibility: .whenUnlocked)
        print("GOT - PM EXP: )", pm ?? "nil")
        return pm
    }
    
    static func getBrand() -> String? {
        let pm: String? = KeychainWrapper.standard.string(forKey: brand, withAccessibility: .whenUnlocked)
        print("GOT - PM BRAND: )", pm ?? "nil")
        return pm
    }
    
    static func getfirebaseUID() -> String? {
        let firebaseUID1: String? = KeychainWrapper.standard.string(forKey: firebaseUID, withAccessibility: .whenUnlocked)
//        print("CACHED - FB - UID: \(String(describing: firebaseUID1))")
        return firebaseUID1
    }
    
    static func gethostConnectAccountID() -> String? {
        let hostAccountID: String? = KeychainWrapper.standard.string(forKey: hostConnectAccountID, withAccessibility: .whenUnlocked)
//        print("CACHED - STRIPE - HOST CONNECT ACCOUNT UID: \(String(describing: hostAccountID))")
        return hostAccountID
    }
    
    static func isUserOnlineAsHost() -> String? {
        let val: String? = KeychainWrapper.standard.string(forKey: isHostRightNow, withAccessibility: .whenUnlocked)
//        print("CACHED - FB - IS USER HOST?: \(String(describing: val))")
        return val
    }
    
    static func getCachedProfilePic() -> Data? {
        let data: Data? = KeychainWrapper.standard.data(forKey: profilePic, withAccessibility: .whenUnlocked)
//        print("CACHED - FB - PROFILE PIC: \(String(describing: data))")
        return data
    }
    
    static func getAuthToken() -> String? {
        let t: String? = KeychainWrapper.standard.string(forKey: auth, withAccessibility: .whenUnlocked)
//        print("CACHED - FB - TOKEN: \(String(describing: t))")
        return t
    }
    
    static func getEmail() -> String? {
        let t: String? = KeychainWrapper.standard.string(forKey: email, withAccessibility: .whenUnlocked)
//        print("CACHED - FB - EMAIL: \(String(describing: t))")
        return t
    }
    
    static func getPW() -> String? {
        let t: String? = KeychainWrapper.standard.string(forKey: pass, withAccessibility: .whenUnlocked)
        return t
    }
    
    
}
