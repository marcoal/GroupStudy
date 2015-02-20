//
//  SessionLockedViewController.swift
//  Cramr v2.0
//
//  Created by Anton Apostolatos on 2/9/15.
//  Copyright (c) 2015 Casa, Inc. All rights reserved.
//

import Foundation
import UIKit

class SessionLockedViewController: UIViewController {
    
    @IBOutlet weak var className: UILabel!
    
    @IBOutlet weak var desciptLabel: UILabel!
    
    @IBOutlet weak var locationLabel: UILabel!
    
    @IBOutlet weak var currentUsers: UILabel!
    
    var session: PFObject? {
        didSet {
            
        }
    }
    
    @IBAction func leaveSession(sender: AnyObject) {
        var query = PFQuery(className: "Sessions")
        self.session = query.getObjectWithId(self.session?.objectId)
        var users = session?.objectForKey("active_users") as [String]
        users.removeAtIndex(find(users, localData.getUserID())!)
        session?["active_users"] = users
        session?.saveInBackground()
        self.checkIfSessionIsEmpty()
        self.performSegueWithIdentifier("popToCourseView", sender: self)
    }
    
    func checkIfSessionIsEmpty() {
        var users = session?["active_users"] as [String]
        if users.isEmpty {
            session?.deleteInBackground()
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor = .darkGrayColor()
        
        navigationItem.hidesBackButton = true
        if self.session != nil {
            var fullCourseName = (self.session?.objectForKey("course") as String)
            className.text = getCourseID(fullCourseName)
            desciptLabel.text = "We're working on: " + (self.session?.objectForKey("description") as String)
            locationLabel.text = "We're working at: " + (self.session?.objectForKey("location") as String)
            
            desciptLabel.sizeToFit()
            locationLabel.sizeToFit()
            
            currentUsers.text = ""
            var currentUserList = (self.session?.objectForKey("active_users") as [String])
            for userId in currentUserList {
                var query = PFUser.query();
                query.whereKey("userID", equalTo: userId)
                var user = query.getFirstObject()
                //var user = query.getObjectWithId(userId) as PFObject
                var userName = user.objectForKey("username") as String
                if currentUsers.text == "" {
                    currentUsers.text = userName
                } else {
                    currentUsers.text = currentUsers.text! + "\n" + userName
                }
            }
            
            currentUsers.numberOfLines = 0
            currentUsers.sizeToFit()
            desciptLabel.numberOfLines = 0
            desciptLabel.sizeToFit()
        }

    }
    
}
