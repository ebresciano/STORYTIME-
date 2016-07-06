//
//  UserController.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 7/5/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import UIKit

class UserController {
    
    var users = [User]()
    
    var currentUser: User?
    
    static let sharedController = UserController()
    
    private let userDataKey = "userData"
    
    init() {
        
        let userDictionary = NSUserDefaults.standardUserDefaults().objectForKey(userDataKey) as? [String: AnyObject] ?? [:]
        currentUser = User(dictionary: userDictionary)
    }

   func createUser(username: String, password: String) {
        
        let newUser = User(username: username, password: password)
        
        currentUser = newUser
        
        NSUserDefaults.standardUserDefaults().setObject(newUser.dictionaryCopy, forKey: userDataKey)
        
    }
    
}
