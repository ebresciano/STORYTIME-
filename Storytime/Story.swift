//
//  Story.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/29/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import CoreData
import UIKit
import CloudKit



class Story: SyncableObject, CloudKitManagedObject {
    
    static let kType = "story"
    static let kPost = "post"
    static let kTitle = "title"
    static let kTimestamp = "timestamp"
    
    
    convenience init(post: [Post], title: String, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        
        guard let entity = NSEntityDescription.entityForName(Story.kType, inManagedObjectContext: context) else { fatalError() }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.timestamp = timestamp
        self.recordName = self.nameForManagedObject()
        self.title = title
    }
    
    var recordType: String = Story.kType
    
    var cloudKitRecord: CKRecord? {
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        record[Story.kTimestamp] = timestamp
        record[Story.kTitle] = title
        return record
    }
    
     convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let timestamp = record.creationDate,
        title = record[Story.kTitle] as? CKReference else {
            return nil
        }
        
        guard let entity = NSEntityDescription.entityForName(Story.kType, inManagedObjectContext: context)
            else { fatalError("Error: CoreData failed to create entity from entity description. \(#function)") }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.timestamp = timestamp
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        self.recordName = record.recordID.recordName

    }


    
}
