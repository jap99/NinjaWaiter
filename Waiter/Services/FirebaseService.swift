//
//  FirebaseService.swift
//  Waiter
//
//  Created by Javid Poornasir on 11/21/19.
//  Copyright © 2019 Javid Poornasir. All rights reserved.
//

import Foundation 
import FirebaseAuth
import FirebaseDatabase
import FirebaseStorage
import FirebaseFunctions
import Firebase
import CoreLocation


final class FirebaseService {
    
    private static let ref = Database.database().reference()
    private var location: CLLocation!
    lazy var functions = Functions.functions()
    static let instance = FirebaseService()
    private init() {}
    var spotId: String = ""
    static let uid = Auth.auth().currentUser?.uid
    static let email = Auth.auth().currentUser?.email
    private let reference = Storage.storage().reference()
    private let picRef = Storage.storage().reference().child("profileImages")
    private static let stripeRef = ref.child("Users").child(FirebaseService.uid!).child("stripe")
    
    // LOGOUT
    
    func logoutAndGoToStartVC() {
        do { try Auth.auth().signOut()
            KeychainService.removeKeychainWrapper { (success) in
                if !success {
                    KeychainService.removeKeychainWrapper { (_) in }    // try again if failed the first time
                }
            }
        } catch let signOutError as NSError {
            print ("ERROR SIGNING OUT: %@", signOutError)
        }
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let initial = storyboard.instantiateInitialViewController()
        UIApplication.shared.keyWindow?.rootViewController = initial
    }
    
    func logoutAndClearKeychain() {
        do { try Auth.auth().signOut()
            KeychainService.removeKeychainWrapper { (success) in
                if !success {
                    KeychainService.removeKeychainWrapper { (_) in }     // try again if failed the first time
                }
            }
        } catch let signOutError as NSError {
            print ("ERROR SIGNING OUT: %@", signOutError)
        }
    }
    
    // GET STRIPE CUSTOMER ID
    
    func getUserInfoFromDB(_ completion: @escaping (Bool) -> ()) { // gets info & immediately saves to cache
        if let user = Auth.auth().currentUser {
            FirebaseService.ref.child("Users").child(user.uid).observeSingleEvent(of: .value, with: { (snapshot) in
                if let dictionary = snapshot.value as? [String: Any],
                    let fn = dictionary["firstName"] as? String,
                    let ln = dictionary["lastName"] as? String,
                    let val = dictionary["bool"] as? String {
                    KeychainService.saveName(firstName: fn, lastName: ln)
                    KeychainService.saveFirebaseUID(id: user.uid)
                    KeychainService.saveUsersCurrentState(isHostOrNot: val)
                    if let connectAcctID = dictionary["hostConnectAccountID"] as? String {
                        KeychainService.savehostConnectAccountID(id: connectAcctID)
                    }
                    if let dict = dictionary["stripe"] as? [String: Any] {
                        if let stripeID = dict["stripeCustomerID"] as? String {
                            KeychainService.saveStripeCustomerID(id: stripeID)
                        }
                        if let last4 = dict["defaultsLast4"] as? String,
                            let id = dict["isDefault"] as? String,
                            let brand = dict["brand"] as? String,
                            let exp = dict["exp"] as? String {
                            KeychainService.saveStripeDefaultPaymentMethodInfo(id: last4, pm: id, exp: exp, brand: brand)
                        }
                    }
                    completion(true)
                } else {
                    print("UNEXPECTED ISSUE - UNABLE TO RETRIEVE USER'S INFORMATION FROM FIREBASE DB.")
                    completion(false)
                }
            }, withCancel: nil)
        } else {
            // TO DO - CALL THE LOGOUT FUNCTION & CLEAR OUT KEYCHAIN & THEN SEND USER TO THE LOGIN SCREEN
            self.logoutAndGoToStartVC()
        }
    }
    
  
    
    // MARK: - AUTH
    
    func reauthenticateUser(_ completion: @escaping (Bool, String?) -> ()) {
        let user = Auth.auth().currentUser
        print(KeychainService.getEmail())
        guard let email = KeychainService.getEmail(),
            let pw = KeychainService.getPW() else {
                let str: String = "ERROR - COULD NOT REAUTHENTICATE USER"
                print(str)
                completion(false, nil)
                return
        }
        let cred = EmailAuthProvider.credential(withEmail: email, password: pw)
        user?.reauthenticateAndRetrieveData(with: cred, completion: { (result, error) in
            if let error = error?.localizedDescription {
                completion(false, error)
            } else if let result = result {
                print(result)
                completion(true, nil)
            } else {
                let str: String = "NOT SURE WHAT HAPPENED"
                completion(false, str)
            }
        })
    }
    
