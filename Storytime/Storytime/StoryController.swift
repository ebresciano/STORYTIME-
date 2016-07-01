//
//  StoryController.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/29/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import Foundation
import UIKit
import CloudKit
import CoreData

class StoryController {
    
    static let sharedController =  StoryController()
    
    var stories = [Story]()
    
    init() {
    
    self.cloudKitManager = CloudKitManager()
        subscribeToNewStories { (success, error) in
            if success {
                print("successfully subscribed to new story")
            }
        }
    }
    
    let cloudKitManager: CloudKitManager
    
    var isSyncing: Bool = false
    
    func saveContext() {
        do {
            try Stack.sharedStack.managedObjectContext.save()
        } catch {
            print("Very sorry, could not save")
        }
    }
    
    
    func removeStory(story: Story) {
        if let indexOfStory = stories.indexOf(story) {
            stories.removeAtIndex(indexOfStory)
        }
    }
    
    func createStory(title: String, post: [Post], completion: (() -> Void)?) {
        let story = Story(post: post, title: title)
        addPostToStory(title, story: story, completion: nil)
        saveContext()
    }
    
    func addPostToStory(word: String, story: Story, completion: ((success: Bool) -> Void)?) {
        let post = Post(story: story, word: word)
        saveContext()
    }
    
    func storyWithName(name: String) -> Story? {
        if name.isEmpty {
            return nil
        }
        
        let fetchRequest = NSFetchRequest(entityName: Story.kType)
        let predicate = NSPredicate(format: "recordName == %@", argumentArray: [name])
        fetchRequest.predicate = predicate
        
        let result = (try? Stack.sharedStack.managedObjectContext.executeFetchRequest(fetchRequest)) as? [Story] ?? nil
        
        return result?.first
    }
    
    func syncedRecords(type: String) -> [CloudKitManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: type)
        fetchRequest.predicate = NSPredicate(format: "recordIDData != nil")
        
        let moc = Stack.sharedStack.managedObjectContext
        let results = (try? moc.executeFetchRequest(fetchRequest)) as? [CloudKitManagedObject] ?? []
        return results
    }
    
    func unsyncedRecords(type: String) -> [CloudKitManagedObject] {
        let fetchRequest = NSFetchRequest(entityName: type)
        fetchRequest.predicate = NSPredicate(format: "recordIDData != nil")
        
        let moc = Stack.sharedStack.managedObjectContext
        let results = (try? moc.executeFetchRequest(fetchRequest)) as? [CloudKitManagedObject] ?? []
        return results
    }
    
    
    func fetchNewRecords(type: String, completion: (() -> Void)?) {
        let referencesToExclude = syncedRecords(type).flatMap {$0.cloudKitReference}
        let predicate: NSPredicate
        if referencesToExclude.isEmpty {
            predicate = NSPredicate(value: true)
        } else {
            predicate = NSPredicate(format: "NOT(recordID IN %@)", argumentArray: [referencesToExclude])
        }
        
        cloudKitManager.fetchRecordsWithType(type, predicate: predicate, recordFetchedBlock: { (record) in
            switch type {
            case Story.kType:
                let _ = Story(record: record)
            case Post.kType:
                let _ = Post(record: record)
            default: return
                
            }
            self.saveContext()
        }) { (records, error) in
            if let error = error {
                print("Error fetching new records from CloudKit: \(error)")
            }
            
            completion?()
        }
    }
    
    func pushChangesToCloudKit(completion: ((success: Bool, error: NSError?) -> Void)? = nil) {
        let unsavedManagedObjects = unsyncedRecords(Story.kType) + unsyncedRecords(Post.kType)
        let unsavedRecords = unsavedManagedObjects.flatMap { $0.cloudKitRecord }
        
        cloudKitManager.saveRecords(unsavedRecords, perRecordCompletion: { (record, error) in
            guard let record = record else { return }
            if let matchingManagedObject = unsavedManagedObjects.filter({$0.recordName == record.recordID.recordName}).first {
                matchingManagedObject.update(record)
            }
            
        }) { (records, error) in
            let success = records != nil
            completion?(success: success, error: error)
            
        }
    }
    
    func performFullSync(completion: (() -> Void)? = nil) {
        if isSyncing {
            if let completion = completion {
                completion()
            }
            
        } else {
            isSyncing = true
            pushChangesToCloudKit { (success) in
                self.fetchNewRecords(Story.kType) {
                    self.fetchNewRecords(Post.kType, completion: {
                        
                        self.isSyncing = false
                        if let completion = completion {
                            completion()
                            
                        }
                    })
                }
            }
        }
    }
    
    // MARK: - Subscriptions
    
    func subscribeToNewStories(completion: ((success: Bool, error: NSError?) -> Void)?) {
        let predicate = NSPredicate(value: true)
        cloudKitManager.subscribe(Story.kType, predicate: predicate, subscriptionID: "allStories", contentAvailable: true, options: .FiresOnRecordCreation) { (subscription, error) in
            if let completion = completion {
                let success = subscription != nil
                completion(success: success, error: error)
            }
        }
    }
    
    func checkSubscriptionToStoryPosts(story: Story, completion: ((subscribed: Bool) -> Void)?) {
        cloudKitManager.fetchSubscription(story.recordName) { (subscription, error) in
            if let completion = completion {
                let success = subscription != nil
                completion(subscribed: success)
            }
        }
    }
    
    func addSubscriptionToStoryPosts(story: Story, alertBody: String?, completion: ((success: Bool, error: NSError?) -> Void)?) {
        guard let recordID = story.cloudKitRecordID else {
            fatalError("unable to create cloudKitRereference for subscription") }
        let predicate = NSPredicate(format: "story == %@", argumentArray: [recordID])
        cloudKitManager.subscribe(Post.kType, predicate: predicate, subscriptionID: story.recordName, contentAvailable: true, alertBody: alertBody, desiredKeys: [Post.kType, Post.kStory], options: .FiresOnRecordCreation) { (subscription, error) in
            if let completion = completion {
                let success = subscription != nil
                completion(success:success, error: error)
            }
        }
    }
    
    func removeSubscriptionToStoryPosts(story: Story, completion: ((success: Bool, error: NSError?) -> Void)?) { let subscriptionID = story.recordName
        cloudKitManager.unsubscribe(subscriptionID) { (subscriptionID, error) in
            if let completion = completion {
                let success = subscriptionID != nil
                completion(success: success, error: error)
            }
        }
    }
    
    func toggleStoryPostsSubscription(story: Story, completion: ((success: Bool, isSubscribed: Bool, error: NSError?) -> Void)?) {
        cloudKitManager.fetchSubscriptions { (subscriptions, error) in
            if subscriptions?.filter({$0.subscriptionID == story.recordName}).first != nil {
                self.removeSubscriptionToStoryPosts(story, completion: { (success, error) in
                    if let completion = completion {
                        completion(success: success, isSubscribed: false, error: error)
                    }
                })
            } else {
                self.addSubscriptionToStoryPosts(story, alertBody: "A word was added to your story!", completion: { (success, error) in
                    if let completion = completion {
                        completion(success: success, isSubscribed: true, error: error)
                    }
                })
            }
        }
    }









    
}
