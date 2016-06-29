//
//  Post.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/27/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

class Post {
    let word: String
    let user: User
    
    init(word: String, user: User) {
        self.word = word
        self.user = user
    }
    
}