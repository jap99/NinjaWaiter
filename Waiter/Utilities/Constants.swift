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

// GLOBAL VARIABLES
let APP_NAME = "Waiter App"
var _currentUser = AppUser()
var RESTAURANT_UID: String!
var IS_USER_LOGGED_IN = false
let _userDefault = UserDefaults.standard
let kUsername = "kUsername"
let kPassword = "kPassword"
let _appDel = UIApplication.shared.delegate as! AppDelegate

// NODES
let FIR_RESTAURANTS = "Restaurants"
let FIR_STAFF_MEMBERS = "Staff"
let FIR_ADMINISTRATORS = "Administrators"
let FIR_SECTIONS = "Sections"
let FIR_DRINKS = "Drinks"
let FIR_PRINTERS = "Printers"
let FIR_SETTINGS = "Settings"
let FIR_CATEGORY = "Category"
let FIR_ITEMS = "Items"
let FIR_MENU = "Menu"

// PRINT STATEMENTS
let SUCCESSFUL_LOGIN = "SUCCESSFULLY LOGGED INTO FIREBASE"

// USER FACING MESSAGES
let DEFAULT_ERROR_MESSAGE = "There was error. We did not get data from the service."
let CREATE_ACCOUNT_MESSAGE = "Congratulations, your account was successfully created!"

// CELLS
let WAITER_CELL = "waiterCell"
let ADD_CATEGORY_CELL = "AddCategoryCell"
let ADD_ITEM_CELL = "AddItemCell"

// PATHS
let databaseKey = "https://waiter-d1f30.firebaseio.com/"
let storageKey = "gs://waiter-d1f30.appspot.com/"

// COLORS
//if #available(iOS 10.0, *) {
//    let customPink = UIColor(displayP3Red: 252/255, green: 55/255, blue: 104/255, alpha: 1)
//} else {
//    let customPink = UIColor(red: 252.0/255.0, green: 55.0/255.0, blue: 104.0/255.0, alpha: 1.0)
//}


