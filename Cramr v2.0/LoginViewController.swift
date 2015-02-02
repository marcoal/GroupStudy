//
//  LoginViewController.swift
//  Cramr v2.0
//
//  Created by Roberto Alvarez on 1/31/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

struct currentUserInfo {
    static var userID = ""
}

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
    
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "toMaster" {
        }
    }
    
    func setCurrUser() {
        if (FBSession.activeSession().isOpen){
            var friendsRequest : FBRequest = FBRequest.requestForMe()
            friendsRequest.startWithCompletionHandler{(connection:FBRequestConnection!, result:AnyObject!,error:NSError!) -> Void in
                var resultdict = result as NSDictionary
                currentUserInfo.userID = resultdict["id"] as String
            }
        }
    }
    
    // Facebook Delegate Methods
    
    func loginViewShowingLoggedInUser(loginView : FBLoginView!) {
        NSLog("User Logged In")
//        setCurrUser()
    }
    
    func loginViewFetchedUserInfo(loginView : FBLoginView!, user: FBGraphUser) {
        NSLog("User: \(user)")
        NSLog("User ID: \(user.objectID)")
        NSLog("User Name: \(user.name)")
        var userEmail = user.objectForKey("email") as String
        NSLog("User Email: \(userEmail)")
        nameLabel.text = user.name
        
//        setCurrUser()
        
        var query = PFQuery(className: "Users")
        query.whereKey("userID", containsString: user.objectID)
        
        if query.countObjects() == 0 {
            var parse_user = PFUser()
            parse_user.username = user.name
            parse_user.password = ""
            parse_user.email = userEmail
            parse_user["userID"] = user.objectID
        
            parse_user.signUp()
        }
    
        currentUserInfo.userID = user.objectID
        self.performSegueWithIdentifier("toMaster", sender: self)
        
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