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
    
    var session: PFObject? {
        didSet {
            
        }
    }
    
    @IBAction func leaveSession(sender: AnyObject) {
        var query = PFQuery(className: "Sessions")
        var users = session?.objectForKey("active_users") as [String]
        users.removeAtIndex(find(users, currentUserInfo.userID)!)
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
        className.text = (self.session?.objectForKey("course") as String)
    }
    
}
