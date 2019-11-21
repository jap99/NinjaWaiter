//
//  Constants.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit
 
typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void




let APP_NAME = "Waiter App"
var _currentUser = AppUser()
var RESTAURANT_UID: String!
var IS_USER_LOGGED_IN = false
let _userDefault = UserDefaults.standard
let kUsername = "kUsername"
let kPassword = "kPassword"
let _appDel = UIApplication.shared.delegate as! AppDelegate


let customBlue = UIColor(red: 26/255.0, green: 31/255.0, blue: 51/255.0, alpha: 1)
let customLightGray = UIColor(red: 242/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1)
let customRed = UIColor(red: 252/255.0, green: 55/255.0, blue: 104/255.0, alpha: 1)
let customRed2 = UIColor(red: 222/255.0, green: 55/255.0, blue: 104/255.0, alpha: 0.5)
let customGreen = UIColor(red: 112/255.0, green: 204/255.0, blue: 118/255.0, alpha: 1)






// MARK: - CLASS



class Constants {
    
    private static let _instance = Constants()
    static var instance: Constants {
        return _instance
    }
    private init() {}

    // GLOBAL VARIABLES

    static let APP_NAME = "Waiter App"
    static var _currentUser = AppUser()
    static var RESTAURANT_UID: String!
    static var IS_USER_LOGGED_IN = false
    static let _userDefault = UserDefaults.standard
    static let kUsername = "kUsername"
    static let kPassword = "kPassword"
    static let _appDel = UIApplication.shared.delegate as! AppDelegate


    // NODES

    static let FIR_RESTAURANTS = "Restaurants"
    static let FIR_STAFF_MEMBERS = "Staff"
    static let FIR_ADMINISTRATORS = "Administrators"
    static let FIR_SECTIONS = "Sections"
    static let FIR_DRINKS = "Drinks"
    static let FIR_PRINTERS = "Printers"
    static let FIR_SETTINGS = "Settings"
    static let FIR_CATEGORY = "Category"
    static let FIR_CATEGORIES = "Categories"
    static let FIR_AVAILABILITY = "Availability"
    static let FIR_ITEMS = "Items"
    static let FIR_MENU = "Menu"
    static let FIR_BREAKFAST = "Breakfast"
    static let FIR_LUNCH = "Lunch"
    static let FIR_DINNER = "Dinner"


    // PRINT STATEMENTS

    static let SUCCESSFUL_LOGIN = "SUCCESSFULLY LOGGED INTO FIREBASE"


    // USER FACING MESSAGES

    static let DEFAULT_ERROR_MESSAGE = "There was error. We did not get data from the service."
    static let CREATE_ACCOUNT_MESSAGE = "Congratulations, your account was successfully created!"


    // CELLS

    static let WAITER_CELL = "waiterCell"
    static let ADD_CATEGORY_CELL = "AddCategoryCell"
    static let ADD_ITEM_CELL = "AddItemCell"


    // PATHS

    let databaseKey = "https://waiter-9249e.firebaseio.com/"
    let storageKey = "gs://waiter-9249e.appspot.com/"

    static let customBlue = UIColor(red: 26/255.0, green: 31/255.0, blue: 51/255.0, alpha: 1)
    static let customLightGray = UIColor(red: 242/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1)
    static let customRed = UIColor(red: 252/255.0, green: 55/255.0, blue: 104/255.0, alpha: 1)
    static let customRed2 = UIColor(red: 222/255.0, green: 55/255.0, blue: 104/255.0, alpha: 0.5)
    static let customGreen = UIColor(red: 112/255.0, green: 204/255.0, blue: 118/255.0, alpha: 1)

    
    
        static let publishableKey = "pk_live_xs" // only used to create tokens
    //    static let publishableKey = "pk_test_N1"
        static let baseURLString = "https://myurl.herokuapp.com"
        static let defaultCurrency = "usd"
        static let defaultDescription = "FIKX TEST"
        static let firebaseDatabaseURL = "https://waiter-9249e.firebaseio.com/"
        static let STRIPE_CUSTOMER_ID: String = "stripeCustomerID"
        static let HOST_CONNECT_ACCOUNT_ID: String = "hostConnectAccountID"
        static let STRIPE_PAYMENT_METHOD: String = "stripePaymentMethod"
        static let KEY_UID: String = "uid"
        static let username: String = "un"
        static let password: String = "pw"
        static let firstName: String = "fn"
        static let displayName: String = "dn"
        static let lastName: String = "ln"
    
    
}
