//
//  LoginViewController.swift
//  Cramr v2.0
//
//  Created by Roberto Alvarez on 1/31/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation



class LoginViewController: UIViewController, FBLoginViewDelegate {
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var fbLoginView: FBLoginView!
    
    
    //var loggedInUser = FBGraphUser()

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        nameLabel.text = ""
        self.fbLoginView.delegate = self
        self.fbLoginView.readPermissions = ["public_profile", "email", "user_friends"]
        
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        NSLog("User Logged In")
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        NSLog("User: \(user)")
        NSLog("User ID: \(user.objectID)")
        NSLog("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        NSLog("User Email: \(userEmail)")
        nameLabel.text = user.name
        //self.performSegueWithIdentifier("toMaster", sender: self)
        
    }
    
    func loginViewShowingLoggedOutUser(loginView : FBLoginView!) {
        NSLog("User Logged Out")
    }
    
    func loginView(loginView : FBLoginView!, handleError:NSError) {
        NSLog("Error: \(handleError.localizedDescription)")
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
    
}