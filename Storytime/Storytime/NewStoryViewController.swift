//
//  NewStoryViewController.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 6/27/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit
import CoreData

class NewStoryViewController: UIViewController {
    
    @IBOutlet weak var bodyTextView: UITextView!
   
    @IBOutlet weak var storyTitle: UITextField!
    
    //var posts: [Post] = []
    
    //var story: [Post] = []
    
    let story = Story()
    
    var word: String = ""
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
   
    @IBAction func addWordToStoryButtonTapped(sender: AnyObject) {
        if let post = bodyTextView.text {
            StoryController.sharedController.addPostToStory(word, story: story, completion: { (success) in
             })
    } else {
            let alertController = UIAlertController(title: "Sorry buddy! You need to add a word first!", message: "Add a word!", preferredStyle: .Alert)
            alertController.addAction(UIAlertAction(title: "Ok", style: .Cancel, handler: nil))
            
            presentViewController(alertController, animated: true, completion: nil)
        }
    }

    
    @IBAction func theEnd(sender: AnyObject) {
        StoryController.sharedController.saveContext()
        let storyBoard = UIStoryboard(name: "Main", bundle: nil)
        let navController = storyBoard.instantiateViewControllerWithIdentifier("navController")
        self.presentViewController(navController, animated: true, completion: nil)
    }

    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