    func signIn(_ email: UITextField, _ password: UITextField, _ completion: @escaping (Bool, String?) -> ()) {
        guard let e = email.text, let pw = password.text else {
            let str = "FORM NOT VALID"
            print(str)
            completion(false, str)
            return
        }
        Auth.auth().signIn(withEmail: e, password: pw, completion: { (user, error) in
            if let error = error?.localizedDescription {
                print(error.capitalized)
                completion(false, error)
                return
            } else if let user = user {
                print(InstanceID.instanceID())
                KeychainService.saveAuthToken(id: user.user.refreshToken!)
                KeychainService.saveEmail(id: e, pw: pw)
                completion(true, nil)
                return
            }
        })
    }
    
    func createUser(_ email: UITextField, _ password: UITextField, _ fn: UITextField, _ ln: UITextField, _ completion: @escaping (Bool, String?) -> ()) {
        guard let e = email.text,
                let pw = password.text else {
                let str = "ERROR CREATING USER"
                completion(false, str); return
        }
        Auth.auth().createUser(withEmail: e, password: pw) { (user, error) in
            if let user = user?.user {
                FirebaseService.cacheSomeData(user.refreshToken!, e, pw, user.uid)
                FirebaseService.saveToDB(fn: fn, ln: ln) { (success, errorString) in
                    if success {
                        completion(true, nil)
                    } else if let error = errorString {
                        completion(false, error)
                    }
                }
            } else if let error = error {
                print(error.localizedDescription.capitalized)
                completion(false, error.localizedDescription)
            }
        }
    }
 
    private static func cacheSomeData(_ token: String, _ e: String, _ pw: String, _ uid: String) {
        KeychainService.saveAuthToken(id: token)
        KeychainService.saveEmail(id: e, pw: pw)
        KeychainService.saveFirebaseUID(id: uid)
    }
    
    private static func saveToDB(fn: UITextField, ln: UITextField, _ completion: @escaping (Bool, String?) -> ()) {
        let key = KeychainService.getfirebaseUID()
        guard let fn1 = fn.text,
            let ln1 = fn.text else {
                let str: String = "First or last name not provided"
                completion(false, str)
                return
        }
        let params: [String: Any] = ["id": key as Any,
                                     "firstName": fn1,
                                     "lastName": ln1,
                                     "bool": "false",
                                     "address_verified": false]
        Database.database().reference().child("Users").child(key!).setValue(params) { (error, reference) in
            if let e = error?.localizedDescription {
                print(e.capitalized)
                completion(false, e)
                return
            }
            if KeychainService.getDisplayName() == nil {
                KeychainService.saveName(firstName: fn1, lastName: ln1)
            }
            if KeychainService.getfirebaseUID() == nil {
                KeychainService.saveFirebaseUID(id: key!)
            }
            let str: String = "Success- Added account details to database"
            print(str.capitalized)
            completion(true, str)
        }
    }
    
    
    // MARK: - GET
    
    
    func getCurrentlySignedInUser() {
        let _ = Auth.auth().addStateDidChangeListener { (auth, user) in
//            print(user?.email as Any)
            print(auth.addIDTokenDidChangeListener({ (auth, user) in
//                print(auth.currentUser?.metadata as Any)
//                print(user?.refreshToken as Any)
            }))
//             return the handle - will be needed for turning off the listener
        }
    }
    
    func getProfilePicture(_ completion: @escaping (UIImage?, Error?) -> ()) {
        picRef.child(FirebaseService.uid!).child("profile_picture").getData(maxSize: 1 * 1024 * 1024) { data, error in
            if let e = error {
                completion(nil, e)
            } else {
                let image = UIImage(data: data!)
                completion(image, nil)
            }
        }
    }
    
    
    // MARK: - ADD LISTENER
    
//    static func listenForDeletedPaymentMethod() {
//        stripeRef.observe(.childRemoved) { (snapshot) in
//            if let snap = snapshot.value as? [String: Any] {
//                print("LISTENER - PAYMENT METHOD DELETED")
//                print(snap)
//            }
//        }
//    }
//
//    static func listenForAddedPaymentMethod() {
//        stripeRef.observe(.childAdded) { (snapshot) in
//            if let snap = snapshot.value as? [String: Any] {
//                print("LISTENER - PAYMENT METHOD ADDED")
//                print(snap)
//            }
//        }
//    }
//
//    static func listenForChangedPaymentMethod() {
//        stripeRef.observe(.childChanged) { (snapshot) in
//            if let snap = snapshot.value as? [String: Any] {
//                print("LISTENER - PAYMENT METHOD CHANGED")
//                print(snap)
//            }
//        }
//    }
    
    
    // MARK: - REMOVE LISTENER
    
    static func removeListeners() {
        stripeRef.removeAllObservers()
    }
    
