//
//  Post+CoreDataProperties.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/29/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//
//  Choose "Create NSManagedObject Subclass…" from the Core Data editor menu
//  to delete and recreate this implementation file for your updated model.
//

import Foundation
import CoreData

extension Post {

    @NSManaged var word: String
    @NSManaged var story: Story?

}
