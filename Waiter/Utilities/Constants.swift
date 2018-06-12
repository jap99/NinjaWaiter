//
//  Constants.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/6/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation
import UIKit



//Global user default
let _userDefault = UserDefaults.standard
let kUsername = "kUsername"
let kPassword = "kPassword"
let _appDel = UIApplication.shared.delegate as! AppDelegate

typealias Completion = (_ errMsg: String?, _ data: AnyObject?) -> Void

var RESTAURANT_UID: String!

var IS_USER_LOGGED_IN = false

// NODES

let FIR_RESTAURANTS = "Restaurants"
let FIR_STAFF_MEMBERS = "Staff"
let FIR_ADMINISTRATORS = "Administrators"
let FIR_SECTIONS = "Sections"
let FIR_DRINKS = "Drinks"
let FIR_PRINTERS = "Printers"
let FIR_SETTINGS = "Settings"

// PRINT STATEMENTS
let SUCCESSFUL_LOGIN = "SUCCESSFULLY LOGGED INTO FIREBASE"

// USER FACING MESSAGES
let DEFAULT_ERROR_MESSAGE = "There was error. We did not get data from the service."
let CREATE_ACCOUNT_MESSAGE = "Congratulations, your account was successfully created!"

let APP_NAME = "Waiter App"


// CELLS
let WAITER_CELL = "waiterCell"
let ADD_CATEGORY_CELL = "AddCategoryCell"
let ADD_ITEM_CELL = "AddItemCell"

// PATHS
let databaseKey = "https://waiter-d1f30.firebaseio.com/"
let storageKey = "gs://waiter-d1f30.appspot.com/"
