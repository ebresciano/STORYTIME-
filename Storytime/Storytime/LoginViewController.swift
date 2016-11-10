//
//  LoginViewController.swift
//  Storytime
//
//  Created by Eva Marie Bresciano on 7/5/16.
//  Copyright © 2016 Eva Bresciano. All rights reserved.
//

import UIKit

class LoginViewController: UIViewController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBOutlet weak var usernameTextField: UITextField!
    
    @IBOutlet weak var passwordTextField: UITextField!
    
    @IBOutlet weak var loginButton: UIButton!
    
    @IBOutlet weak var needAccountButton: UIButton!
    
    @IBOutlet weak var submitButton: UIButton!
   
    
    enum Account {
        case existing
        case new
    }
    
    var account = Account.existing
    
    @IBAction func needAccountButtonTapped(sender: AnyObject) {
        updateLoginView()
    }
    
    @IBAction func sumbitButtonTapped(sender: AnyObject) {
        checkForAccount()
    }
    
       func updateLoginView() {
        if account == .existing  {
            account = .new
            usernameTextField.hidden = false
            passwordTextField.hidden = false
            submitButton.setTitle("YAY GET STARTED!", forState: .Normal)
            loginButton.setTitle("CREATE USER!", forState: .Normal)
            needAccountButton.setTitle("Have an account?!", forState: .Normal)
        } else {
            account = .existing
            loginButton.setTitle("LOGIN!", forState: .Normal)
            submitButton.setTitle("OK LET'S LOGIN!", forState: .Normal)
            needAccountButton.setTitle("Need an account?!", forState: .Normal)
        }
    }
    
    func checkForAccount() {
        if account == .existing {
            let allUsers = UserController.sharedController.users
            for user in allUsers {
                if user.username == usernameTextField.text && user.password == passwordTextField.text {
                    UserController.sharedController.currentUser = user
                    let storyBoard = UIStoryboard(name: "Main", bundle: nil)
                    let navController = storyBoard.instantiateViewControllerWithIdentifier("navController")
                    self.presentViewController(navController, animated: true, completion: nil)
                }
            }
        } else {
            if account == .new {
                if let username = usernameTextField.text where username.characters.count > 0, let password = passwordTextField.text where password.characters.count > 0 {
                    UserController.sharedController.createUser(username, password: password)
                   StoryController.sharedController.saveContext()
                }
            }
        }
    }
}

