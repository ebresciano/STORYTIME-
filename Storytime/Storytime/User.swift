//
//  User.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 7/2/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

class User: Equatable {
    
    private let kUsername = "username"
    private let kPassword = "password"
    
    var dictionaryCopy: [String:AnyObject] {
        return [kUsername: username, kPassword: password]
    }
    
    var username: String
    var password: String
    
    init(username: String, password: String) {
        self.username = username
        self.password = password
        
    }
    
    init?(dictionary:[String:AnyObject]) {
        guard let username = dictionary[kUsername] as? String,
        let password = dictionary[kPassword] as? String else {
            return nil }
        self.username = username
        self.password = password
        }
}

    func == (lhs: User, rhs: User) -> Bool {
    return lhs.username == rhs.username && lhs.password == rhs.password
    }
