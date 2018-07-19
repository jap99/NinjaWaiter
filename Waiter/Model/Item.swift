//
//  Item.swift
//  Waiter
//
//  Created by Javid Poornasir on 6/14/18.
//  Copyright © 2018 Javid Poornasir. All rights reserved.
//

import Foundation


class Item {
    
    var uid: String!
    var title: String!
    var price: String!
    var imageURL: String?
    
    var itemList: [Item] = [Item]()
    
    // an item belongs to a category
    
    // an item can have multiple subitems (optional)
    
    init() {}
    
    init(uid: String, title: String, price: String, imageURL: String) {
        self.uid = uid
        self.title = title
        self.price = price
        self.imageURL = imageURL
    }
    
    init(dictionary: [String: AnyObject], itemId: String) {
//        if let uid = itemId,
//            let title = dictionary["title"] as? String,
//            let price = dictionary["price"] as? String {
//            self.uid = uid
//            self.title = title
//            self.price = price
//            self.imageURL = dictionary["imageURL"] as? String
//        }
    }
    
    
    
}
