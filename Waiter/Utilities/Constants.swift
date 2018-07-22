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
let FIR_CATEGORIES = "Categories"
let FIR_AVAILABILITY = "Availability"
let FIR_ITEMS = "Items"
let FIR_MENU = "Menu"
let FIR_BREAKFAST = "Breakfast"
let FIR_LUNCH = "Lunch"
let FIR_DINNER = "Dinner"

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
let databaseKey = "https://waiter-9249e.firebaseio.com/"
let storageKey = "gs://waiter-9249e.appspot.com/"

// COLORS

let customBlue = UIColor(red: 26/255.0, green: 31/255.0, blue: 51/255.0, alpha: 1)
let customLightGray = UIColor(red: 242/255.0, green: 243/255.0, blue: 247/255.0, alpha: 1)
let customRed = UIColor(red: 252/255.0, green: 55/255.0, blue: 104/255.0, alpha: 1)
let customGreen = UIColor(red: 112/255.0, green: 204/255.0, blue: 118/255.0, alpha: 1)
