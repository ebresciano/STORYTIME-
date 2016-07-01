//
//  SearchResultsTableViewController.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/27/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit
import CloudKit
import CoreData

class SearchResultsTableViewController: UITableViewController, NSFetchedResultsControllerDelegate, UISearchResultsUpdating {
    
    var searchController: UISearchController?
    var fetchedResultsController: NSFetchedResultsController?

    var resultsArray: [SearchableRecord] = []
    
    var userInfoArray: [CKDiscoveredUserInfo]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        print(resultsArray)
        setUpSearchController()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        StoryController.sharedController.cloudKitManager.fetchAllDiscoverableUsers { (userInfoRecords) in
            self.userInfoArray = userInfoRecords
        }
    }
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        print(resultsArray.count)
        return resultsArray.count
    }
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        print(resultsArray)
        guard let cell = tableView.dequeueReusableCellWithIdentifier("resultsCell", forIndexPath: indexPath) as? StoryTableViewCell,
        let result = resultsArray[indexPath.row] as? Story else {
                return UITableViewCell()
        }
        //cell.updateWithStory(result)
        
        return cell
    }
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let cell = tableView.cellForRowAtIndexPath(indexPath)
        self.presentingViewController?.performSegueWithIdentifier("toNewStory", sender: cell)
    }
    
    func setUpFetchedResultsController() {
        let request = NSFetchRequest(entityName: "Story")
        let dateSortDescription = NSSortDescriptor(key: "timestamp", ascending: false)
        
        request.returnsObjectsAsFaults = false
        request.sortDescriptors = [dateSortDescription]
        
        self.fetchedResultsController = NSFetchedResultsController(fetchRequest: request, managedObjectContext: Stack.sharedStack.managedObjectContext, sectionNameKeyPath: nil, cacheName: nil)
        
        do {
            try fetchedResultsController?.performFetch()
        } catch let error as NSError {
            print("Could not fetch results")
        }
        
        fetchedResultsController?.delegate = self
    }
    
    
    func setUpSearchController() {
        let resultsController = UIStoryboard(name: "Main", bundle: nil).instantiateViewControllerWithIdentifier("SearchResultsTableViewController") as? SearchResultsTableViewController
        searchController = UISearchController(searchResultsController: resultsController)
        searchController?.searchResultsUpdater = self
        tableView.tableHeaderView = searchController?.searchBar
    }
    
    func updateSearchResultsForSearchController(searchController: UISearchController) {
        guard let searchResultsController = searchController.searchResultsController as? SearchResultsTableViewController,
            let searchTerm = searchController.searchBar.text?.lowercaseString else { return }
        StoryController.sharedController.cloudKitManager.fetchAllDiscoverableUsers { (userInfoRecords) in
            if let userInfoArray = userInfoRecords {
                
                searchResultsController.userInfoArray = userInfoArray.filter({ $0.displayContact == searchTerm })
                searchResultsController.tableView.reloadData()
            }
        }
    }
    
}