    // MARK: - SET
    
    
    func setUserProfilePic(url: URL) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.photoURL = url
        changeRequest?.commitChanges { (error) in
            // Check if error code is due to credential being too old
        }
    }
    
    func saveProfilePicToCacheAndDB(_ image: UIImage?, _ completion: @escaping (Bool, String?) -> Void) {
        guard let profileImage = image,
            let uploadData = profileImage.jpegData(compressionQuality: 0.2) else {
                let str: String = "ERROR - IMAGE NOT PROVIDED OR WAS UNABLE TO COMPRESS IT"
                completion(false, str)
                return
        }
        let name = NSUUID().uuidString
        let metadata = StorageMetadata()
        metadata.contentType = "image/jpeg"
        picRef.child(FirebaseService.uid!).child("profile_picture").child("\(name).jpg").putData(uploadData, metadata: metadata, completion: { (metadata, error) in
            if let error = error {
                let str: String = "ERROR - UNABLE TO SAVE IMAGE: \(error.localizedDescription.capitalized)"
                print(str)
                completion(false, str)
            } else {
                let str: String = "SUCCESS - UPLOADED PROFILE PIC TO FIREBASE STORAGE"
                print(str)
                KeychainService.saveUserProfilePicture(imageData: uploadData)           // save to cache
                completion(true, nil)
            }
        })
    }
    
    func setUserLanguage() {
        Auth.auth().languageCode = "en"
        // To apply the default app language instead of explicitly setting it.
         Auth.auth().useAppLanguage()
        // Good to set this before sending verification email
    }
    
    func linkAndRetrieveData() {
        
    }
    
    // MARK: - UPDATE
    
    func updateAuthToken(_ completion: @escaping (String?, Error?) -> ()) {
        let currentUser = Auth.auth().currentUser
        currentUser?.getIDTokenForcingRefresh(true) { idToken, error in
            if let error = error {
                completion(nil, error)
                return
            } else if let token = idToken {
                completion(token, nil)
            }
        }
    }
    
    func updateUsersDisplayName(displayName: String) {
        let changeRequest = Auth.auth().currentUser?.createProfileChangeRequest()
        changeRequest?.displayName = displayName
        changeRequest?.commitChanges { (error) in
            // Check if error code is due to credential being too old
        }
    }
    
    func turnOffListener(handle: NSObjectProtocol?) {
        // put in viewWillDisappear
        Auth.auth().removeStateDidChangeListener(handle!)
    }
    
    
    // MARK: - DELETE
    
    static func deleteDefaultPaymentMethod(_ pm: String, _ completion: @escaping (Bool, String?) -> ()) {
        if let _ = Auth.auth().currentUser {
            stripeRef.removeValue() { (error, result) in
                print(result)
                if let error = error?.localizedDescription {
                    print(error.capitalized)
                    completion(false, error)
                    return
                }
                completion(true, nil)
            }
        } else {
            print("USER NOT LOGGED IN")
        }
    }
    
    func deleteImage() {
        let uid = Auth.auth().currentUser!.uid
        FirebaseService.ref.child("").child("").removeValue { (error, ref) in
            
        }
        Storage.storage().reference(forURL: "").child("").child(uid).child("img.jpg").delete { error in
        }
    }
    
    // MARK: - REVOKE
    
    func revokeAllTokens() {
        InstanceID.instanceID().deleteID(handler: { (error) in
        
        })
    }
    
    func revokeScopeAccessForAnEntity() {
        InstanceID.instanceID().deleteToken(withAuthorizedEntity: "", scope: "", handler: { (error) in
            
        })
    }
    
}






// MARK: - ENUM


enum DatabaseRef {
    
    case root
    case users(uid: String)
    
    func reference() -> DatabaseReference {
        switch self {
        case .root:
            return rootRef
        default:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: DatabaseReference{
        return Database.database().reference()
    }
    
    private var path: String {
        switch self {
        case .root:
            return ""
        case .users(let uid):
            return "users/\(uid)"
        }
    }
    
    
}


// MARK: - ENUM


enum StorageRef {
    
    case root
    case profileImages
    
    func reference() -> StorageReference {
        switch self {
        case .root:
            return rootRef
        default:
            return rootRef.child(path)
        }
    }
    
    private var rootRef: StorageReference {
        return Storage.storage().reference()
    }
    
    private var path: String {
        switch self{
        case .root:
            return ""
        case .profileImages:
            return "profileImages"
        }
    }
    
    
}

// MARK: - CLASS


final class FIRImage {
    
    var image: UIImage
    var downloadURL: URL?
    var downloadURLString: String!
    var ref: StorageReference!
    
    init(image: UIImage) {
        self.image = image
    }
    
    func saveProfileImage(userUID: String, _ completion: @escaping (Error?) -> Void) {
        let resizedImage = image.resize()
        if let imageData = resizedImage.jpegData(compressionQuality: 0.75) {
            ref = StorageRef.profileImages.reference().child(userUID)
            downloadURLString = ref.description
            ref.putData(imageData, metadata: nil, completion: { (metaData, error) in
                completion(error)
            })
        }
    }
    
    
}

