//
//  SessionContentViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/4/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation

class SessionContentViewController: UIViewController {
    
    var currentSessionID : String?
    
    var curr_session: PFObject!

    @IBAction func joinButton(sender: AnyObject) {
        var findSession = PFQuery(className: "Sessions")
        curr_session = findSession.getObjectWithId(currentSessionID)
        var activeUsers = curr_session["active_users"] as [String]
        if find(activeUsers, localData.getUserID()) == nil {
            activeUsers.append(localData.getUserID())
            curr_session["active_users"] = activeUsers
            curr_session.saveInBackground()
        }
        localData.setSession(currentSessionID!)
        self.performSegueWithIdentifier("pushToLockedFromJoin", sender: self)
    }
    
    
    @IBOutlet weak var descript: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentUsersLabel: UILabel!
    
    var dataObject: PFObject? {
        didSet {
            
        }
    }
    
    func setLabels() {
        descript.text = "We're working on: " + (self.dataObject?.objectForKey("description") as String)
        locationLabel.text = "We're working at: " + (self.dataObject?.objectForKey("location") as String)
        locationLabel.sizeToFit()
        
        currentUsersLabel.text = ""
        var currentUsersList = (self.dataObject?.objectForKey("active_users") as [String])
        for userId in currentUsersList {
            var query = PFUser.query();
            query.whereKey("userID", equalTo: userId)
            var user = query.getFirstObject()
            //var user = query.getObjectWithId(userId) as PFObject
            var userName = user.objectForKey("username") as String
            if currentUsersLabel.text == "" {
                currentUsersLabel.text = userName
            } else {
                currentUsersLabel.text = currentUsersLabel.text! + "\n" + userName
            }
        }
        
        currentUsersLabel.numberOfLines = 0
        currentUsersLabel.sizeToFit()
        descript.numberOfLines = 0
        descript.sizeToFit()
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .grayColor()
        self.setLabels()

        currentSessionID = self.dataObject?.objectId
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "pushToLockedFromJoin" {
            (segue.destinationViewController as SessionLockedViewController).session = self.curr_session
        }
    }
    
    
}