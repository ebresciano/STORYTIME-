//
//  StoryListTableViewController.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/27/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit
import CoreData


class StoryListTableViewController: UITableViewController {
    
    var fetchedResultsController: NSFetchedResultsController?
    
    override func viewDidLoad() {
       
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // MARK: - Table view data source

    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 0
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return 0
    }
    
   


    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCellWithIdentifier("storyTableViewCell", forIndexPath: indexPath) as? StoryTableViewCell,
        let story = fetchedResultsController?.objectAtIndexPath(indexPath) as? Story else {
            return StoryTableViewCell()
        }
        cell.textLabel?.text = story.title
        cell.detailTextLabel?.text = "\(story.timestamp)"
        cell.updateWithStory(story)
        return cell
    }
    
   // Override to support editing the table view.
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        if editingStyle == .Delete {
            let story = StoryController.sharedController.stories[indexPath.row]
            StoryController.sharedController.removeStory(story)
            tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: .Fade)
        } else if editingStyle == .Insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    
    
    // MARK: - Navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toStoryDetail" {
            let storyDVC = segue.destinationViewController as? StoryDetailViewController
            if let indexPath = tableView.indexPathForSelectedRow {
                let story = StoryController.sharedController.stories[indexPath.row]
                storyDVC?.story = story
            }
         }
      }
}
    


