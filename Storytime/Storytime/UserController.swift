//
//  UserController.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 7/5/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import UIKit

private let allUsersKey = "allUsers"

class UserController {
    
    var users: [User] {
        var newList = [User]()
        if let userList = NSUserDefaults.standardUserDefaults().arrayForKey(allUsersKey) as? [[String: AnyObject]] {
            for dict in userList {
                if let u = User(dictionary: dict) {
                    newList.append(u)
                }
            }
            return newList
        }
        
        return []
    }
    
    var currentUser: User?
    
    static let sharedController = UserController()
    
    private let userDataKey = "userData"
    
    init() {
//        let userDictionary = NSUserDefaults.standardUserDefaults().objectForKey(userDataKey) as? [String: AnyObject] ?? [:]
//        currentUser = User(dictionary: userDictionary)
        
        guard let _ = NSUserDefaults.standardUserDefaults().arrayForKey(allUsersKey) as? [[String: AnyObject]] else {
            NSUserDefaults.standardUserDefaults().setObject(nil, forKey: allUsersKey)
            return
        }
        
    }

   func createUser(username: String, password: String) {
    var oldUsersList = NSUserDefaults.standardUserDefaults().arrayForKey(allUsersKey) as? [[String: AnyObject]] ?? [[String: AnyObject]]()
    let newUser = User(username: username, password: password)
    let newUserDictionary = newUser.dictionaryCopy
    oldUsersList.append(newUserDictionary)
    NSUserDefaults.standardUserDefaults().setObject(oldUsersList, forKey: allUsersKey)
    }
    
}
