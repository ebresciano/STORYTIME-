//
//  Story+CoreDataProperties.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/30/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Story {

    @NSManaged var title: String?
    @NSManaged var posts: NSOrderedSet?

}
