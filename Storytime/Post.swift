//
//  Post.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/30/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import CoreData
import CloudKit


class Post: SyncableObject, CloudKitManagedObject {
    
    static let kType = "Post"
    static let kWord = "word"
    static let kStory = "story"
    static let kTimestamp = "timestamp"
    
    convenience init(story: Story, word: String, timestamp: NSDate = NSDate(), context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext){
        
        guard let entity = NSEntityDescription.entityForName(Post.kType, inManagedObjectContext: context) else { fatalError() }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.word = word
        self.timestamp = timestamp
        self.story = story
        self.recordName = nameForManagedObject()
        
    }

    func matchesSearchTerm(searchTerm: String) {
        return (user).filter({$0.matchesSearchTerm(searchTerm)}).count > 0
    }

    
    var recordType: String = Post.kType
    
    var cloudKitRecord: CKRecord? {
        let recordID = CKRecordID(recordName: recordName)
        let record = CKRecord(recordType: recordType, recordID: recordID)
        
        record[Post.kWord] = word
        record[Post.kTimestamp] = timestamp
        
        guard let story = story,
            storyRecord = story.cloudKitRecord else {
                fatalError("post doesn't have a Story relationship. \(#function)")
        }
        
        record[Post.kWord] = CKReference(record: storyRecord, action: .DeleteSelf)
        return record
    }
    
    convenience required init?(record: CKRecord, context: NSManagedObjectContext = Stack.sharedStack.managedObjectContext) {
        guard let timestamp = record.creationDate,
            word = record[Post.kWord] as? String,
            storyReference = record[Post.kStory] as? CKReference else {
                return nil
        }
        
        guard let entity = NSEntityDescription.entityForName(Post.kType, inManagedObjectContext: context)
            else {
                fatalError("Error: Core Data Failed to create Entity from Entity description \(#function)")
        }
        
        self.init(entity: entity, insertIntoManagedObjectContext: context)
        self.timestamp = timestamp
        self.word = word
        self.recordIDData = NSKeyedArchiver.archivedDataWithRootObject(record.recordID)
        
        if let story = StoryController.sharedController.storyWithName(storyReference.recordID.recordName) {
            self.story = story
        }
    }
    
    
    
}
