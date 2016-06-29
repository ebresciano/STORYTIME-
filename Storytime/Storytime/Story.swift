//
//  Story.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/27/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation

class Story {
    let title: String
    let timestamp: NSDate
    let story: [Post]
    
    init(title: String, timestamp: NSDate, story: [Post]) {
        self.title = title
        self.timestamp = timestamp
        self.story = story
    }
    
}